# SPDX-License-Identifier: AGPL-3.0-or-later
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest

spec = importlib.util.spec_from_file_location("summary", Path(__file__).resolve().parents[1] / "Scripts/summarize-search.py")
summary = importlib.util.module_from_spec(spec)
spec.loader.exec_module(summary)


class SearchSummaryTests(unittest.TestCase):
    def fixture(self, directory, second_status="finished"):
        plan = {"pairs_per_variant": 1, "presets": [0]}
        (directory / "manifest.json").write_text(json.dumps({"plan": plan,
            "openings": [{"preset": 0, "pair": 0, "moves": []}]}))
        (directory / "completion.json").write_text(json.dumps({"games": 2, "planned_games": 2, "complete": True}))
        games = [{"preset": 0, "pair": 0, "a_side": side, "moves": [], "samples": [],
                  "status": "finished" if side == 0 else second_status, "outcome": "win", "winner": 0,
                  "score_a": (1 if side == 0 else 0) if side == 0 or second_status == "finished" else None}
                 for side in [0, 1]]
        (directory / "games.jsonl").write_text("\n".join(json.dumps(g) for g in games))

    def test_color_pair_is_one_observation_and_retains_uncertainty(self):
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp)
            self.fixture(path)
            row = summary.summarize(path)["variants"][0]
            self.assertEqual(row["valid_pairs"], 1)
            self.assertEqual(row["score_a"], .5)
            self.assertEqual(row["pair_score_counts"], [0, 0, 1, 0, 0])
            self.assertEqual(row["hoeffding_95"], [0, 1])

    def test_incomplete_pair_is_excluded_whole(self):
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp)
            self.fixture(path, "capped")
            row = summary.summarize(path)["variants"][0]
            self.assertEqual(row["valid_pairs"], 0)
            self.assertEqual(row["excluded_games"], 2)
            self.assertIsNone(row["score_a"])
            self.assertEqual(row["capped"], 1)

    def test_duplicate_game_is_rejected(self):
        with tempfile.TemporaryDirectory() as temp:
            path = Path(temp)
            self.fixture(path)
            first = (path / "games.jsonl").read_text().splitlines()[0]
            (path / "games.jsonl").write_text(first + "\n" + first)
            with self.assertRaisesRegex(AssertionError, "Duplicate game"):
                summary.summarize(path)


if __name__ == "__main__":
    unittest.main()
