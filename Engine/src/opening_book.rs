// SPDX-License-Identifier: AGPL-3.0-or-later
//! Small, deterministic placement oracle. All misses fall back to normal search.
use serde::Deserialize;
use std::collections::BTreeMap;
use std::sync::LazyLock;
use tgf_core::Action;
use tgf_mill::{
    MillUciCodec, canonical_opening_book_fen, inverse_opening_book_transform,
    transform_opening_book_notation,
};

#[derive(Deserialize)]
#[serde(deny_unknown_fields)]
struct Book {
    #[serde(rename = "schemaVersion")]
    schema_version: u8,
    variant: String,
    symmetry: String,
    oracle: BTreeMap<String, Vec<String>>,
}

static BOOK: LazyLock<Option<Book>> = LazyLock::new(|| {
    let book: Book = serde_json::from_str(include_str!("../data/nmm-opening-book.json")).ok()?;
    (book.schema_version == 1 && book.variant == "nmm" && book.symmetry == "ring16").then_some(book)
});

/// Preset 0 is pinned alongside the data. Never reuse it by piece count alone.
pub(super) fn lookup(
    preset: i32,
    level: u8,
    enabled: bool,
    fen: &str,
    legal: &[Action],
) -> Option<Action> {
    if !enabled || preset != 0 || level < 4 || fen.split_whitespace().nth(2) != Some("p") {
        return None;
    }
    let (canonical, transform) = canonical_opening_book_fen(fen).ok()?;
    let candidates = BOOK.as_ref()?.oracle.get(&canonical)?;
    let inverse = inverse_opening_book_transform(transform).ok()?;
    // Preserve the authored order. Match against the live legal actions, also
    // for captures; an absent or unusable entry must never block a game.
    candidates.iter().find_map(|candidate| {
        let notation = transform_opening_book_notation(candidate, inverse).ok()?;
        legal
            .iter()
            .copied()
            .find(|action| MillUciCodec::encode_action(*action) == notation)
    })
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::collections::HashSet;
    use tgf_core::{ActionList, GameRules};
    use tgf_mill::{OPENING_BOOK_SYMMETRY_COUNT, rules_for_preset, transform_opening_book_fen};

    #[test]
    fn every_candidate_is_legal_in_all_sixteen_presentations() {
        let book = BOOK.as_ref().expect("valid bundled data");
        assert_eq!(book.oracle.len(), 109);
        assert_eq!(book.oracle.values().map(Vec::len).sum::<usize>(), 437);
        let rules = rules_for_preset(0).unwrap();
        let mut captures = 0;
        for (fen, candidates) in &book.oracle {
            assert_eq!(canonical_opening_book_fen(fen).unwrap().0, *fen);
            assert!(!candidates.is_empty());
            assert_eq!(
                candidates.iter().collect::<HashSet<_>>().len(),
                candidates.len()
            );
            for transform in 0..OPENING_BOOK_SYMMETRY_COUNT {
                let live_fen = transform_opening_book_fen(fen, transform).unwrap();
                let state = rules.set_from_fen(&live_fen).unwrap();
                let snapshot = rules.encode_state(state);
                let mut legal = ActionList::<256>::default();
                rules.legal_actions(&snapshot, &mut legal);
                let selected = lookup(0, 4, true, &live_fen, legal.as_slice()).unwrap();
                assert!(legal.as_slice().contains(&selected));
                for candidate in candidates {
                    let mapped = transform_opening_book_notation(candidate, transform).unwrap();
                    let action = MillUciCodec::decode_action(&snapshot, &mapped).unwrap();
                    assert!(legal.as_slice().contains(&action), "{live_fen}: {mapped}");
                    captures += usize::from(mapped.starts_with('x'));
                }
            }
        }
        assert!(captures > 0);
    }

    #[test]
    fn mismatched_rules_lower_levels_disabled_and_illegal_entries_miss() {
        let rules = rules_for_preset(0).unwrap();
        let snapshot = rules.initial_state(&[]);
        let fen = rules.export_fen(&tgf_mill::MillRules::decode_snapshot(snapshot));
        let mut legal = ActionList::<256>::default();
        rules.legal_actions(&snapshot, &mut legal);
        assert_eq!(
            MillUciCodec::encode_action(lookup(0, 5, true, &fen, legal.as_slice()).unwrap()),
            "d2"
        );
        for preset in [1, 3, 5] {
            assert!(lookup(preset, 5, true, &fen, legal.as_slice()).is_none());
        }
        for level in 1..=3 {
            assert!(lookup(0, level, true, &fen, legal.as_slice()).is_none());
        }
        assert!(lookup(0, 5, false, &fen, legal.as_slice()).is_none());
        assert!(lookup(0, 5, true, &fen, &[]).is_none());
        assert!(lookup(0, 5, true, "bad fen", legal.as_slice()).is_none());
        assert!(
            lookup(
                0,
                5,
                true,
                &fen.replace(" w p p ", " w m s "),
                legal.as_slice()
            )
            .is_none()
        );
    }
}
