// SPDX-License-Identifier: AGPL-3.0-or-later
//! Observable consequences, not a reconstruction of the searcher's reasoning.
use tgf_core::{Action, GameKernel, OutcomeKind};
use tgf_mill::{MillActionKind, MillRules};

/// The request-local kernel can be advanced after its response snapshot is built.
/// No live/persisted game is changed. Applying through the kernel retains history.
pub(super) fn describe(kernel: &mut GameKernel, action: Action) -> Vec<&'static str> {
    let before_snapshot = kernel.snapshot();
    let before = MillRules::decode_snapshot(before_snapshot);
    let side = before_snapshot.side_to_move;
    if !(0..=1).contains(&side) {
        return Vec::new();
    }
    let lines = kernel.topology().line_groups().to_vec();
    let Ok(snapshot) = kernel.apply(action) else {
        return Vec::new();
    };
    let after = MillRules::decode_snapshot(snapshot);
    let mut facts = Vec::new();
    if kernel.outcome().kind == OutcomeKind::Win(side) {
        facts.push("wins");
    }
    if action.kind_tag == MillActionKind::Remove as i16 {
        facts.push("capture");
        return facts;
    }
    let removals = after.pending_removals()[side as usize]
        .saturating_sub(before.pending_removals()[side as usize]);
    if removals > 0 {
        facts.push(if removals > 1 {
            "multiple_mills"
        } else {
            "mill"
        });
    }
    let own = side + 1;
    let enemy = 2 - side;
    let mut blocks = false;
    let mut builds = false;
    for line in lines
        .iter()
        .filter(|line| line.len() == 3 && line.contains(&(action.to_node as u16)))
    {
        let count = |board: &[i8; 24], owner: i8| {
            line.iter()
                .filter(|&&node| board[node as usize] == owner)
                .count()
        };
        blocks |= count(before.board(), enemy) == 2
            && count(before.board(), 0) == 1
            && after.board()[action.to_node as usize] == own;
        builds |= count(after.board(), own) == 2
            && count(after.board(), 0) == 1
            && !(count(before.board(), own) == 2 && count(before.board(), 0) == 1);
    }
    if blocks {
        facts.push("blocks_line");
    }
    if builds {
        facts.push("builds_line");
    }
    facts
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::sync::Arc;
    use tgf_mill::{MillUciCodec, rules_for_preset};

    fn facts(preset: i32, history: &[&str], notation: &str) -> Vec<&'static str> {
        let mut kernel = GameKernel::new(Arc::new(rules_for_preset(preset).unwrap()), &[]);
        for token in history {
            let action = MillUciCodec::decode_action(&kernel.snapshot(), token).unwrap();
            kernel.apply(action).unwrap();
        }
        let action = MillUciCodec::decode_action(&kernel.snapshot(), notation).unwrap();
        describe(&mut kernel, action)
    }
    #[test]
    fn explains_real_mills_captures_and_open_lines() {
        assert_eq!(facts(0, &["c5", "a7", "d5", "d7"], "e5"), ["mill"]);
        assert_eq!(
            facts(0, &["c5", "a7", "d5", "d7", "e5"], "xa7"),
            ["capture"]
        );
        assert!(facts(0, &["a7", "c5", "g1", "d5"], "e5").contains(&"blocks_line"));
        assert!(facts(0, &["c5", "a7"], "d5").contains(&"builds_line"));
        assert!(facts(0, &[], "d2").is_empty());
        let history = ["b6", "a7", "f6", "g7", "d7", "a1", "d5", "g1"];
        assert!(facts(3, &history, "d6").contains(&"multiple_mills"));
        assert!(facts(0, &history, "d6").contains(&"mill"));
    }
    #[test]
    fn diagonal_claims_follow_the_active_variant() {
        let history = ["a7", "g1", "b6", "d1"];
        assert!(!facts(0, &history, "c5").contains(&"mill"));
        assert!(facts(1, &history, "c5").contains(&"mill"));
    }
}
