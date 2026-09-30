// SPDX-License-Identifier: AGPL-3.0-or-later
//! Coverage/cost probe through the iOS C boundary, not a playing-strength rating.
use serde_json::{Value, json};
use std::ffi::{CStr, CString};
use std::time::Instant;

fn query(moves: &[String], enabled: bool, search: bool) -> Value {
    let input = CString::new(
        json!({"version":1,"preset":0,"moves":moves,"search":search,
        "level":4,"level_scale":"five","opening_book":enabled})
        .to_string(),
    )
    .unwrap();
    // SAFETY: input is a live CString, and the returned owned string is freed once.
    unsafe {
        let ptr = muehlenstein_engine::ms_request(input.as_ptr());
        assert!(!ptr.is_null());
        let result = serde_json::from_slice(CStr::from_ptr(ptr).to_bytes()).unwrap();
        muehlenstein_engine::ms_string_free(ptr);
        result
    }
}

fn main() {
    let start = query(&[], true, false);
    let openings = std::iter::once(Vec::new())
        .chain(
            start["legal"]
                .as_array()
                .unwrap()
                .iter()
                .map(|action| vec![action["notation"].as_str().unwrap().to_owned()]),
        )
        .collect::<Vec<_>>();
    let mut records = Vec::new();
    for moves in openings {
        for enabled in [true, false] {
            let timer = Instant::now();
            let result = query(&moves, enabled, true);
            let micros = timer.elapsed().as_micros();
            assert!(result.get("error").is_none(), "{result}");
            assert!(
                result["legal"]
                    .as_array()
                    .unwrap()
                    .contains(&result["best"])
            );
            records.push(json!({"moves":moves,"openingBook":enabled,"micros":micros,
                "source":result["moveSource"],"best":result["best"]["notation"],
                "depth":result["searchDepth"],"nodesAtLastDepth":result["searchNodes"]}));
        }
    }
    // Continue a complete game to exercise book exits, captures and later search.
    let mut moves = Vec::new();
    let mut book_hits = 0;
    loop {
        let result = query(&moves, true, true);
        assert!(result.get("error").is_none(), "{result}");
        if result["outcome"] != "ongoing" {
            println!(
                "{}",
                json!({"records":records,"selfplay":{"moves":moves,
                "bookHits":book_hits,"outcome":result["outcome"],"reason":result["reason"]}})
            );
            break;
        }
        assert!(moves.len() < 512, "self-play did not finish");
        assert!(
            result["legal"]
                .as_array()
                .unwrap()
                .contains(&result["best"])
        );
        book_hits += usize::from(result["moveSource"] == "book");
        moves.push(result["best"]["notation"].as_str().unwrap().to_owned());
    }
}
