// SPDX-License-Identifier: AGPL-3.0-or-later
//! Shared selection randomness; never changes position evaluation.

/// SplitMix64 with rejection sampling. The seed is injectable for reproducible tests;
/// this is move variety, not a security primitive or a rating adjustment.
pub(super) struct Random(pub(super) u64);
impl Random {
    pub(super) fn index(&mut self, count: usize) -> usize {
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
