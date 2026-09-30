// SPDX-License-Identifier: AGPL-3.0-or-later
//! Host-side paired tournament using the exact JSON/C entry point used by iOS.
use serde::{Deserialize, Serialize};
use serde_json::{Value, json};
use std::collections::HashSet;
use std::ffi::{CStr, CString};
use std::fs::{self, OpenOptions};
use std::io::{BufWriter, Write};
use std::path::Path;
use std::time::{Duration, Instant};

#[derive(Clone, Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
struct Player {
    algorithm: String,
    level: u8,
    #[serde(default = "legacy_scale")]
    level_scale: String,
    effort: String,
    #[serde(default = "balanced_style")]
    style: String,
}
fn balanced_style() -> String {
    "balanced".into()
}
fn legacy_scale() -> String {
    "three".into()
}
#[derive(Serialize, Deserialize)]
#[serde(deny_unknown_fields)]
struct Plan {
    seed: u64,
    pairs_per_variant: usize,
    presets: Vec<i32>,
    a: Player,
    b: Player,
    max_actions: usize,
    max_seconds: u64,
}
#[derive(Serialize, Deserialize)]
struct Opening {
    preset: i32,
    pair: usize,
    moves: Vec<String>,
    fen: String,
    canonical_board: Vec<i64>,
}

struct Random(u64);
impl Random {
    fn next(&mut self) -> u64 {
        self.0 = self.0.wrapping_add(0x9e3779b97f4a7c15);
        let mut z = self.0;
        z = (z ^ (z >> 30)).wrapping_mul(0xbf58476d1ce4e5b9);
        z = (z ^ (z >> 27)).wrapping_mul(0x94d049bb133111eb);
        z ^ (z >> 31)
    }
    fn index(&mut self, count: usize) -> usize {
        // Rejection sampling avoids modulo bias.
        let count = count as u64;
        let threshold = count.wrapping_neg() % count;
        loop {
            let value = self.next();
            if value >= threshold {
                return (value % count) as usize;
            }
        }
    }
}

fn query(preset: i32, moves: &[String], player: &Player, search: bool) -> Result<Value, String> {
    let input = CString::new(
        json!({"version":1,"preset":preset,"moves":moves,"search":search,
        "level":player.level,"level_scale":player.level_scale,
        "algorithm":player.algorithm,"effort":player.effort,"style":player.style})
        .to_string(),
    )
    .unwrap();
    // SAFETY: the request remains alive throughout the call; the owned result is freed once.
    let response = unsafe {
        let ptr = muehlenstein_engine::ms_request(input.as_ptr());
        if ptr.is_null() {
            return Err("nullResponse".into());
        }
        let bytes = CStr::from_ptr(ptr).to_bytes().to_vec();
        muehlenstein_engine::ms_string_free(ptr);
        bytes
    };
    let result: Value = serde_json::from_slice(&response).map_err(|e| e.to_string())?;
    if let Some(error) = result.get("error") {
        return Err(error.to_string());
    }
    Ok(result)
}

/// D4 canonicalization removes rotations/reflections of the same sampled board.
fn canonical(position: &Value) -> Vec<i64> {
    let nodes = position["nodes"].as_array().unwrap();
    let board = position["board"].as_array().unwrap();
    let mut candidates = Vec::new();
    for reflected in [false, true] {
        for rotations in 0..4 {
            let mut cells = Vec::new();
            for (node, stone) in nodes.iter().zip(board) {
                let mut x = (node["x"].as_f64().unwrap() * 1000.0).round() as i64 - 500;
                let mut y = (node["y"].as_f64().unwrap() * 1000.0).round() as i64 - 500;
                if reflected {
                    x = -x;
                }
                for _ in 0..rotations {
                    (x, y) = (-y, x);
                }
                cells.push((x, y, stone.as_i64().unwrap()));
            }
            cells.sort_unstable();
            candidates.push(cells.iter().map(|c| c.2).collect::<Vec<_>>());
        }
    }
    candidates.into_iter().min().unwrap()
}

fn openings(plan: &Plan) -> Result<Vec<Opening>, String> {
    let mut all = Vec::new();
    for &preset in &plan.presets {
        let mut random = Random(plan.seed ^ (preset as u64).wrapping_mul(0x9e3779b97f4a7c15));
        let mut seen = HashSet::new();
        let mut attempts = 0;
        for pair in 0..plan.pairs_per_variant {
            loop {
                attempts += 1;
                if attempts > plan.pairs_per_variant * 100 {
                    return Err("openingGenerationExhausted".into());
                }
                let target = 4 + 2 * (pair % 3);
                let mut moves = Vec::new();
                let mut position = query(preset, &moves, &plan.a, false)?;
                while moves.len() < target {
                    let mut candidates: Vec<String> = position["legal"]
                        .as_array()
                        .unwrap()
                        .iter()
                        .filter(|a| a["kind"] == 0)
                        .map(|a| a["notation"].as_str().unwrap().to_owned())
                        .collect();
                    let mut accepted = None;
                    while !candidates.is_empty() {
                        let candidate = candidates.swap_remove(random.index(candidates.len()));
                        moves.push(candidate);
                        let next = query(preset, &moves, &plan.a, false)?;
                        if next["outcome"] == "ongoing" && next["action"] != 2 {
                            accepted = Some(next);
                            break;
                        }
                        moves.pop();
                    }
                    match accepted {
                        Some(next) => position = next,
                        None => break,
                    }
                }
                if moves.len() != target {
                    continue;
                }
                let key = canonical(&position);
                if !seen.insert(key.clone()) {
                    continue;
                }
                all.push(Opening {
                    preset,
                    pair,
                    moves,
                    fen: position["fen"].as_str().unwrap().into(),
                    canonical_board: key,
                });
                break;
            }
        }
    }
    Ok(all)
}

