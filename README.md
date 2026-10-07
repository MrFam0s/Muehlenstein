# Muehlenstein

**Version 1.3 (Build 9)** ergänzt Spiele auf zwei Geräten im selben WLAN:
Einladung ohne Code, vier Varianten und gespeicherte Wiederverbindung.
Bedienung und Grenzen: [Lokaler Netzwerkmodus](Docs/LOCAL_NETWORK.md).
Der Release wird für den App Store vorbereitet; der genaue Stand steht im
[Releaseprotokoll](Store/RELEASE-1.3-9.md).

**Mühlenstein** is the German product name; **Muehlenstein** is the international
name and technical project name. An independent native SwiftUI Morris app for
iPhone and iPad, using Sanmill's Rust rules and search engine. Eight offline
localizations cover the interface and help. New players start at level 1;
the app remembers their last confirmed difficulty. Six accent colors are available.
The business model is a paid download at €0.99 in Germany, with the complete
corresponding source under AGPL-3.0-or-later. See the [version notes](CHANGELOG.md).

Version **1.2 (8)** is published: App Store Connect confirmed
`READY_FOR_DISTRIBUTION` on 2026-10-07. [Its release record](Store/RELEASE-1.2-8.md)
preserves the original submission evidence. [App Store documentation](Store/README.md)
includes listing copy and original iPhone/iPad screenshots in all eight languages,
with public [support](Docs/SUPPORT.md) and [privacy information](Docs/PRIVACY.md).

## Run

Requirements: Apple Silicon Mac, Xcode 27 (iOS 18 deployment target), Python 3, Cargo. The official Rust 1.98.1 compiler and iOS libraries are isolated inside `.build`; no global Rust installation is changed.

```sh
bash Scripts/setup-rust.sh
open Muehlenstein.xcodeproj
```

Choose the **Muehlenstein** scheme and an iPhone or iPad simulator. The Xcode build phase compiles the Rust static library automatically. Subsequent builds work offline with the downloaded Cargo cache. The project's signing defaults are team `4WHV5UZ8E5` and bundle identifier `org.amosystems.Muehlenstein`, defined in `Configuration/App.xcconfig`. For an independent fork, configure your own signing team and bundle identifier before physical-device installation.

## Implemented

- Native home, new-game configuration, game board, legal-target feedback, move history and rules. About includes provider/contact details, actual version/build information, privacy, source links and complete offline license notices.
- Local two-player play and offline computer play using Sanmill MTD(f) or PVS, original evaluation and transposition tables.
- Nine Men's Morris, Twelve Men's Morris, Morabaraba, Lasker Morris.
- Placement, movement, flying, mill capture and results adjudicated by Sanmill.
- Human hint, undo, automatic save and replay-validated restoration. An adjacent info button explains observable move consequences and whether the suggestion came from search or the opening book. Busy feedback appears only after two seconds of actual computation.
- Natural computer pacing, separate mill/capture steps, optional last-turn markers and a text description of the computer's move. Stable stone identities allow gentle movement, placement and capture transitions; the saved Disable stone animations switch and iOS Reduce Motion can disable them.
- Five difficulty levels (initially 1 / Very easy), with MTD(f) and Balanced play as defaults. The last confirmed difficulty is remembered for future games, including after app restarts; cancelling setup or computer options keeps the previous choice. New-game setup offers a stepped slider and a four-tile variant grid; search, thinking time and Balanced/Blocking style expand inline under Advanced. Adjacent info buttons explain strengths and limitations. Blocking is an alternative style, not a difficulty upgrade. The style persists with the game; development saves use schema 2 without migrating earlier schemas.
- Appearance lives in the game’s More menu. Slate blue is the default accent and first choice; Forest green, Aubergine, Terracotta, Teal and Rose (inspired by Besser Lesen’s Wildrose) can be selected and persist across launches. All three switches start off: legal targets and last-turn markers are hidden, while Disable stone animations being off keeps gentle movement enabled. Existing saved choices are preserved. More → Difficulty offers the computer options during play; a book icon opens Rules from the home screen without a duplicate general-settings page.
- Small offline Sanmill opening oracle (109 positions, 16-way symmetry), automatically used in Nine Men's Morris at levels 4–5. Advanced → Opening can disable it; misses use normal search and computer pacing is preserved. [Opening-book and Perfect DB assessment](Docs/OPENING_AND_DATABASE.md).
- Reproducible paired engine tournaments through the production bridge, with archived results: [2,048-game comparison at the original middle level](Docs/Benchmarks/ERGEBNISSE-2026-09-30.md). No reliable playing-strength advantage was established for either search method under those conditions.
- [Original-app settings review](Docs/AI_OPTIONS.md) and [576 games across two separate style comparisons](Docs/Benchmarks/SPIELSTILE-2026-10-01.md). Balanced remains the default; database/LLM features are not silently folded into difficulty levels.
- Cooperative native search cancellation on suspension or game replacement, with stale-result protection.
- Fixed, scroll-free home, setup and game surfaces in portrait and landscape; centered game status and paged rules. About, privacy, credits and complete license texts use structured, scrollable reading pages. History uses a responsive two/three-column grid with a separate Game details tab for difficulty and configuration. Legal moves open as a compact paged selection grid.
- Native German, English, French, Spanish, Japanese, Korean and Chinese text (Simplified and Traditional): eight complete offline localizations, chosen through iOS language preferences. See [language selection and maintenance](Docs/LOCALIZATION.md). Light / dark semantic colors, adaptive iPad layout, labelled board positions for VoiceOver and a separate paged legal-move chooser at accessibility text sizes.

