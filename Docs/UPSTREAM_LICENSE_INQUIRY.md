# Vorbereitete Anfrage zur Sanmill-App-Store-Erlaubnis

Stand: 01.10.2026. **Entwurf; nicht versandt.** Vorgesehener Empfänger:
Calcitem / Maintainer von `calcitem/Sanmill`, bevorzugt als öffentliches
GitHub-Issue, damit die Antwort auch anderen Forks hilft. Das Absenden erfordert
noch die ausdrückliche Zustimmung des Projektinhabers zur Kontaktaufnahme.

Die Anfrage bezieht sich ausschließlich auf den tatsächlich übernommenen
Umfang. Hintergrund und Quellen: [Lizenzprüfung](LICENSE_REVIEW.md).

## Title

Clarify App Store permission for Rust engine crates and classical opening oracle

## Body

Hello, and thank you for making Sanmill and its engine available as free software.

We are developing [Muehlenstein](https://github.com/MrFam0s/Muehlenstein), an
independently named native SwiftUI iOS app. We intend to offer it for €0.99
on Apple's App Store, with the complete corresponding source, build scripts,
attributions and license notices freely available on GitHub under
AGPL-3.0-or-later. Our own contributions also retain an App Store permission.

We use Sanmill at commit `8901a06f088bf49a1602fee8686ed25ac5a33925`, specifically:

- `crates/tgf-core`
- `crates/tgf-mill`
- `crates/tgf-search`
- The classical Nine Men's Morris oracle extracted from
  `src/ui/flutter_app/tool/mill_opening_book_oracle_source.dart`.

We do **not** include the Flutter UI, `tgf-cli`, `perfect-db`, the PerfectAI
C++ oracle, Perfect/Human databases, named/curated/learned opening lines,
Sanmill artwork or sounds. The imported sources and notices are preserved;
their hashes are recorded in our repository.

The README's AGPL section 7 permission appears intended to allow this kind
of App Store distribution. We traced it to commit `4b93c0e` (2023-01-02) and
its retention during the AGPL change in `b1088e1` (2026-06-30).

Could you please clarify its scope for this specific subset?

1. Does the additional permission cover paid, independently named App Store
   forks using these crates and the classical oracle, provided unrestricted
   corresponding source remains available under the stated license?
2. Do these files retain any copyrightable code or data from earlier
   third-party contributions, including translations/adaptations of the
   former C++ engine? If so, which parts, and what license or authorization
   permits their inclusion under the App Store exception and the current
   AGPL license declaration? Links to existing grants or a maintained
   provenance statement would be very helpful.
3. Are any files or contributions in this subset excluded from the
   permission, or subject to additional notices we should preserve?

We ask because AUTHORS mentions historical third-party sources, while
commits such as `67611b9`, `80ae4c2` and `fd8ed35` document deliberate
C++-to-Rust behavior transfers. We also noticed the Stockfish references
in `tt.rs`, `rules/mod.rs` and `game.rs`; we understand that references to
algorithms alone do not establish copying of protected expression.

We are not asking for a proprietary license or an exception to publishing
our source. We would like to document the existing permission accurately
for the exact components we distribute. If some historical material needs
separate clearance or replacement, identifying it would let us address
that specifically. Thank you!
