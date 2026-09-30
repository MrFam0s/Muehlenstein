#!/bin/bash
# Project-local official Rust compiler + standard libraries. No global changes.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export PATH="/opt/homebrew/bin:$PATH"
VERSION=1.98.1
SYSROOT="$ROOT/.build/rust-sysroot"
HOST=aarch64-apple-darwin
mkdir -p "$SYSROOT/lib/rustlib" "$ROOT/.build/downloads" "$ROOT/.build/cargo"
fetch() {
  local COMPONENT="$1" TARGET="$2"
  local NAME="$COMPONENT-$VERSION-$TARGET"
  local ARCHIVE="$NAME.tar.xz"
  if [ ! -f "$ROOT/.build/downloads/$ARCHIVE" ]; then
    curl --fail --location --retry 2 "https://static.rust-lang.org/dist/$ARCHIVE" -o "$ROOT/.build/downloads/$ARCHIVE"
  fi
  curl --fail --location --retry 2 "https://static.rust-lang.org/dist/$ARCHIVE.sha256" -o "$ROOT/.build/downloads/$ARCHIVE.sha256"
  (cd "$ROOT/.build/downloads" && shasum -a 256 -c "$ARCHIVE.sha256")
  tar -xf "$ROOT/.build/downloads/$ARCHIVE" -C "$ROOT/.build/downloads"
}
if [ ! -f "$SYSROOT/.compiler-$VERSION" ]; then
  fetch rustc "$HOST"
  if [ -L "$SYSROOT/lib/rustlib/$HOST" ]; then unlink "$SYSROOT/lib/rustlib/$HOST"; fi
  cp -R "$ROOT/.build/downloads/rustc-$VERSION-$HOST/rustc/" "$SYSROOT/"
  touch "$SYSROOT/.compiler-$VERSION"
fi
for TARGET in "$HOST" aarch64-apple-ios aarch64-apple-ios-sim; do
  if [ -f "$SYSROOT/lib/rustlib/$TARGET/.version-$VERSION" ] && [ ! -L "$SYSROOT/lib/rustlib/$TARGET" ]; then continue; fi
  fetch rust-std "$TARGET"
  # Remove only the project-owned symlink from the initial Homebrew probe.
  if [ -L "$SYSROOT/lib/rustlib/$TARGET" ]; then unlink "$SYSROOT/lib/rustlib/$TARGET"; fi
  cp -R "$ROOT/.build/downloads/rust-std-$VERSION-$TARGET/rust-std-$TARGET/lib/rustlib/$TARGET" "$SYSROOT/lib/rustlib/"
  touch "$SYSROOT/lib/rustlib/$TARGET/.version-$VERSION"
done
CARGO_HOME="$ROOT/.build/cargo" RUSTC="$SYSROOT/bin/rustc" cargo fetch --locked --manifest-path "$ROOT/Engine/Cargo.toml"
