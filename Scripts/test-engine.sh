#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export PATH="/opt/homebrew/bin:$PATH"
export CARGO_HOME="$ROOT/.build/cargo"
export RUSTC="$ROOT/.build/rust-sysroot/bin/rustc"
export RUSTDOC="$ROOT/.build/rust-sysroot/bin/rustdoc"
cargo test --manifest-path "$ROOT/Engine/Cargo.toml" -p muehlenstein-engine --offline
cargo test --manifest-path "$ROOT/Engine/Cargo.toml" -p tgf-core -p tgf-mill -p tgf-search --lib --offline
