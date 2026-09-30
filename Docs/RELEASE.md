# Distribution requirements and open decisions

This file carries forward the scoped legal research; it is not a legal opinion or a claim of completed clearance. Local development is authorized. No App Store upload or external publication has taken place.

1. Publish the exact complete corresponding app source (Swift, Rust wrapper, vendored core, lockfile, build scripts, license notices) for each distributed binary under AGPL-3.0-or-later. Charging for a download is consistent with the chosen open-source plan; recipients can also redistribute under the license.
2. Preserve Sanmill attribution and clearly identify the independent fork. The upstream README contains an AGPL §7 App Store permission. Confirm its scope against the rights chain, including imported Stockfish/perfect-AI contributions, before relying on it for distribution. We do not silently extend that permission to third-party contributions.
3. Audit and bundle notices for every linked dependency. `Engine/Cargo.lock` fixes resolutions; build/dev dependencies must be distinguished from linked runtime dependencies. Preserve original headers. Review new source/data/assets on every addition.
4. No Sanmill sounds, logo, store screenshots or bundled databases were copied into the app. The provisional UI and geometric icon are new. Any later audio/content/database import needs its own documented provenance.
5. Public App Store searches found no matching Mühlenstein/Muehlenstein app in DE/AT/CH/US/GB on 2026-09-30. This does not clear trademarks or reveal unpublished reservations. Perform DPMA/EUIPO similarity review and confirm App Store Connect availability before release.
6. The local project is configured with `org.amosystems.Muehlenstein` and team `4WHV5UZ8E5`; confirm the intended publishing account and App Store Connect record before release. Set source/support URLs and privacy declarations for actual shipped behavior. Check Apple's required-reason APIs (including transitive Rust timing use) and create the appropriate privacy manifest after that audit.
7. Configure Paid Apps Agreement, taxes/banking and the intended €0.99 German customer price. Regional prices and proceeds differ; no financial setup has been performed.
8. Complete a device and accessibility matrix, source-to-binary reproducibility check and review notes explaining the independent native UI and inherited engine.

Sources and prior findings: `Research/Projektplanung_native_iOS_Muehle.pdf`, `Engine/vendor/Sanmill/Copying.txt`, `Engine/vendor/Sanmill/README.upstream.md`, `Engine/vendor/Sanmill/AUTHORS`.
