// SPDX-License-Identifier: AGPL-3.0-or-later
use super::*;
use std::collections::HashSet;

#[test]
fn replies_to_the_same_human_opening_vary() {
    for algorithm in ["mtdf", "pvs"] {
        for level in 2..=3 {
            let mut choices = HashSet::new();
            for seed in 0..16 {
                let input = json!({"version":1,"preset":0,"moves":["a7"],"search":true,
                    "level":level,"level_scale":"five","algorithm":algorithm,
                    "varied_play":true,"selection_seed":seed});
                let response = process(&input.to_string()).unwrap();
                choices.insert(response["best"]["notation"].as_str().unwrap().to_owned());
            }
            println!("Replies after a7, {algorithm}, level {level}: {choices:?}");
            assert!(choices.len() > 1);
        }
    }
}

#[test]
fn varied_search_and_book_offer_alternatives_but_hints_stay_stable() {
    for preset in [0, 1, 3, 5] {
        for algorithm in ["mtdf", "pvs"] {
            for level in 2..=3 {
                let mut choices = HashSet::new();
                for seed in 0..12 {
                    let input = json!({"version":1,"preset":preset,"moves":[],"search":true,
                        "level":level,"level_scale":"five","algorithm":algorithm,
                        "varied_play":true,"selection_seed":seed});
                    let response = process(&input.to_string()).unwrap();
                    assert_eq!(response["moveSource"], "search");
                    assert!(
                        response["legal"]
                            .as_array()
                            .unwrap()
                            .contains(&response["best"])
                    );
                    choices.insert(response["best"]["notation"].as_str().unwrap().to_owned());
                }
                println!("preset {preset} {algorithm} level {level}: {choices:?}");
                assert!(
                    choices.len() > 1,
                    "Search must not always break ties by coordinates"
                );
            }
        }
    }
    for level in 4..=5 {
        let mut choices = HashSet::new();
        let mut input = json!({"version":1,"preset":0,"moves":["b4"],"search":true,
            "level":level,"level_scale":"five","opening_book":true,"varied_play":true});
        for seed in 0..32 {
            input["selection_seed"] = json!(seed);
            let response = process(&input.to_string()).unwrap();
            assert_eq!(response["moveSource"], "book");
            choices.insert(response["best"]["notation"].as_str().unwrap().to_owned());
        }
        assert!(choices.len() > 1);
        input["purpose"] = json!("hint");
        let hint = process(&input.to_string()).unwrap();
        for seed in 0..8 {
            input["selection_seed"] = json!(seed);
            assert_eq!(process(&input.to_string()).unwrap(), hint);
        }
    }
}

#[test]
fn seeded_variation_is_repeatable_and_opt_in_preserves_legacy_search() {
    let mut input = json!({"version":1,"preset":0,"moves":["a7"],"search":true,
        "level":2,"level_scale":"five","algorithm":"mtdf","selection_seed":42});
    let legacy = process(&input.to_string()).unwrap();
    input["varied_play"] = json!(false);
    assert_eq!(process(&input.to_string()).unwrap(), legacy);
    input["varied_play"] = json!(true);
    let varied = process(&input.to_string()).unwrap();
    assert_eq!(process(&input.to_string()).unwrap(), varied);
    input["purpose"] = json!("hint");
    assert_eq!(process(&input.to_string()).unwrap(), legacy);
    for key in ["fen", "legal", "actors", "lastTurn", "outcome", "board"] {
        assert_eq!(legacy[key], varied[key]);
    }
}

