// SPDX-License-Identifier: AGPL-3.0-or-later
//! A deliberately fallible opponent, not a shortened expert search.
use tgf_core::{Action, GameKernel};
use tgf_mill::MillActionKind;

/// SplitMix64 with rejection sampling. The seed is injectable for reproducible tests;
/// this is move variety, not a security primitive or a rating adjustment.
struct Random(u64);
impl Random {
    fn index(&mut self, count: usize) -> usize {
        let count = count as u64;
        let threshold = count.wrapping_neg() % count;
        loop {
            self.0 = self.0.wrapping_add(0x9e3779b97f4a7c15);
            let mut value = self.0;
            value = (value ^ (value >> 30)).wrapping_mul(0xbf58476d1ce4e5b9);
            value = (value ^ (value >> 27)).wrapping_mul(0x94d049bb133111eb);
            value ^= value >> 31;
            if value >= threshold {
                return (value % count) as usize;
            }
        }
    }
}

pub(super) fn choose(
    kernel: &mut GameKernel,
    legal: &[Action],
    seed: u64,
    check_cancelled: impl Fn() -> Result<(), String>,
) -> Result<Action, String> {
    check_cancelled()?;
    if legal.is_empty() {
        return Err("noLegalMove".into());
    }
    let mut random = Random(seed);
    // Most turns overlook tactics entirely. Even an immediate mill or block can
    // be missed. Captures are legal but do not target the most valuable stone.
    if random.index(100) >= 35
        || legal
            .iter()
            .all(|a| a.kind_tag == MillActionKind::Remove as i16)
    {
        return Ok(legal[random.index(legal.len())]);
    }
    // Attentive turns only notice the immediate result of their own action.
    // No opponent replies, mobility evaluator, opening book or search table.
    let mut candidates = Vec::new();
    let mut best_score = 0;
    for &action in legal {
        check_cancelled()?;
        let facts = super::move_insights::describe(kernel, action);
        kernel.undo().map_err(|_| "beginnerUndoFailed")?;
        let score = if facts.contains(&"wins") {
            4
        } else if facts.contains(&"mill") || facts.contains(&"multiple_mills") {
            3
        } else if facts.contains(&"blocks_line") {
            2
        } else if facts.contains(&"builds_line") {
            1
        } else {
            0
        };
        if score > best_score {
            candidates.clear();
            best_score = score;
        }
        if score == best_score {
            candidates.push(action);
        }
    }
    check_cancelled()?;
    Ok(candidates[random.index(candidates.len())])
}
