#!/usr/bin/env python3
# SPDX-License-Identifier: AGPL-3.0-or-later
"""Validate paired engine-match logs; summarize without treating paired games as independent."""
import hashlib
import json
import math
from pathlib import Path
import platform
import statistics
import sys


def summarize(directory):
    manifest = json.loads((directory / "manifest.json").read_text())
    completion = json.loads((directory / "completion.json").read_text())
    plan = manifest["plan"]
    games = [json.loads(line) for line in (directory / "games.jsonl").read_text().splitlines()]
    assert completion["games"] == len(games), "Game count mismatch"
    openings = {(o["preset"], o["pair"]): o for o in manifest["openings"]}
    expected_games = plan["pairs_per_variant"] * len(plan["presets"]) * 2
    assert len(openings) * 2 == expected_games, "Opening pool count mismatch"
    assert completion["planned_games"] == expected_games
    assert completion["complete"] == (len(games) == expected_games)
    identities = set()
    pairs = {}
    for game in games:
        key = game["preset"], game["pair"]
        identity = key + (game["a_side"],)
        assert identity not in identities, "Duplicate game"
        identities.add(identity)
        assert game["a_side"] in (0, 1)
        opening = openings[key]
        assert game["moves"][:len(opening["moves"])] == opening["moves"], "Opening changed"
        assert len(game["samples"]) == len(game["moves"]) - len(opening["moves"])
        assert [s["notation"] for s in game["samples"]] == game["moves"][len(opening["moves"]):]
        for sample in game["samples"]:
            assert sample["actor"] == ("a" if sample["side"] == game["a_side"] else "b")
            assert sample["elapsed_us"] >= 0
            if sample.get("source", "search") == "beginner":
                player = plan[sample["actor"]]
                assert player["level"] == 1 and player.get("level_scale") == "five"
                assert sample["depth"] == 0
            else:
                assert sample["depth"] > 0
        if game["status"] == "finished":
            if game["outcome"] == "draw":
                assert game["score_a"] == 0.5
            else:
                assert game["outcome"] == "win" and game["winner"] in (0, 1)
                assert game["score_a"] == (1 if game["winner"] == game["a_side"] else 0)
        else:
            assert game["score_a"] is None, "Unfinished games must never be scored"
        pairs.setdefault(key, []).append(game)
    rows = []
    for preset in plan["presets"]:
        selected = [g for g in games if g["preset"] == preset]
        complete_pairs = [p for (variant, _), p in pairs.items() if variant == preset
                          and len(p) == 2 and {g["a_side"] for g in p} == {0, 1}
                          and all(g["status"] == "finished" for g in p)]
        scored = [g for pair in complete_pairs for g in pair]
        pair_scores = [sum(g["score_a"] for g in pair) / 2 for pair in complete_pairs]
        n = len(pair_scores)
        mean = statistics.mean(pair_scores) if n else None
        # Conservative distribution-free interval for independent bounded opening-pair scores.
        # Unlike a degenerate bootstrap interval, it retains uncertainty even if every pair ties.
        radius = math.sqrt(math.log(2 / 0.05) / (2 * n)) if n else None
        ci = [max(0, mean - radius), min(1, mean + radius)] if n else None
        # Also report a simultaneous 95% bound for all planned variant comparisons (union bound).
        family_radius = math.sqrt(math.log(2 * len(plan["presets"]) / 0.05) / (2 * n)) if n else None
        family_ci = [max(0, mean - family_radius), min(1, mean + family_radius)] if n else None
        timings = {}
        for actor in ("a", "b"):
            samples = [s for g in selected for s in g["samples"] if s["actor"] == actor]
            ms = sorted(s["elapsed_us"] / 1000 for s in samples)
            timings[actor] = {"actions": len(ms), "median_ms": statistics.median(ms) if ms else None,
                             "mean_ms": statistics.mean(ms) if ms else None,
                             "p95_ms": ms[max(0, math.ceil(len(ms) * .95) - 1)] if ms else None,
                             "mean_completed_depth": statistics.mean(s["depth"] for s in samples) if ms else None}
        rows.append({"preset": preset, "games": len(selected), "valid_pairs": n,
                     "excluded_games": len(selected) - len(scored),
                     "errors": sum(g["status"] == "error" for g in selected),
                     "capped": sum(g["status"] == "capped" for g in selected),
                     "a_wins": sum(g["score_a"] == 1 for g in scored),
                     "draws": sum(g["score_a"] == .5 for g in scored),
                     "b_wins": sum(g["score_a"] == 0 for g in scored),
                     "score_a": mean, "pair_score_counts": [pair_scores.count(s) for s in (0, .25, .5, .75, 1)],
                     "identical_transcript_pairs": sum(p[0]["moves"] == p[1]["moves"] for p in complete_pairs),
                     "hoeffding_95": ci, "simultaneous_95": family_ci,
                     "timing_observations": timings})
    return {"plan": plan, "completion": completion, "variants": rows,
            "interval_method": "Hoeffding on bounded opening-pair means; independent-opening assumption; simultaneous interval accounts for planned variants",
            "limitations": ["Synthetic non-capture placement openings, not a representative sample of human games.",
                            "Finite unique opening pool; confidence bounds assume independent sampling of pairs.",
                            "Timing samples come from different played positions; not a matched-position speed or energy benchmark.",
                            "Mac host release binary with the production bridge; no physical iPhone measurements.",
                            "Only the configured level/effort; no chess Elo or calibrated human rating.",
                            "Any incomplete planned run is exploratory, not a completed fixed-sample comparison."]}


def record_provenance(path):
    root = Path(__file__).resolve().parent.parent
    files = ["Engine/src/lib.rs", "Engine/src/cancellation.rs", "Engine/src/beginner.rs",
             "Engine/src/move_insights.rs", "Engine/src/opening_book.rs", "Engine/examples/compare_search.rs",
             "Engine/Cargo.lock", "Engine/UPSTREAM_SHA256.json", "Scripts/compare-search.sh", "Scripts/summarize-search.py",
             "Engine/target/release/examples/compare_search"]
    hashes = {name: hashlib.sha256((root / name).read_bytes()).hexdigest() for name in files}
    imported = json.loads((root / "Engine/UPSTREAM_SHA256.json").read_text())
    assert all(hashlib.sha256((root / "Engine/vendor/Sanmill" / name).read_bytes()).hexdigest() == digest
               for name, digest in imported.items()), "Vendored source differs from import manifest"
    path.write_text(json.dumps({"source_sha256": hashes,
        "verified_upstream_files": len(imported), "host": platform.platform(), "machine": platform.machine()}, indent=2) + "\n")


if __name__ == "__main__":
    if sys.argv[1] == "--provenance":
        record_provenance(Path(sys.argv[2]))
        sys.exit(0)
    directory = Path(sys.argv[1])
    summary = summarize(directory)
    (directory / "summary.json").write_text(json.dumps(summary, indent=2) + "\n")
    if not (directory / "provenance.json").exists():
        record_provenance(directory / "provenance.json")
    print(json.dumps({"completion": summary["completion"], "variants": [
        {k: v for k, v in row.items() if k != "timing_observations"} for row in summary["variants"]]}, indent=2))