#[test]
fn varied_order_retains_best_scores_and_forced_choices_at_equal_depth() {
    // Independent full-window root values. Do not randomly choose from PVS/MTD(f)
    // summaries: their fail-low bounds are not exact scores for alternative moves.
    let fixtures: Value =
        serde_json::from_str(include_str!("../../Tests/Fixtures/offline-games.json")).unwrap();
    let mut samples = Vec::new();
    let mut seen = HashSet::new();
    for fixture in fixtures["games"].as_array().unwrap() {
        let preset = fixture["preset"].as_i64().unwrap() as i32;
        let rules = Arc::new(tgf_mill::rules_for_preset(preset).unwrap());
        let mut kernel = GameKernel::new(rules.clone(), &[]);
        let moves = fixture["moves"].as_array().unwrap();
        let mut phases = HashSet::new();
        for (index, notation) in moves.iter().enumerate() {
            let snapshot = kernel.snapshot();
            let state = MillRules::decode_snapshot(snapshot);
            let phase = (snapshot.phase_tag, state.action_tag());
            if (index == 4 || (index > 6 && phases.insert(phase)))
                && kernel.legal_actions().len() > 1
            {
                let fen = rules.export_fen(&state);
                if seen.insert((preset, fen)) {
                    samples.push((preset, moves[..index].to_vec()));
                }
            }
            let action =
                MillUciCodec::decode_action(&snapshot, notation.as_str().unwrap()).unwrap();
            kernel.apply(action).unwrap();
        }
    }
    let mut forced_choices = 0;
    let mut searches = 0;
    for (preset, moves) in &samples {
        let rules = Arc::new(tgf_mill::rules_for_preset(*preset).unwrap());
        let mut kernel = GameKernel::new(rules, &[]);
        for notation in moves {
            let action =
                MillUciCodec::decode_action(&kernel.snapshot(), notation.as_str().unwrap())
                    .unwrap();
            kernel.apply(action).unwrap();
        }
        let snapshot = kernel.snapshot();
        for style in ["balanced", "blocking"] {
            let mut options = preset_for(*preset).unwrap().options;
            options.consider_mobility = true;
            options.focus_on_blocking_paths = style == "blocking";
            let history =
                MillRules::repetition_history_from_snapshots(&snapshot, kernel.history_snapshots());
            let game = MillGame::new_with_repetition_history(options, history);
            let mut reference =
                Searcher::<MillGame>::with_shared_tt(SharedTt::with_capacity_mb(16, 14));
            reference.set_policy(SearchPolicy {
                quiescence_kind_tag: Some(MillActionKind::Remove as i16),
                ..Default::default()
            });
            reference.set_root_move_summaries_enabled(true);
            let mut wb = game.build_workbench(&snapshot);
            let expected = reference.search(&mut wb, 3);
            let best_actions: Vec<_> = reference
                .root_moves()
                .iter()
                .filter(|m| m.value == expected.score)
                .map(|m| m.action)
                .collect();
            assert!(!best_actions.is_empty());
            forced_choices += usize::from(best_actions.len() == 1);
            for algorithm in ["mtdf", "pvs"] {
                let request: Request = serde_json::from_value(
                    json!({"version":1,"preset":preset,"moves":moves,"algorithm":algorithm}),
                )
                .unwrap();
                for seed in 0..8 {
                    let mut searcher =
                        Searcher::<MillGame>::with_shared_tt(SharedTt::with_capacity_mb(16, 14));
                    searcher.set_policy(SearchPolicy {
                        quiescence_kind_tag: Some(MillActionKind::Remove as i16),
                        ..Default::default()
                    });
                    searcher.set_random_seed(seed);
                    searcher.set_options(search_options(&request, 3, Some(seed), None));
                    let mut wb = game.build_workbench(&snapshot);
                    let mut guess = 0;
                    for depth in 1..=3 {
                        let result = match request.algorithm {
                            Algorithm::Mtdf => {
                                searcher.search_mtdf_with_guess(&mut wb, depth, guess)
                            }
                            Algorithm::Pvs => searcher.search_pvs(&mut wb, depth),
                        };
                        guess = result.score;
                        if depth == 3 {
                            assert_eq!(
                                result.score, expected.score,
                                "preset {preset}, {style}, {algorithm}, seed {seed}, moves {moves:?}"
                            );
                            assert!(
                                best_actions.contains(&result.best_action),
                                "Variety must not select a weaker evaluated action: preset {preset}, {style}, {algorithm}, seed {seed}, moves {moves:?}"
                            );
                            searches += 1;
                        }
                    }
                }
            }
        }
    }
    assert!(
        forced_choices > 0,
        "Exercise uniquely best tactical choices too"
    );
    println!(
        "{} positions, {searches} equal-depth searches, {forced_choices} uniquely best cases",
        samples.len()
    );
}