fn play(plan: &Plan, opening: &Opening, a_side: i64, deadline: Instant) -> Value {
    let mut moves = opening.moves.clone();
    let mut samples = Vec::new();
    let mut error = None;
    let mut final_position = Value::Null;
    let mut time_limited = false;
    let started = Instant::now();
    let result = (|| -> Result<(), String> {
        final_position = query(opening.preset, &moves, &plan.a, false)?;
        while final_position["outcome"] == "ongoing" && moves.len() < plan.max_actions {
            // Bound the whole run between individual searches, not merely between pairs.
            if Instant::now() >= deadline {
                time_limited = true;
                break;
            }
            let side = final_position["side"].as_i64().unwrap();
            let player = if side == a_side { &plan.a } else { &plan.b };
            let start = Instant::now();
            let searched = query(opening.preset, &moves, player, true)?;
            let elapsed_us = start.elapsed().as_micros() as u64;
            let best = &searched["best"];
            if !final_position["legal"].as_array().unwrap().contains(best) {
                return Err("illegalSearchResult".into());
            }
            let notation = best["notation"]
                .as_str()
                .ok_or("missingNotation")?
                .to_owned();
            samples.push(
                json!({"actor":if side == a_side {"a"} else {"b"},"side":side,
                "notation":notation,"phase":searched["phase"],"kind":best["kind"],
                "elapsed_us":elapsed_us,"depth":searched["searchDepth"]}),
            );
            moves.push(notation);
            final_position = query(opening.preset, &moves, player, false)?;
        }
        Ok(())
    })();
    if let Err(value) = result {
        error = Some(value);
    }
    let finished = error.is_none() && final_position["outcome"] != "ongoing";
    let score = if !finished {
        Value::Null
    } else if final_position["outcome"] == "draw" {
        json!(0.5)
    } else if final_position["outcome"] == "win" {
        json!(if final_position["winner"] == a_side {
            1.0
        } else {
            0.0
        })
    } else {
        Value::Null
    };
    json!({"preset":opening.preset,"pair":opening.pair,"a_side":a_side,
        "status":if error.is_some() {"error"} else if score.is_null() {"capped"} else {"finished"},
        "error":error,"limit_reason":if time_limited {Some("time")} else if !finished && error.is_none() {Some("actions")} else {None},
        "score_a":score,"outcome":final_position["outcome"],"winner":final_position["winner"],
        "reason":final_position["reason"],"fen":final_position["fen"],"moves":moves,"samples":samples,
        "elapsed_ms":started.elapsed().as_millis() as u64})
}

fn validate(plan: &Plan) -> Result<(), String> {
    if plan.pairs_per_variant == 0
        || plan.pairs_per_variant > 1000
        || !(8..=2048).contains(&plan.max_actions)
        || plan.max_seconds == 0
        || plan.presets.is_empty()
    {
        return Err("invalidPlanBounds".into());
    }
    let mut seen = HashSet::new();
    for preset in &plan.presets {
        if ![0, 1, 3, 5].contains(preset) || !seen.insert(preset) {
            return Err("invalidPresets".into());
        }
    }
    for player in [&plan.a, &plan.b] {
        let max_level = match player.level_scale.as_str() {
            "three" => 3,
            "five" => 5,
            _ => return Err("invalidLevelScale".into()),
        };
        if !(1..=max_level).contains(&player.level)
            || !["mtdf", "pvs"].contains(&player.algorithm.as_str())
            || !["standard", "extended"].contains(&player.effort.as_str())
            || !["balanced", "blocking"].contains(&player.style.as_str())
        {
            return Err("invalidPlayer".into());
        }
    }
    Ok(())
}

