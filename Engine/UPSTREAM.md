# Sanmill source provenance

Repository: https://github.com/calcitem/Sanmill
Pinned commit: `8901a06f088bf49a1602fee8686ed25ac5a33925`
Original commit time: 2026-09-15 21:31:20 +0800
Imported: 2026-09-30, from the previously audited local reference checkout.

Unmodified directories: `crates/tgf-core`, `crates/tgf-mill`, `crates/tgf-search`, including source, tests and historical fixtures. Preserved root notices: `Copying.txt`, `AUTHORS`, and `README.md` under the explicit name `README.upstream.md`. SHA-256 hashes are recorded in `UPSTREAM_SHA256.json`.

Only these three crates are compiled into the native engine adapter. Flutter, FRB, CLI, online services, audio assets, Human/Perfect databases and the optional C++ oracle are not part of this prototype build. `Engine/src`, the workspace manifest, C header and Swift interface are new Muehlenstein work dated 2026-09-30. Vendor source modifications require a documented patch and parity tests.

License: AGPL-3.0-or-later. The upstream App Store additional permission is retained in its original README, with the scope caveat tracked in `Docs/RELEASE.md`.

Rechecked on 2026-10-01: public repository HEAD still matches the pinned commit. The adapter now explicitly retains `consider_mobility = true` and exposes the original `focus_on_blocking_paths` parameter as the optional Blocking play style. Balanced remains the default; no vendor files or search budgets were changed.

Opening addition, 2026-10-01: the unmodified, explicitly AGPL-licensed `src/ui/flutter_app/tool/mill_opening_book_oracle_source.dart` is now also vendored and hashed. `Scripts/generate-opening-book.py` extracts the 109-position/437-candidate NMM oracle into `Engine/data/nmm-opening-book.json` (14,925 bytes). Only the generated oracle is embedded in the Rust binary; the Dart source is build input and does not introduce a Flutter dependency. Named openings, imported book text/games and learned lines are not imported. Existing vendor files remain unchanged. Original copyright headers, AUTHORS and the license are preserved; the app credits opening data to Sanmill. See `Docs/OPENING_AND_DATABASE.md` for validation and the decision not to import a Perfect DB.
