#!/bin/bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export PATH="/opt/homebrew/bin:$PATH"
PLATFORM="${1:-${PLATFORM_NAME:-iphonesimulator}}"
case "$PLATFORM" in
  iphoneos) TARGET=aarch64-apple-ios ;;
  iphonesimulator) TARGET=aarch64-apple-ios-sim ;;
  *) echo "Unsupported platform: $PLATFORM" >&2; exit 1 ;;
esac
if [ ! -d "$ROOT/.build/rust-sysroot/lib/rustlib/$TARGET" ]; then
  echo 'Run bash Scripts/setup-rust.sh once before building.' >&2
  exit 1
fi
export CARGO_HOME="$ROOT/.build/cargo"
export IPHONEOS_DEPLOYMENT_TARGET=18.0
export RUSTC="$ROOT/.build/rust-sysroot/bin/rustc"
export RUSTFLAGS="--sysroot=$ROOT/.build/rust-sysroot"
cargo build --manifest-path "$ROOT/Engine/Cargo.toml" --locked --offline --release --target "$TARGET"
mkdir -p "$ROOT/Engine/Artifacts/$PLATFORM"
cp "$ROOT/Engine/target/$TARGET/release/libmuehlenstein_engine.a" "$ROOT/Engine/Artifacts/$PLATFORM/"