fn main() -> Result<(), Box<dyn std::error::Error>> {
    let args: Vec<String> = std::env::args().collect();
    if args.len() != 3 {
        return Err("Usage: compare_search PLAN.json NEW_OUTPUT_DIRECTORY".into());
    }
    let plan: Plan = serde_json::from_slice(&fs::read(&args[1])?)?;
    validate(&plan)?;
    let directory = Path::new(&args[2]);
    // Exclusive directory creation prevents accidental overwrites or mixed runs.
    fs::create_dir(directory)?;
    let positions = openings(&plan)?;
    fs::write(
        directory.join("manifest.json"),
        serde_json::to_vec_pretty(&json!({
        "schema":1,"engine_revision":"8901a06f088bf49a1602fee8686ed25ac5a33925",
        "plan":plan,"openings":positions,"platform":std::env::consts::OS,"architecture":std::env::consts::ARCH,
        "timing":"host release; serial; production C/JSON entry point; no UI pacing"}))?,
    )?;
    let file = OpenOptions::new()
        .create_new(true)
        .write(true)
        .open(directory.join("games.jsonl"))?;
    let mut log = BufWriter::new(file);
    let start = Instant::now();
    let deadline = start + Duration::from_secs(plan.max_seconds);
    let mut played = 0;
    // Interleave variants and reverse the order within every other pair.
    for pair in 0..plan.pairs_per_variant {
        for &preset in &plan.presets {
            if start.elapsed().as_secs() >= plan.max_seconds {
                break;
            }
            let opening = positions
                .iter()
                .find(|p| p.preset == preset && p.pair == pair)
                .unwrap();
            let mut scores = Vec::new();
            for a_side in if pair % 2 == 0 { [0, 1] } else { [1, 0] } {
                let result = play(&plan, opening, a_side, deadline);
                scores.push(result["score_a"].clone());
                serde_json::to_writer(&mut log, &result)?;
                writeln!(log)?;
                log.flush()?;
                played += 1;
            }
            println!(
                "{}",
                json!({"preset":preset,"pair":pair,"scores_a":scores,"games":played,"elapsed_s":start.elapsed().as_secs()})
            );
        }
        if start.elapsed().as_secs() >= plan.max_seconds {
            break;
        }
    }
    fs::write(
        directory.join("completion.json"),
        serde_json::to_vec_pretty(&json!({"games":played,
        "planned_games":plan.pairs_per_variant*plan.presets.len()*2,"elapsed_s":start.elapsed().as_secs(),
        "complete":played == plan.pairs_per_variant*plan.presets.len()*2}))?,
    )?;
    Ok(())
}

#[cfg(test)]
mod tests {
    use super::*;
    fn plan() -> Plan {
        serde_json::from_value(json!({"seed":20260930,"pairs_per_variant":4,"presets":[0],
        "a":{"algorithm":"mtdf","level":1,"effort":"standard"},
        "b":{"algorithm":"pvs","level":1,"effort":"standard"},"max_actions":8,"max_seconds":60}))
        .unwrap()
    }
    #[test]
    fn seeded_openings_are_reproducible_distinct_and_material_balanced() {
        let p = plan();
        let a = openings(&p).unwrap();
        let b = openings(&p).unwrap();
        assert_eq!(
            serde_json::to_value(&a).unwrap(),
            serde_json::to_value(&b).unwrap()
        );
        let distinct: HashSet<_> = a.iter().map(|o| &o.canonical_board).collect();
        assert_eq!(distinct.len(), a.len());
        for opening in a {
            let state = query(opening.preset, &opening.moves, &p.a, false).unwrap();
            assert_eq!(state["onBoard"][0], state["onBoard"][1]);
            assert_eq!(state["side"], 0);
            assert_ne!(state["action"], 2);
        }
    }
    #[test]
    fn capped_games_are_never_scored_as_draws() {
        let p = plan();
        let o = openings(&p).unwrap();
        let result = play(&p, &o[2], 0, Instant::now() + Duration::from_secs(10));
        assert_eq!(result["status"], "capped");
        assert!(result["score_a"].is_null());
    }
    #[test]
    fn whole_run_deadline_stops_between_actions_without_awarding_points() {
        let p = plan();
        let o = openings(&p).unwrap();
        let result = play(&p, &o[0], 0, Instant::now());
        assert_eq!(result["status"], "capped");
        assert_eq!(result["limit_reason"], "time");
        assert!(result["score_a"].is_null());
        assert_eq!(result["samples"].as_array().unwrap().len(), 0);
    }
    #[test]
    fn identical_engines_produce_identical_transcripts_and_complementary_scores() {
        let mut p = plan();
        p.b = p.a.clone();
        p.max_actions = 512;
        let o = openings(&p).unwrap();
        let deadline = Instant::now() + Duration::from_secs(120);
        let first = play(&p, &o[0], 0, deadline);
        let second = play(&p, &o[0], 1, deadline);
        assert_eq!(first["status"], "finished");
        assert_eq!(second["status"], "finished");
        assert_eq!(first["moves"], second["moves"]);
        assert_eq!(
            first["score_a"].as_f64().unwrap() + second["score_a"].as_f64().unwrap(),
            1.0
        );
    }
    #[test]
    fn invalid_configurations_are_rejected() {
        let mut p = plan();
        p.b.algorithm = "bogus".into();
        assert!(validate(&p).is_err());
        p = plan();
        p.presets = vec![0, 0];
        assert!(validate(&p).is_err());
        p = plan();
        p.a.level = 5;
        assert!(validate(&p).is_err());
        p.a.level_scale = "five".into();
        assert!(validate(&p).is_ok());
        p.a.level_scale = "unknown".into();
        assert!(validate(&p).is_err());
        p = plan();
        assert_eq!(p.a.style, "balanced");
        p.a.style = "blocking".into();
        assert!(validate(&p).is_ok());
        p.a.style = "perfect".into();
        assert!(validate(&p).is_err());
    }
}
