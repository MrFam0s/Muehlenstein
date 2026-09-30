// SPDX-License-Identifier: AGPL-3.0-or-later
//! Muehlenstein's C boundary. Sanmill owns all rules, topology and search.
mod cancellation;
mod opening_book;

use serde::Deserialize;
use serde_json::{Value, json};
use std::ffi::{CStr, CString, c_char};
use std::sync::{Arc, atomic::Ordering};
use std::time::{Duration, Instant};
use tgf_core::{Action, Game, GameKernel, MoveOrderAlgorithm, MoveOrderContext, OutcomeKind};
use tgf_mill::{MillActionKind, MillGame, MillRules, MillUciCodec, preset_for};
use tgf_search::{SearchOptions, SearchPolicy, Searcher, SharedTt};

#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct Request {
    version: u8,
    preset: i32,
    moves: Vec<String>,
    #[serde(default)]
    search: bool,
    #[serde(default = "default_level")]
    level: u8,
    #[serde(default)]
    level_scale: LevelScale,
    #[serde(default)]
    algorithm: Algorithm,
    #[serde(default)]
    effort: Effort,
    #[serde(default)]
    style: PlayStyle,
    // Old bridge callers and archived comparisons retain search-only behavior.
    #[serde(default)]
    opening_book: bool,
    #[serde(default)]
    search_id: Option<u64>,
}
fn default_level() -> u8 {
    2
}

#[derive(Deserialize, Default, Clone, Copy)]
#[serde(rename_all = "lowercase")]
enum LevelScale {
    // Version-1 callers and archived benchmark plans retain their original budgets.
    #[default]
    Three,
    Five,
}

impl LevelScale {
    fn resolve(self, level: u8) -> Result<u8, String> {
        match (self, level) {
            (Self::Three, 1..=3) => Ok(level * 2 - 1),
            (Self::Five, 1..=5) => Ok(level),
            _ => Err("invalidLevel".into()),
        }
    }
}

#[derive(Deserialize, Default, Clone, Copy)]
#[serde(rename_all = "lowercase")]
enum Algorithm {
    #[default]
    Mtdf,
    Pvs,
}

#[derive(Deserialize, Default, Clone, Copy)]
#[serde(rename_all = "lowercase")]
enum Effort {
    #[default]
    Standard,
    Extended,
}

#[derive(Deserialize, Default, Clone, Copy)]
#[serde(rename_all = "lowercase")]
enum PlayStyle {
    #[default]
    Balanced,
    Blocking,
}

fn search_budget(level: u8, effort: Effort) -> (i32, u64) {
    match (level, effort) {
        (1, Effort::Standard) => (2, 150),
        (2, Effort::Standard) => (4, 250),
        (3, Effort::Standard) => (5, 450),
        (4, Effort::Standard) => (8, 800),
        (_, Effort::Standard) => (12, 1200),
        (1, Effort::Extended) => (4, 600),
        (2, Effort::Extended) => (6, 1000),
        (3, Effort::Extended) => (8, 1800),
        (4, Effort::Extended) => (12, 2600),
        (_, Effort::Extended) => (16, 3600),
    }
}

fn action_json(a: Action) -> Value {
    json!({"kind": a.kind_tag, "from": a.from_node, "to": a.to_node,
        "notation": MillUciCodec::encode_action(a)})
}

