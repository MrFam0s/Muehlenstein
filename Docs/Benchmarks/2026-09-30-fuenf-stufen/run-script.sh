#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export PATH="/opt/homebrew/bin:$PATH"
export CARGO_HOME="$ROOT/.build/cargo"
export RUSTC="$ROOT/.build/rust-sysroot/bin/rustc"
export RUSTDOC="$ROOT/.build/rust-sysroot/bin/rustdoc"
if [ "$#" -ne 2 ]; then
  echo 'Usage: bash Scripts/compare-search.sh PLAN.json NEW_OUTPUT_DIRECTORY' >&2
  exit 1
fi
CARGO_PROFILE_RELEASE_STRIP=none cargo build --manifest-path "$ROOT/Engine/Cargo.toml" --locked --offline --release --example compare_search
PROVENANCE_TEMP="$(mktemp "$ROOT/.build/search-provenance.XXXXXX")"
trap 'rm -f "$PROVENANCE_TEMP"' EXIT
python3 "$ROOT/Scripts/summarize-search.py" --provenance "$PROVENANCE_TEMP"
"$ROOT/Engine/target/release/examples/compare_search" "$1" "$2"
mv "$PROVENANCE_TEMP" "$2/provenance.json"
python3 "$ROOT/Scripts/summarize-search.py" "$2"
