# Architecture

## Ownership

`App/` is SwiftUI, navigation, presentation, localization and local persistence. `Engine/src/` is our Rust C boundary. `Engine/vendor/Sanmill/crates/` preserves the upstream core, mill and search crates unchanged, with their original tests and notices.

All game rules, legal actions, geometry, captures and outcomes come from Rust. Swift only chooses among the supplied legal actions and renders the supplied state. No mirrored Swift rules or substitute Swift AI exist.

Board taps manage selection, while an explicit entry from the legal-move chooser goes through `GameStore.play`. That entry is checked against the current legal actions and human-turn/thinking state before applying it. It must not simulate two taps: an already selected origin would toggle off, which could turn a Lasker move into a placement.

The small C ABI accepts a versioned JSON request and returns owned JSON. Swift frees every returned string exactly once. Requests are independent, so background searches never mutate the UI's session. The engine validates preset, version, level, input length and every recorded move. Panics are caught at the C boundary. Internal OOM/abort conditions remain process failures.

## Replay and persistence

A saved game records schema, pinned engine revision, preset/opponent/level/search algorithm/effort and canonical notation with actor labels. The development save format is now schema 2 with five difficulty levels. No migration of earlier development saves is provided; unknown enum values are rejected. The current state is always reconstructed using `GameKernel::apply`, including the upstream full-history repetition path. Writes are atomic in the app's Application Support directory. Incompatible or invalid saves show an error and remain untouched until the user explicitly starts a replacement game.

### Assistance history and result acknowledgement — 10 October 2026

Schema 2 now has optional `history` and `dismissedResult` fields; published
1.3.1 saves still decode. The canonical `moves` list continues to contain only
the current legal game. A separate chronological journal retains played moves,
displayed hints and successful undo operations. An undo records the action
count before and after it; all journal entries survive, including abandoned
branches. The UI crosses out move entries outside the active branch. A hint
is recorded only after a valid, uncancelled search result becomes visible;
hiding it, a failed search and an unavailable undo do not add entries.
One undo command counts once even when it removes a computer turn and several
associated captures. New games start a fresh journal; restored journals retain
their totals. For older saves, earlier assistance is explicitly unknown and
only subsequent uses are counted. These are local game records, not a
tamper-proof competition record or transmitted analytics.

The result card handles both wins and draws and defers while another game
sheet is open. Its acknowledgement is saved against the terminal FEN, so
reopening the game does not repeat it. Undo clears acknowledgement; replaying
the finish announces the new result. Repeated network updates of the same
position preserve the local acknowledgement. The network protocol itself is
unchanged and still disallows hints and unilateral undo.

The card is a modal SwiftUI presentation using the app's semantic colors,
serif result typography, playing pieces and vector laurel symbols. It follows
the selected accent and appearance without a separate raster asset. Only the
result is shown here; assistance totals remain in history/game details.

History takes an immutable snapshot on opening. Each journal entry links to
a graphical replay; previous/next, first/last and a scrubber navigate the
chronological events. `SavedGame.replay(at:)` reconstructs the canonical path
at that point, including abandoned moves and undo events, then requests a
non-search engine snapshot. Hints highlight the suggested action on the
unchanged board. Played moves highlight origin/destination or removal.
Review never calls GameStore actions, persistence or the network transport,
and never adds an assistance event. Legacy/network saves without a journal
use their canonical moves. Any live AI/network updates remain separate from
the frozen review until it is reopened.

Legal capture targets have a solid outline and glow when legal-target display
and human interaction are enabled. The engine's legal list remains the sole
source, including protected-mill exceptions. This stationary overlay has no
pulse or movement animation and disappears immediately after capture; explicit
hint markers remain available when automatic legal-target display is off.

A snapshot request replays the bounded log (maximum 2048 individual actions). This is intentionally simple for the first integration milestone. Profile replay costs before longer records, analysis trees or networking. If an owned session handle replaces this transport later, preserve the versioned transcript as the durable interchange format.