fn process(input: &str) -> Result<Value, String> {
    let request: Request = serde_json::from_str(input).map_err(|_| "invalidRequest")?;
    if request.version != 1 {
        return Err("unsupportedVersion".into());
    }
    if request.moves.len() > 2048 || request.moves.iter().any(|m| m.len() > 16) {
        return Err("historyTooLong".into());
    }
    let level = request.level_scale.resolve(request.level)?;
    let abort = cancellation::flag(request.search_id)?;
    let check_cancelled = || -> Result<(), String> {
        if abort.load(Ordering::Relaxed) {
            Err("cancelled".into())
        } else {
            Ok(())
        }
    };
    check_cancelled()?;
    let mut preset = preset_for(request.preset).ok_or("invalidPreset")?;
    // Both styles retain mobility evaluation. Blocking is an alternative objective,
    // not a higher difficulty: upstream suppresses material scoring in certain phases.
    preset.options.consider_mobility = true;
    preset.options.focus_on_blocking_paths = matches!(request.style, PlayStyle::Blocking);
    let rules = Arc::new(MillRules::new(preset.options.clone()));
    let mut kernel = GameKernel::new(rules.clone(), &[]);
    let mut actors = Vec::with_capacity(request.moves.len());
    let mut last_turn = Vec::new();
    for text in &request.moves {
        check_cancelled()?;
        let actor = kernel.snapshot().side_to_move;
        if actors.last() != Some(&actor) {
            last_turn.clear();
        }
        actors.push(actor);
        let action = MillUciCodec::decode_action(&kernel.snapshot(), text).ok_or("invalidMove")?;
        kernel.apply(action).map_err(|_| "illegalMove")?;
        last_turn.push(action_json(action));
    }
    let snapshot = kernel.snapshot();
    let state = MillRules::decode_snapshot(snapshot);
    let legal = kernel.legal_actions();
    let outcome = kernel.outcome();
    let (outcome_kind, winner) = match outcome.kind {
        OutcomeKind::Ongoing => ("ongoing", -1),
        OutcomeKind::Win(side) => ("win", side),
        OutcomeKind::Draw => ("draw", -1),
        _ => ("ended", -1),
    };
    let topology = kernel.topology();
    let nodes: Vec<Value> = (0..topology.node_count())
        .map(|id| {
            let p = topology.coordinate_of(id);
            json!({"id": id, "label": topology.label_of(id), "x": p.x, "y": p.y})
        })
        .collect();
    let edges: Vec<Value> = topology.edges().iter().map(|e| json!([e.a, e.b])).collect();
    let mut result = json!({
        "version": 1, "actors": actors, "lastTurn": last_turn, "board": state.board(), "hand": state.pieces_in_hand(),
        "onBoard": state.pieces_on_board(), "side": snapshot.side_to_move,
        "phase": snapshot.phase_tag, "action": state.action_tag(),
        "outcome": outcome_kind, "winner": winner, "reason": outcome.reason,
        "legal": legal.iter().copied().map(action_json).collect::<Vec<_>>(),
        "nodes": nodes, "edges": edges, "lines": topology.line_groups(),
        "fen": rules.export_fen(&state), "best": null,
        "searchDepth": 0, "searchNodes": 0, "moveSource": null
    });
    if request.search && outcome_kind == "ongoing" && !legal.is_empty() {
        if let Some(action) = opening_book::lookup(
            request.preset,
            level,
            request.opening_book,
            result["fen"].as_str().expect("exported FEN"),
            &legal,
        ) {
            check_cancelled()?;
            result["best"] = action_json(action);
            result["moveSource"] = json!("book");
            return Ok(result);
        }
        let history =
            MillRules::repetition_history_from_snapshots(&snapshot, kernel.history_snapshots());
        let game = MillGame::new_with_repetition_history(preset.options, history);
        let mut workbench = game.build_workbench(&snapshot);
        // 16 MiB is a deliberate prototype budget; strength parity is not asserted.
        let mut searcher = Searcher::<MillGame>::with_shared_tt(SharedTt::with_capacity_mb(16, 14));
        searcher.set_abort_flag(Arc::clone(&abort));
        searcher.set_policy(SearchPolicy {
            quiescence_kind_tag: Some(MillActionKind::Remove as i16),
            ..Default::default()
        });
        let (ceiling, budget_ms) = search_budget(level, request.effort);
        let start = Instant::now();
        let mut best = None;
        let mut guess = 0;
        for depth in 1..=ceiling {
            check_cancelled()?;
            let remaining = Duration::from_millis(budget_ms).saturating_sub(start.elapsed());
            if remaining.is_zero() {
                break;
            }
            searcher.set_options(SearchOptions {
                time_limit_ms: Some(remaining.as_millis() as u64),
                move_order_context: MoveOrderContext {
                    algorithm: match request.algorithm {
                        Algorithm::Mtdf => MoveOrderAlgorithm::Mtdf,
                        Algorithm::Pvs => MoveOrderAlgorithm::Pvs,
                    },
                    skill_level: (level + 1) * 4,
                    shuffling: false,
                    ..Default::default()
                },
                ..Default::default()
            });
            let candidate = match request.algorithm {
                Algorithm::Mtdf => searcher.search_mtdf_with_guess(&mut workbench, depth, guess),
                Algorithm::Pvs => searcher.search_pvs(&mut workbench, depth),
            };
            if !searcher.was_aborted() && legal.contains(&candidate.best_action) {
                guess = candidate.score;
                best = Some(candidate.best_action);
                result["searchDepth"] = json!(depth);
                result["searchNodes"] = json!(candidate.nodes);
            }
            if searcher.was_aborted() {
                break;
            }
        }
        check_cancelled()?;
        result["best"] = action_json(best.ok_or("searchIncomplete")?);
        result["moveSource"] = json!("search");
    }
    Ok(result)
}

