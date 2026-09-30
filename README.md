# Muehlenstein

**Mühlenstein** is the German product name; **Muehlenstein** is the international name and the technical project name. An independent, native SwiftUI Morris app for iPhone and iPad, with Sanmill's original Rust rules and search engine.

This is an **offline development prototype**, not an App Store release. The agreed business model is a paid download, targeting €0.99 in Germany, with the corresponding complete source available under AGPL-3.0-or-later.

## Run

Requirements: Apple Silicon Mac, Xcode 27 (iOS 18 deployment target), Python 3, Cargo. The official Rust 1.98.1 compiler and iOS libraries are isolated inside `.build`; no global Rust installation is changed.

```sh
bash Scripts/setup-rust.sh
open Muehlenstein.xcodeproj
```

Choose the **Muehlenstein** scheme and an iPhone or iPad simulator. The Xcode build phase compiles the Rust static library automatically. Subsequent builds work offline with the downloaded Cargo cache. The project's signing defaults are team `4WHV5UZ8E5` and bundle identifier `org.amosystems.Muehlenstein`, defined in `Configuration/App.xcconfig`. For an independent fork, configure your own signing team and bundle identifier before physical-device installation.

## Implemented

- Native home, new-game configuration, game board, legal-target feedback, move history, rules, credits and license display.
- Local two-player play and offline computer play using Sanmill MTD(f) or PVS, original evaluation and transposition tables.
- Nine Men's Morris, Twelve Men's Morris, Morabaraba, Lasker Morris.
- Placement, movement, flying, mill capture and results adjudicated by Sanmill.
- Human hint, undo, automatic save and replay-validated restoration.
- Natural computer pacing, separate mill/capture steps, persistent last-turn markers and a text description of the computer's move.
- Five difficulty levels (default 3), with MTD(f) as the default search. New-game setup offers a stepped slider and a four-tile variant grid; algorithm and thinking-time choices expand inline under Advanced. Explanations open from adjacent info buttons. Development saves use schema 2 without migrating earlier saves.
- Saved display preferences for legal targets, last-turn feedback and the computer level badge; advanced search/time options with an in-app comparison of both algorithms' strengths and limitations.
- Reproducible paired engine tournaments through the production bridge, with archived results: [2,048-game comparison at the original middle level](Docs/Benchmarks/ERGEBNISSE-2026-09-30.md). No reliable playing-strength advantage was established for either search method under those conditions.
- Cooperative native search cancellation on suspension or game replacement, with stale-result protection.
- Fixed, scroll-free home, setup and game surfaces in portrait and landscape; paged rules, move history and complete license.
- German / English names and text, light / dark semantic colors, adaptive iPad layout, labelled board positions for VoiceOver and a separate paged legal-move chooser at accessibility text sizes.

## Deliberately still pending

Full Sanmill feature parity: remaining seven rule presets in the UI, opening books / Human DB / Perfect DB, additional search methods and calibrated strengths, analysis/replay navigation, puzzles and imports/exports. Network play follows the offline version. See [the plan](Docs/PROJECT_PLAN.md), [AI options and rating roadmap](Docs/AI_OPTIONS.md) and [architecture](Docs/ARCHITECTURE.md).

The original engine code is retained; the prototype's search orchestration is new. Equal playing strength to the Sanmill app has **not** been established. No distribution or public source repository has been created.

## Development

```sh
# Bridge tests, using the project-local compiler and cache
bash Scripts/test-engine.sh
# Swift model and UI tests; use an identifier from `xcrun simctl list devices available`
xcodebuild test -project Muehlenstein.xcodeproj -scheme Muehlenstein -destination 'platform=iOS Simulator,id=YOUR_SIMULATOR_ID' -derivedDataPath .build/DerivedData CODE_SIGNING_ALLOWED=NO
```

`Muehlenstein.xcodeproj` is the maintained Xcode project. `Scripts/generate-project.py` now only adds missing Swift source references; it preserves existing signing settings, capabilities, build configurations and schemes. Edit the project normally in Xcode. Shared identity defaults live in `Configuration/App.xcconfig`: team `4WHV5UZ8E5`, bundle identifier `org.amosystems.Muehlenstein`. Target-level Xcode edits override those defaults and survive source synchronization. Navigator groups follow the actual directories. `Scripts/generate-resources.py` owns localized copy and semantic colors. `Scripts/generate-icon.swift` owns the provisional geometric app icon. For generated localized strings, colors and icons, update their respective generator as well.

Sanmill source revision: `8901a06f088bf49a1602fee8686ed25ac5a33925`. See [provenance](Engine/UPSTREAM.md), [license](LICENSE) and [release requirements](Docs/RELEASE.md).

## Design and evidence

- [Design direction (German)](Docs/DESIGN.md)
- [Validation record (German)](Docs/VALIDATION.md)
- [Home](Docs/Previews/Home-iPhone-DE.png), [iPhone — light](Docs/Previews/Game-iPhone-Light.png), [dark](Docs/Previews/Game-iPhone-Dark.png), [landscape](Docs/Previews/Game-iPhone-Landscape.png), [iPad](Docs/Previews/Game-iPad-Light.png)