`Tests/Fixtures/offline-games.json` freezes 18 completed games (1,000 actions) from the archived search comparison, with archive SHA-256 and original outcome/FEN expectations. Rust replays every prefix and checks terminal results, flying and rejection of actions after game end. Swift plays the same corpus through board input, persists and reloads after each action, checks pending captures and repetition-based endings, then undoes to the opening. The fixture is a model-test resource only and is not bundled in the app. Separate cases cover protected mills, multiple captures, Lasker placement/movement, corrupt save metadata and search interruption.

## Search

A detached Swift task receives an immutable transcript. Rust reconstructs it and runs the original monomorphized `Searcher<MillGame>`, selected MTD(f) or PVS, removal quiescence policy and repetition history. The algorithm also reaches the upstream move-order context. Iterations retain the latest fully completed legal result. Five standard depth/time profiles: 2/150 ms, 4/250 ms, 5/450 ms, 8/800 ms, 12/1200 ms; extended profiles: 4/600 ms, 6/1000 ms, 8/1800 ms, 12/2600 ms, 16/3600 ms. Default level 3 is the original middle profile. No compatibility code is maintained for old app saves. The JSON/C bridge explicitly receives `level_scale: "five"`; its separate legacy three-level request scale remains available for reproducing archived benchmark plans. Both use 16 MiB TT per search. These labels are provisional and not calibrated ratings. Time limits are cooperative search budgets, not a guaranteed total wall-clock response time.

New-game setup exposes opponent choice, a five-stop difficulty slider and a two-column variant grid. Algorithm and thinking-time buttons expand inline. Contextual info buttons open reading sheets. The in-game computer sheet reuses the same editor and draft behavior. Sheets use compact detents on iPhone and explicit iPad presentation size proposals; a GeometryReader alone has no useful intrinsic sheet height. When large text cannot fit, compact section tabs expose controls within the same sheet without scrolling. Applying changes during a game preserves the transcript, opponent and variant, validates the configuration, cancels the previous native search and invalidates its generation. A new search starts if it is still the computer's turn. Settings apply to future hint calculations as well. Cancelling the sheet discards the draft. No opponent personality or automatic level adaptation is implied by algorithm choice.

Each search owns a cancellation ID backed by a mutex-protected Rust registry of `Arc<AtomicBool>` values. Swift retains its handle across the C call and connects task cancellation to the upstream searcher's abort flag. Navigation, backgrounding and replacement games cancel replay/search cooperatively. Releasing the registry entry cannot invalidate an in-flight search's owned Arc. Generation tokens additionally discard stale results. Background energy measurements remain pending.

Computer presentation uses a monotonic, cancellable minimum deadline: placement 850–1150 ms, movement 950–1250 ms, capture 650–900 ms. Calculation overlaps this time; a slower search adds no artificial pause. Captures are separate visible actions, including when they follow a mill. Hint requests have no presentation delay. `DelayedSearchProgress` independently reveals busy feedback after two seconds of computation and cancels that timer on completion, cancellation or replacement. It is finished before the presentation deadline, so the natural move pause never causes a spinner. Tests inject a fixed duration rather than depending on random pacing.

The replay response includes `lastTurn`, the actions by the last recorded actor (move/placement plus any captures). When enabled, the board displays a destination ring, a dashed movement origin/path and a cross for removed stones; the status describes the computer's last action. This presentation is reconstructed after restoration and undo, without adding fields to the saved-game format.

`AppPreferences` stores independent display booleans in local UserDefaults: legal targets, last move, and stone animations. All default to enabled. UI-test launches use an isolated defaults suite; the optional test-save identifier permits relaunch tests. Turning off targets hides both visual and accessibility destination annotations, never changes the legal action list, and uses instructions that do not refer to invisible markers. Explicit hints and the separately requested legal-move grid remain available. Difficulty is always available in History → Game details rather than beside either player. The selected own stone remains marked as interaction feedback.