## Deliberately still pending

Full Sanmill feature parity: remaining seven rule presets in the UI, broader opening recognition/training / Human DB / Perfect DB, additional search methods and calibrated strengths, analysis/replay navigation, puzzles and imports/exports. The large Perfect DB is deferred by product decision, not exposed as a placeholder setting. Local network play is included in 1.3; internet matchmaking remains outside the current scope. See [the plan](Docs/PROJECT_PLAN.md), [AI options and rating roadmap](Docs/AI_OPTIONS.md) and [architecture](Docs/ARCHITECTURE.md).

The original engine code is retained; the app's search orchestration is new. Equal playing strength to the Sanmill app has **not** been established. The public source repository is [MrFam0s/Muehlenstein](https://github.com/MrFam0s/Muehlenstein); recorded distribution status is in the [release documentation](Docs/RELEASE.md).

## Development

```sh
# Bridge tests, using the project-local compiler and cache
bash Scripts/test-engine.sh
# Swift model and UI tests; use an identifier from `xcrun simctl list devices available`
xcodebuild test -project Muehlenstein.xcodeproj -scheme Muehlenstein -destination 'platform=iOS Simulator,id=YOUR_SIMULATOR_ID' -derivedDataPath .build/DerivedData CODE_SIGNING_ALLOWED=NO
```

`Muehlenstein.xcodeproj` is the maintained Xcode project. `Scripts/generate-project.py` adds missing Swift source and localization references; it preserves existing signing settings, capabilities, build configurations and schemes. Edit the project normally in Xcode. Shared identity and version/build defaults live in `Configuration/App.xcconfig`: team `4WHV5UZ8E5`, bundle identifier `org.amosystems.Muehlenstein`. Target-level Xcode edits override those defaults and survive source synchronization. Navigator groups follow the actual directories. `Scripts/generate-resources.py` owns German/English copy and semantic colors; `Localization/*.json` supplies the additional languages. Run it with `--check-localizations` to check key coverage, format arguments and generated files without writing changes. `Scripts/generate-icon.swift` owns the original rounded-diamond Morris signet, its two scalable in-app PDF layers and the beige/slate-blue, dark and tinted app icons. Run `swift -module-cache-path .build/swift-module-cache Scripts/generate-icon.swift` to regenerate them; the review sheet is saved in `Docs/Previews`. For color-only icon changes, append `--icons-only` to keep the unchanged logo PDFs. `python3 Scripts/check-contrast.py` checks the semantic text and board color roles in both appearances. For generated localized strings, colors and icons, update their respective generator as well.

Sanmill source revision: `8901a06f088bf49a1602fee8686ed25ac5a33925`. See [provenance](Engine/UPSTREAM.md), [license](LICENSE) and [release requirements](Docs/RELEASE.md).

## Design and evidence

- [Design direction (German)](Docs/DESIGN.md)
- [Validation record (German)](Docs/VALIDATION.md)
- [Slate-blue home](Docs/Previews/Slate-Home-iPhone-Light.png), [six accent colors — light](Docs/Previews/Slate-Rose-Options-iPhone-Light.png), [dark](Docs/Previews/Slate-Rose-Options-iPhone-Dark.png), [app icons](Docs/Previews/App-Icon-Appearances.png)
- Earlier layout evidence: [iPhone — light](Docs/Previews/Game-iPhone-Light.png), [dark](Docs/Previews/Game-iPhone-Dark.png), [landscape](Docs/Previews/Game-iPhone-Landscape.png), [iPad](Docs/Previews/Game-iPad-Light.png)

## Licensing and source distribution

Copyright © 2026 Fabian Amos / AmoSystems for original Muehlenstein work. This independent Sanmill fork is licensed under AGPL-3.0-or-later. See [the license review](Docs/LICENSE_REVIEW.md), [own App Store permission](APP_STORE_PERMISSION.txt) and preserved upstream terms. Third-party licenses remain applicable. `Scripts/generate-license-notices.py --check` verifies the locked dependency inventory and bundled notices on every engine build. New dependencies require review. A public source repository is not an App Store legal or technical release approval.
