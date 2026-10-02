# Distribution requirements and open decisions

## Current source release — 2026-10-02

Version **1.1 (build 7)**, annotated source tag
[`v1.1`](https://github.com/MrFam0s/Muehlenstein/tree/v1.1), makes slate blue the
default for the game and app icon and the first appearance option. Rose joins
the palette, with existing saved selections preserved. Version and build are
maintained in `Configuration/App.xcconfig`; internal Cargo versions are unchanged.
See the [changelog](../CHANGELOG.md) and [validation record](VALIDATION.md).

This is a source release. Version 1.1 has no device archive, upload or review
submission yet. Before distribution, create a matching device archive and
refresh the Store screenshots to show the new default colors. The latest
recorded Apple submission below remains associated with version 1.0.2 (build 6).

## Last verified App Store submission — 2026-10-01

The user authorized continuation of the App Store submission. Version **1.0.2
(build 6)** contains the latest approved beige/forest-green icon and has been
uploaded and processed successfully by Apple (`VALID`). The corresponding
source tag is **v1.0.2-build.6**; earlier tags remain fixed. All 16 German/English
iPhone/iPad screenshots are processed and verified. App Privacy is published
as no data collected; the German price is EUR 0.99. The complete review contact
and notes are saved. Submitted on **2026-10-01 at 16:31:32 UTC**; Apple then confirmed
**WAITING_FOR_REVIEW**, submission `46d51255-9511-4a14-9814-839a35b050e0`. See the
[build 6 release record](../Store/RELEASE-1.0.2-6.md).

## Historical preparation and research record

The following sections preserve the earlier preparation-only status and
research scope. The source release and dated submission record above supersede their
upload, submission-authorization, screenshot and privacy status statements.

This file carries forward the scoped legal research; it is not a legal opinion or a claim of completed clearance. Local development is authorized. No App Store upload has taken place. The source repository is https://github.com/MrFam0s/Muehlenstein; see LICENSE_REVIEW.md for the 2026-10-01 audit and its scope.

Latest tagged source version: **1.0.2 (build 5)**, annotated Git tag
[`v1.0.2`](https://github.com/MrFam0s/Muehlenstein/tree/v1.0.2), dated 2026-10-01.
The app version/build are maintained in `Configuration/App.xcconfig`; internal
Cargo package versions are independent. See [version notes](../CHANGELOG.md)
and the [local archive record](../Store/README.md). The source tag does not
represent an App Store submission. Keep this tag fixed; any later binary
change needs a new build number and a corresponding source tag. The existing
1.0 (3) device archive and original Store screenshots are historical artifacts;
regenerate them for 1.0.2 before distribution. App Store Connect was last verified
with version 1.0; this source bump does not change that external record.

The working branch additionally contains the approved beige-background,
forest-green standard icon. This change follows `v1.0.2`; it does not alter
that tag. Include it in a new build and source tag before distribution.

## Version numbering — verified 2026-10-01

Apple documents the app version (`CFBundleShortVersionString`) as
**Major.Minor.Patch**; the third integer denotes a maintenance release.
Patch versions such as **1.0.1** and **1.0.2** are therefore valid. A jump to
**1.1** is not required. The version in App Store Connect must match the
binary's app version when that version is prepared for distribution.
The build string (`CFBundleVersion`) separately identifies a particular build
and is incremented before archiving a new build. See Apple's
[version-number definition](https://help.apple.com/xcode/mac/current/en.lproj/devc092854f5.html)
and [version/build instructions](https://help.apple.com/xcode/mac/current/en.lproj/devba7f53ad4.html).

The logo update follows the already published source tag `v1.0.1` (build 4)
as `v1.0.2` (build 5). Existing tags stay fixed.

## Remaining distribution work

1. Publish the exact complete corresponding app source (Swift, Rust wrapper, vendored core, lockfile, build scripts, license notices) for each distributed binary under AGPL-3.0-or-later. Charging for a download is consistent with the chosen open-source plan; recipients can also redistribute under the license.
2. Preserve Sanmill attribution and clearly identify the independent fork. The upstream README contains an explicit AGPL §7 App Store permission, traced to its 2023 introduction and 2026 AGPL update. The remaining question concerns any protected historical contributions carried into `tgf-core`, `tgf-mill`, `tgf-search` and the classical opening oracle; PerfectAI and `perfect-db` are not dependencies of this build. C++-to-Rust migration history prevents assuming a wholly independent rewrite. See `LICENSE_REVIEW.md` and the prepared, unsent `UPSTREAM_LICENSE_INQUIRY.md`. The project owner prefers the existing implementation in the absence of a concrete contrary licensing finding; publication preparation continues on the basis of the express permission. This decision does not establish the missing historical authority. A scoped rights confirmation remains recommended; any actual excluded contribution would need permission or replacement. No external inquiry or submission is authorized by the latest preparation-only instruction.
3. Implemented for the current build: the locked normal/build Cargo graph and Rust standard-library notices are audited and bundled; regeneration is checked by the build. Re-audit notices for every new linked dependency. `Engine/Cargo.lock` fixes resolutions; build/dev dependencies must be distinguished from linked runtime dependencies. Preserve original headers. Review new source/data/assets on every addition.
4. No Sanmill sounds, logo, store screenshots, Human DB or Perfect DB were copied into the app. The classical opening oracle is now included from an explicitly AGPL-licensed source with preserved copyright and reproducible extraction; see `OPENING_AND_DATABASE.md` and `Engine/UPSTREAM.md`. Named-opening prose, imported game transcriptions and learned lines are excluded. The UI and geometric icon are new. Any later audio/content/database import needs its own documented provenance.
5. Public App Store searches found no matching Mühlenstein/Muehlenstein app in DE/AT/CH/US/GB on 2026-09-30. Apple accepted the German app name Mühlenstein when the app record was created on 2026-10-01; the English localization remains to be added. This does not clear trademarks. Perform DPMA/EUIPO similarity review before release.
6. At the user's explicit request, bundle ID `org.amosystems.Muehlenstein` (resource `864J73UNMD`) and App Store Connect app `6818139673` were registered on 2026-10-01 under team `4WHV5UZ8E5`. The account and saved identity were verified; SKU is `Muehlenstein-iOS`, primary locale `de-DE`, iOS version **1.0**, state `PREPARE_FOR_SUBMISSION`. This registration does not authorize or represent a build upload or review submission. Source and provider contact links are in the About screen. The privacy manifest covers local preferences, app-local file metadata and elapsed-time measurements; see `../Store/README.md` for scope and validation. Store privacy answers, export-compliance answers, support/privacy URLs and bilingual product copy are prepared, not submitted.
7. Configure Paid Apps Agreement, taxes/banking and the intended €0.99 German customer price. Regional prices and proceeds differ; no financial setup has been performed.
8. Complete a device and accessibility matrix, source-to-binary reproducibility check and review notes explaining the independent native UI and inherited engine.

Sources and prior findings: `Research/Projektplanung_native_iOS_Muehle.pdf`, `Engine/vendor/Sanmill/Copying.txt`, `Engine/vendor/Sanmill/README.upstream.md`, `Engine/vendor/Sanmill/AUTHORS`.