The native adapter now checks a small embedded NMM opening oracle before allocating the searcher: explicit `opening_book: true`, preset 0, levels 4–5 and placing phase only. Runtime candidates are transformed with the unchanged upstream 16-way symmetry and matched against live legal actions. Misses continue to normal search; cancellation is checked before returning a book hit. The JSON response reports `moveSource` (`book`, `search`, or null). Swift persists `openingBook` (default true) and sends it explicitly; omitted bridge fields stay false to preserve archived search comparisons. The presentation deadline remains outside the move source. Full-asset tests validate every candidate in every symmetry. `Scripts/generate-opening-book.py --check` verifies reproducibility from the hashed, explicitly licensed authored source; no named/learned lines are used. Human DB and Perfect DB remain absent. See `OPENING_AND_DATABASE.md`; end-to-end strength equivalence to Sanmill is not claimed.

`moveInsights` carries allowlisted observation tags for the suggested move. After serializing the current response snapshot, the request-local kernel applies that move through the real variant rules and repetition history. The adapter reports a resulting win, permitted mill captures, an occupied opposing open line, or a newly formed own open pair. Swift localizes those facts and the book/search source; it neither invents a search rationale nor changes the saved position. Applying a move, undoing or replacing the game clears stale hint explanations. `toggleHint()` also clears the suggestion and its automatic stone selection on a second tap. If a hint is still being calculated, that tap cancels native work and invalidates its generation so the result cannot reappear.

## Fixed screen layout

Home, game and setup contain no scroll containers. Flexible square board regions consume the space remaining after controls; wide viewports use a side-by-side arrangement. Status text reserves line counts and the thinking indicator has a fixed slot so changing game state cannot shift board coordinates. At accessibility sizes, secondary text is available in the history sheet’s Game details tab, with a compact paged legal-action chooser as an alternative to board targeting.

History and legal moves use `PagedGrid` with width- and type-dependent columns and height-dependent pages, preserving row-major order. History uses up to three columns, legal moves up to four; compact and large-text layouts reduce capacity without adding scrolling. The displayed move count follows the recorded entries, including separate capture steps, as before. Rules, credits and the full bundled license use TextKit pagination and a non-scrolling UITextView with matching font/insets. Dynamic Type changes page count; UTF-16 ranges preserve the source text exactly, covered by a full-license and Unicode round-trip test. Presentation remains separate from game rules and saves.

## Networking seam

Local two-device play now uses a separate encrypted Multipeer Connectivity transport, an explicit host-approved invitation and a host-authoritative transcript. Proposals carry action index and a hash of the match ID, variant and prior moves. Both devices validate snapshots through Rust replay. Optional network identity in schema-2 saves records the match ID, local side and private resume key; restored games remain paused until opened. Timed acknowledgements, prefix-only recovery and stale-session filtering prevent duplicate/out-of-turn moves. See [LOCAL_NETWORK.md](LOCAL_NETWORK.md) for ownership, lifecycle, privacy and limitations. Internet matchmaking, ratings and clocks remain outside this mode.

## Build

The Xcode pre-build step links an arm64 Rust static library into the Swift application. A project-local official Rust 1.98.1 toolchain avoids Homebrew's incompatible metadata build tag. Apple Silicon iPhone simulator and physical iOS targets are supported. Intel simulator and Catalyst are not configured. No Flutter runtime is included.

## Xcode project maintenance

The project navigator now mirrors the on-disk App/Core, App/Design, App/Features, App/Resources and Tests directories. `Configuration/App.xcconfig` supplies the shared team and exact bundle ID `org.amosystems.Muehlenstein`; app and test targets inherit it in Debug and Release. The former project generator has become an additive Swift-source synchronizer. Existing settings, schemes and capabilities are retained, including overrides edited in Xcode. Its regression check inserts a source while preserving customized signing/entitlement values and verifies idempotence.