/// # Safety
/// `request` must be null or point to a valid NUL-terminated UTF-8 C string
/// for the duration of this call. Calls share no mutable session state.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn ms_request(request: *const c_char) -> *mut c_char {
    let response = std::panic::catch_unwind(|| {
        if request.is_null() {
            return Err("nullRequest".to_owned());
        }
        // SAFETY: validity and lifetime are guaranteed by the C contract above.
        let bytes = unsafe { CStr::from_ptr(request) }.to_bytes();
        if bytes.len() > 65536 {
            return Err("requestTooLarge".into());
        }
        let input = std::str::from_utf8(bytes).map_err(|_| "invalidEncoding")?;
        process(input)
    });
    let value = match response {
        Ok(Ok(value)) => value,
        Ok(Err(error)) => json!({"error": error}),
        Err(_) => json!({"error": "engineFailure"}),
    };
    // JSON escapes interior NULs, so the conversion cannot fail.
    CString::new(value.to_string())
        .expect("JSON has no NUL")
        .into_raw()
}

/// # Safety
/// Pass a pointer returned by `ms_request` exactly once, or null.
#[unsafe(no_mangle)]
pub unsafe extern "C" fn ms_string_free(response: *mut c_char) {
    if !response.is_null() {
        // SAFETY: ownership is transferred back exactly once by the caller.
        drop(unsafe { CString::from_raw(response) });
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    fn request(preset: i32, moves: &[&str], search: bool) -> Result<Value, String> {
        process(
            &json!({"version":1,"preset":preset,"moves":moves,"search":search,"level":1})
                .to_string(),
        )
    }
    #[test]
    fn book_hits_and_search_fallback_use_the_same_bridge_and_rules() {
        let mut input = json!({"version":1,"preset":0,"moves":["b4"],"search":true,
            "level":4,"level_scale":"five","opening_book":true});
        let book = process(&input.to_string()).unwrap();
        assert_eq!(book["moveSource"], "book");
        assert_eq!(book["searchNodes"], 0);
        assert!(book["legal"].as_array().unwrap().contains(&book["best"]));
        input["search"] = json!(false);
        let snapshot = process(&input.to_string()).unwrap();
        assert!(snapshot["best"].is_null());
        input["search"] = json!(true);
        input["opening_book"] = json!(false);
        let searched = process(&input.to_string()).unwrap();
        assert_eq!(searched["moveSource"], "search");
        for key in ["fen", "legal", "actors", "lastTurn", "outcome"] {
            assert_eq!(book[key], searched[key]);
        }
        input["opening_book"] = json!(true);
        input["moves"] = json!(["a7"]); // Outer-corner opening is absent from the oracle.
        let miss = process(&input.to_string()).unwrap();
        assert_eq!(miss["moveSource"], "search");
        assert!(miss["legal"].as_array().unwrap().contains(&miss["best"]));
        let id = cancellation::ms_search_create();
        cancellation::ms_search_cancel(id);
        input["moves"] = json!(["b4"]);
        input["search_id"] = json!(id);
        assert_eq!(process(&input.to_string()).unwrap_err(), "cancelled");
        cancellation::ms_search_release(id);
    }
    #[test]
    fn all_presets_expose_valid_topology_and_opening() {
        for preset in 0..11 {
            let v = request(preset, &[], false).unwrap();
            assert_eq!(v["board"].as_array().unwrap().len(), 24);
            assert_eq!(v["legal"].as_array().unwrap().len(), 24);
            assert_eq!(v["nodes"].as_array().unwrap().len(), 24);
        }
    }
    #[test]
    fn mill_keeps_turn_until_capture() {
        let v = request(0, &["c5", "a7", "d5", "d7", "e5"], false).unwrap();
        assert_eq!(v["side"], 0);
        assert_eq!(v["action"], 2);
        assert!(
            v["legal"]
                .as_array()
                .unwrap()
                .iter()
                .all(|a| a["kind"] == 2)
        );
        let after = request(0, &["c5", "a7", "d5", "d7", "e5", "xa7"], false).unwrap();
        assert_eq!(after["side"], 1);
        assert_eq!(after["onBoard"][1], 1);
        assert_eq!(after["actors"], json!([0, 1, 0, 1, 0, 0]));
        assert_eq!(after["lastTurn"].as_array().unwrap().len(), 2);
        assert_eq!(after["lastTurn"][0]["notation"], "e5");
        assert_eq!(after["lastTurn"][1]["notation"], "xa7");
    }
    #[test]
    fn illegal_history_rejected() {
        assert_eq!(request(0, &["a7", "a7"], false).unwrap_err(), "illegalMove");
        assert!(request(11, &[], false).is_err());
        assert!(request(0, &["z9"], false).is_err());
    }
    #[test]
    fn replay_is_deterministic() {
        assert_eq!(
            request(0, &["a7", "d7"], false).unwrap(),
            request(0, &["a7", "d7"], false).unwrap()
        );
    }
    #[test]
    fn archived_games_keep_outcomes_and_history_through_replay() {
        let fixtures: Value =
            serde_json::from_str(include_str!("../../Tests/Fixtures/offline-games.json")).unwrap();
        let mut flying_moves = 0;
        for game in fixtures["games"].as_array().unwrap() {
            let moves: Vec<&str> = game["moves"]
                .as_array()
                .unwrap()
                .iter()
                .map(|v| v.as_str().unwrap())
                .collect();
            let preset = game["preset"].as_i64().unwrap() as i32;
            for index in 0..moves.len() {
                let position = request(preset, &moves[..index], false).unwrap();
                let blocking = process(
                    &json!({"version":1,"preset":preset,
                    "moves":&moves[..index],"style":"blocking"})
                    .to_string(),
                )
                .unwrap();
                assert_eq!(
                    position, blocking,
                    "Play style must not change rules or history"
                );
                assert_eq!(
                    position["outcome"], "ongoing",
                    "{} before action {index}",
                    game["name"]
                );
                let action = position["legal"]
                    .as_array()
                    .unwrap()
                    .iter()
                    .find(|a| a["notation"] == moves[index])
                    .unwrap();
                if action["kind"] == 1 {
                    let adjacent = position["edges"].as_array().unwrap().iter().any(|edge| {
                        (edge[0] == action["from"] && edge[1] == action["to"])
                            || (edge[1] == action["from"] && edge[0] == action["to"])
                    });
                    if !adjacent {
                        flying_moves += 1;
                        let side = position["side"].as_u64().unwrap() as usize;
                        assert_eq!(position["hand"][side], 0);
                        assert_eq!(position["onBoard"][side], 3);
                    }
                }
            }
            let end = request(preset, &moves, true).unwrap();
            for key in ["outcome", "winner", "reason", "fen"] {
                assert_eq!(end[key], game[key], "{}: {key}", game["name"]);
            }
            assert!(end["legal"].as_array().unwrap().is_empty());
            assert!(end["best"].is_null());
            let mut extra = moves.clone();
            extra.push("a7");
            assert!(
                request(preset, &extra, false).is_err(),
                "Terminal game must reject further actions"
            );
        }
        assert!(
            flying_moves > 0,
            "Fixtures must exercise actual non-adjacent flying moves"
        );
    }
    #[test]
    fn capture_protects_mills_unless_all_opponent_stones_are_in_mills() {
        for preset in [0, 1, 3, 5] {
            let protected = request(
                preset,
                &["c5", "a7", "d5", "d7", "a1", "g7", "xa1", "g1", "b6", "e5"],
                false,
            )
            .unwrap();
            let legal: Vec<_> = protected["legal"]
                .as_array()
                .unwrap()
                .iter()
                .map(|a| a["notation"].as_str().unwrap())
                .collect();
            assert_eq!(legal, ["xb6"]);
            let all_in_mill = request(
                preset,
                &["c5", "a7", "d5", "d7", "g1", "g7", "xg1", "e5"],
                false,
            )
            .unwrap();
            let mut legal: Vec<_> = all_in_mill["legal"]
                .as_array()
                .unwrap()
                .iter()
                .map(|a| a["notation"].as_str().unwrap())
                .collect();
            legal.sort();
            assert_eq!(legal, ["xa7", "xd7", "xg7"]);
        }
    }
    #[test]
    fn double_mill_has_variant_specific_capture_count() {
        let mut moves = vec!["b6", "a7", "f6", "g7", "d7", "a1", "d5", "g1", "d6"];
        for preset in [0, 1, 3, 5] {
            let mill = request(preset, &moves, false).unwrap();
            assert_eq!(mill["side"], 0);
            assert_eq!(mill["action"], 2);
            moves.push("xa7");
            let capture = request(preset, &moves, false).unwrap();
            assert_eq!(capture["side"], if preset == 3 { 0 } else { 1 });
            if preset == 3 {
                assert_eq!(capture["action"], 2);
                moves.push("xg7");
                let second = request(preset, &moves, false).unwrap();
                assert_eq!(second["side"], 1);
                assert_eq!(second["lastTurn"].as_array().unwrap().len(), 3);
                moves.pop();
            }
            moves.pop();
        }
    }
    #[test]
    fn only_lasker_allows_movement_with_stones_in_hand() {
        let moves = ["a7", "g7", "a7-d7"];
        let lasker = request(5, &moves, false).unwrap();
        assert_eq!(lasker["hand"], json!([9, 9]));
        assert_eq!(lasker["onBoard"], json!([1, 1]));
        for preset in [0, 1, 3] {
            assert!(request(preset, &moves, false).is_err());
        }
    }
    #[test]
    fn search_returns_legal_action_for_initial_and_capture_positions() {
        for moves in [vec![], vec!["c5", "a7", "d5", "d7", "e5"]] {
            let v = request(0, &moves, true).unwrap();
            assert!(v["legal"].as_array().unwrap().contains(&v["best"]));
            assert!(v["searchDepth"].as_u64().unwrap() > 0);
        }
    }
    #[test]
    fn both_algorithms_and_efforts_return_legal_actions_for_each_variant() {
        for algorithm in ["mtdf", "pvs"] {
            for style in ["balanced", "blocking"] {
                for effort in ["standard", "extended"] {
                    for preset in [0, 1, 3, 5] {
                        for moves in [vec![], vec!["c5", "a7", "d5", "d7", "e5"]] {
                            let v = process(
                            &json!({"version":1,"preset":preset,"moves":moves,
                            "search":true,"level":1,"algorithm":algorithm,"effort":effort,"style":style})
                            .to_string(),
                        )
                        .unwrap();
                            assert!(v["legal"].as_array().unwrap().contains(&v["best"]));
                            assert!(v["searchDepth"].as_u64().unwrap() > 0);
                        }
                    }
                }
            }
        }
    }
    #[test]
    fn unknown_search_configuration_is_rejected() {
        for extra in [
            json!({"algorithm":"unknown"}),
            json!({"effort":"unlimited"}),
            json!({"level_scale":"unknown"}),
            json!({"style":"perfect"}),
        ] {
            let mut input = json!({"version":1,"preset":0,"moves":[]});
            input
                .as_object_mut()
                .unwrap()
                .extend(extra.as_object().unwrap().clone());
            assert_eq!(process(&input.to_string()).unwrap_err(), "invalidRequest");
        }
    }
    #[test]
    fn legacy_levels_preserve_search_profiles() {
        for (old, new, normal, longer) in [
            (1, 1, (2, 150), (4, 600)),
            (2, 3, (5, 450), (8, 1800)),
            (3, 5, (12, 1200), (16, 3600)),
        ] {
            assert_eq!(LevelScale::Three.resolve(old).unwrap(), new);
            assert_eq!(search_budget(new, Effort::Standard), normal);
            assert_eq!(search_budget(new, Effort::Extended), longer);
            assert_eq!((new + 1) * 4, old * 8);
        }
        for (scale, invalid) in [("three", 4), ("five", 6), ("five", 0)] {
            let input =
                json!({"version":1,"preset":0,"moves":[],"level":invalid,"level_scale":scale});
            assert_eq!(process(&input.to_string()).unwrap_err(), "invalidLevel");
        }
    }
    #[test]
    fn omitted_style_preserves_balanced_search() {
        for preset in [0, 1, 3, 5] {
            let mut input = json!({"version":1,"preset":preset,"moves":["a7","g7"],
                                  "search":true,"level":1,"level_scale":"five"});
            let original = process(&input.to_string()).unwrap();
            input["style"] = json!("balanced");
            assert_eq!(original, process(&input.to_string()).unwrap());
        }
    }
    #[test]
    fn five_levels_return_legal_moves_across_variants_and_algorithms() {
        for preset in [0, 1, 3, 5] {
            for algorithm in ["mtdf", "pvs"] {
                for level in 1..=5 {
                    let v = process(
                        &json!({"version":1,"preset":preset,
                        "moves":["c5","a7","d5","d7","e5"],"search":true,
                        "level":level,"level_scale":"five","algorithm":algorithm})
                        .to_string(),
                    )
                    .unwrap();
                    assert!(v["legal"].as_array().unwrap().contains(&v["best"]));
                    assert!(v["searchDepth"].as_u64().unwrap() > 0);
                }
            }
        }
    }
    #[test]
    fn cancelled_search_does_not_cancel_another_session() {
        let first = cancellation::ms_search_create();
        let second = cancellation::ms_search_create();
        cancellation::ms_search_cancel(first);
        let input = |id| {
            json!({"version":1,"preset":0,"moves":[],"search":true,"level":1,"search_id":id})
                .to_string()
        };
        for algorithm in ["mtdf", "pvs"] {
            let configured = |id| {
                let mut value: Value = serde_json::from_str(&input(id)).unwrap();
                value["algorithm"] = json!(algorithm);
                value.to_string()
            };
            assert_eq!(process(&configured(first)).unwrap_err(), "cancelled");
            assert!(process(&configured(second)).unwrap()["best"].is_object());
        }
        cancellation::ms_search_release(first);
        cancellation::ms_search_release(second);
        assert_eq!(process(&input(first)).unwrap_err(), "invalidSearchID");
    }
    #[test]
    fn releasing_handle_keeps_inflight_abort_flag_alive() {
        let id = cancellation::ms_search_create();
        let flag = cancellation::flag(Some(id)).unwrap();
        cancellation::ms_search_cancel(id);
        cancellation::ms_search_release(id);
        assert!(flag.load(Ordering::Relaxed));
    }
    #[test]
    fn active_long_search_stops_promptly_when_cancelled() {
        for algorithm in ["mtdf", "pvs"] {
            let id = cancellation::ms_search_create();
            let flag = cancellation::flag(Some(id)).unwrap();
            let (send, receive) = std::sync::mpsc::channel();
            let worker = std::thread::spawn(move || {
                let result = process(
                    &json!({"version":1,"preset":0,"moves":["a7"],
                    "search":true,"level":5,"level_scale":"five","effort":"extended",
                    "algorithm":algorithm,"search_id":id})
                    .to_string(),
                );
                send.send(result).unwrap();
            });
            // Registry + observer + running request: wait until the request owns its abort flag.
            let deadline = Instant::now() + Duration::from_secs(2);
            while Arc::strong_count(&flag) < 3 && Instant::now() < deadline {
                std::thread::yield_now();
            }
            std::thread::sleep(Duration::from_millis(25));
            let was_running = matches!(
                receive.try_recv(),
                Err(std::sync::mpsc::TryRecvError::Empty)
            );
            cancellation::ms_search_cancel(id);
            let stopped = receive.recv_timeout(Duration::from_secs(1));
            worker.join().unwrap();
            cancellation::ms_search_release(id);
            assert!(
                was_running,
                "Fixture must still be calculating when cancelled"
            );
            assert_eq!(stopped.unwrap().unwrap_err(), "cancelled");
        }
    }
    #[test]
    fn complete_games_roundtrip_through_bridge_for_visible_variants() {
        for algorithm in ["mtdf", "pvs"] {
            for preset in [0, 1, 3, 5] {
                let mut moves = Vec::<String>::new();
                let mut finished = false;
                for _ in 0..512 {
                    let v = process(
                    &json!({"version":1,"preset":preset,"moves":moves,"search":true,"level":1,"algorithm":algorithm})
                        .to_string(),
                )
                .unwrap();
                    if v["outcome"] != "ongoing" {
                        finished = true;
                        break;
                    }
                    assert!(v["legal"].as_array().unwrap().contains(&v["best"]));
                    moves.push(v["best"]["notation"].as_str().unwrap().to_owned());
                }
                assert!(
                    finished,
                    "preset {preset} did not terminate: {} actions",
                    moves.len()
                );
            }
        }
    }
    #[test]
    fn c_boundary_reports_bad_input_and_releases_memory() {
        // SAFETY: null is explicitly accepted; returned allocation freed once.
        unsafe {
            let output = ms_request(std::ptr::null());
            assert!(
                CStr::from_ptr(output)
                    .to_str()
                    .unwrap()
                    .contains("nullRequest")
            );
            ms_string_free(output);
        }
    }
}
