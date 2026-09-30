# Sanmill source provenance

Repository: https://github.com/calcitem/Sanmill
Pinned commit: `8901a06f088bf49a1602fee8686ed25ac5a33925`
Original commit time: 2026-09-15 21:31:20 +0800
Imported: 2026-09-30, from the previously audited local reference checkout.

Unmodified directories: `crates/tgf-core`, `crates/tgf-mill`, `crates/tgf-search`, including source, tests and historical fixtures. Preserved root notices: `Copying.txt`, `AUTHORS`, and `README.md` under the explicit name `README.upstream.md`. SHA-256 hashes are recorded in `UPSTREAM_SHA256.json`.

Only these three crates are compiled into the native engine adapter. Flutter, FRB, CLI, online services, audio assets, opening/Human/Perfect databases and the optional C++ oracle are not part of this prototype build. `Engine/src`, the workspace manifest, C header and Swift interface are new Muehlenstein work dated 2026-09-30. Vendor source modifications require a documented patch and parity tests.

License: AGPL-3.0-or-later. The upstream App Store additional permission is retained in its original README, with the scope caveat tracked in `Docs/RELEASE.md`.
