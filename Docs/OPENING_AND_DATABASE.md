# Eröffnungsbuch und perfekte Datenbank — Entscheidung vom 01.10.2026

**Ergebnis:** Das kleine, ausdrücklich verfasste Sanmill-Eröffnungsorakel wird eingebunden. Eine vollständige oder partielle Perfect DB gehört vorerst nicht zum normalen Offline-Produkt. Die technische Integration der Perfect DB ist möglich, aber Datenumfang, Regelprüfung und eine eigene Produktaussage rechtfertigen dafür ein separates späteres Analysevorhaben.

## Eröffnungsbuch: umgesetzt

Quelle ist Sanmill `8901a06f088bf49a1602fee8686ed25ac5a33925`, Datei `src/ui/flutter_app/tool/mill_opening_book_oracle_source.dart`. Sie trägt einen ausdrücklichen AGPL-3.0-or-later-/Sanmill-Copyright-Hinweis und ist unverändert unter `Engine/vendor/Sanmill` samt SHA-256 importiert. `Scripts/generate-opening-book.py` extrahiert ausschließlich die klassische NMM-Zugtabelle. Der erzeugte Katalog entspricht dem `oracle` des originalen NMM-JSON exakt: **109 kanonische Stellungen, 437 Kandidaten, 14.925 Byte**. Nur diese kleine JSON-Datei wird in die native Bibliothek eingebettet. Die 48.310 Byte große Original-Dartdatei bleibt nachvollziehbarer Build-Eingang; Dart/Flutter werden nicht benötigt.

Nicht übernommen werden die separaten benannten Eröffnungen, Texte aus Buchquellen, importierten Partieabschriften, gelernten Linien oder das Bevorzugen vermeintlich gewinnträchtiger Eröffnungen. Für die Zugwahl genügt das verfasste Orakel; bloße Häufigkeit oder ein Eröffnungsname beweisen keine Qualität. Auch dessen Empfehlungen sind keine Perfect-DB-Beweise.

### Verhalten

- **Automatisch** ist die Voreinstellung: ausschließlich klassische Mühle (festes Preset 0), ausschließlich Stufe 4 und 5, ausschließlich Setzphase einschließlich passender Abnahme-Stellungen. Stufe 1–3 und die anderen Varianten bleiben bei der bisherigen Suche.
- **Aus** unter Erweitert → Eröffnung erzwingt normale Suche. Beide Einstellungen sind mit einem Informationssymbol erklärt und werden mit der Partie gespeichert. Abbrechen verwirft den Entwurf; Übernehmen während einer laufenden Berechnung verwirft deren Ergebnis und startet die aktuelle Konfiguration.
- Ein Treffer nutzt den ersten tatsächlich legalen Kandidaten in der Reihenfolge des Originals. Die vorhandenen Sanmill-Symmetrieoperationen bilden Rotation, Spiegelung und den Tausch des inneren/äußeren Rings ab. Die Original-FEN-Normalisierung bleibt maßgeblich.
- Fehlender Eintrag, nicht passende Phase/Variante oder kein legaler Kandidat führen zur normalen MTD(f)-/PVS-Suche. Entfernen nach einer Mühle bleibt eine eigene regelgeprüfte und sichtbar getaktete Aktion; es wird kein vorgefertigter Partieverlauf abgespielt.
- Bei einem Buchtreffer entfallen Suchspeicher und Suche; die angenehme Computerpause bleibt in Swift unverändert. Spielstil, Algorithmus und Zeit wirken bei der anschließend nötigen Suche. Die Hilfe erklärt diese Grenze ausdrücklich.
- Die C-Schnittstelle erhält `opening_book` und liefert `moveSource: book/search/null`. Fehlendes `opening_book` bedeutet weiterhin reine Suche, damit archivierte Vergleichspläne reproduzierbar bleiben. Die App übergibt ihre Einstellung ausdrücklich. Schema 2 erhält ein Boolesches Feld; keine Migration älterer Schemata.

### Prüfung und Nutzen

Alle **437 Kandidaten in allen 16 Transformationen (6.992 Prüfungen)** sind unter dem vorhandenen klassischen Regelkern legal. Zusätzlich geprüft: aktuelle Auswahl, Buch-Aus, Stufen-/Variantenfilter, nicht vorhandene Stellung, Abnahme-Stellungen, abgebrochener Auftrag und unveränderte Regeln/Verläufe. Die Original-Suchtests laufen mit unveränderten Voreinstellungen der C-Schnittstelle weiter.

Der reproduzierbare Host-Probelauf `Engine/examples/check_opening_book.rs` prüft das leere Brett und alle 24 möglichen ersten Steine jeweils mit/ohne Buch auf Stufe 4/Normal. **9 von 25 Stellungen** treffen das Buch (leeres Brett und acht erste Steine im mittleren Ring); alle 50 Antworten sind legal. Treffer benötigen in diesem einzelnen Mac-Lauf 105–164 µs statt 11.176–29.999 µs für die zugehörige reine Suche. Die letzte abgeschlossene Suchtiefe der Vergleichsantworten besucht 84.465–175.168 Knoten; Buchantworten suchen keine Knoten. Das ist keine Aussage über die Summe aller Suchiterationen, über iPhone-Energie oder über einen Stärkegewinn. Andere Entwicklungsarbeiten liefen gleichzeitig; die Zeitwerte dienen nur der Größenordnung.

Eine anschließende vollständige Selbstpartie endet regulär nach 65 Einzelaktionen, davon 12 Buchtreffern. Dies prüft den Übergang zwischen Quellen und die Spielfähigkeit, nicht die Spielstärke. Rohdaten: `Benchmarks/2026-10-01-eroeffnungsbuch/probe.json`. Reproduktion mit der projektlokalen Rust-Toolchain:

```sh
python3 Scripts/generate-opening-book.py --check
CARGO_HOME="$PWD/.build/cargo" RUSTC="$PWD/.build/rust-sysroot/bin/rustc" CARGO_PROFILE_RELEASE_STRIP=none /opt/homebrew/bin/cargo run --manifest-path Engine/Cargo.toml --locked --offline --release --example check_opening_book
```

Die vorhandenen Spielstufenvergleiche bleiben historische **Suchprofil**-Vergleiche. Buchtreffer auf Stufe 4/5 verändern deren Zugwahl; eine neue allgemeine Rangliste oder garantierte Verbesserung wird nicht daraus abgeleitet. In dieser Version wird die Liste nicht durch unbewiesene zusätzliche Linien „vervollständigt“.

## Perfekte Datenbank: vorerst nicht integrieren

Der Name bezeichnet vorausberechnete Stellungen mit spieltheoretischen Werten. Das bringt einen echten Qualitätsgewinn bei abgedeckten, exakt passenden Regeln. Für eine vollständige Auswahl müssen alle relevanten Folgezüge einschließlich erzwungener Abnahmen bewertet werden können; ein einzelner vorhandener guter Zug genügt nicht als Optimalitätsnachweis.

| Verfügbare Quelle | Tatsächlicher Umfang / Grenze |
| --- | --- |
| Dateien direkt im Sanmill-Repository | 32 Dateien, zusammen **28.314.958 Byte**: Standard 20 Dateien (28.202.046 Byte), Morabaraba 7 (63.524), Lasker 5 (49.388). Darunter Metadaten, frühe Setzsektoren und wenige Standard-Endspiele (3:3, 3:4, 4:3). Keine vollständige Datenbank. |
| Vollständige Standard-Ultra-strong-Daten | Sanmills Untersuchung nennt **83.582.223.577 Byte**, darunter 498 Standardsektoren. Die Malom-Projektseite bietet große Torrent-Pakete für die Varianten an. |
| Experimentelle kompakte Standard-WDL-Daten | Sanmills Bericht nennt **2.102.791.559 Byte** für 2-Bit-W/D/L mit zstd. Das bewahrt Gewinn/Remis/Verlust, aber nicht sämtliche zusätzlichen Ultra-strong-/Gewinndistanz-Informationen. Kein in dieser Aufgabe heruntergeladenes oder validiertes iOS-Datenpaket. |
| Noch kleinere Sicherheitsdaten | Rund 0,99–1,10 GB; können bei passender Regelbasis einen vermeidbaren Verlust verhindern, aber einen möglichen Gewinn zum Remis abschwächen. Deshalb kein Ersatz für einen „perfekten“ Modus. |

**Technische Präzisierung gegenüber der vorigen Übersicht:** Der geprüfte Stand enthält bereits einen Rust-nativen `perfect-db`-Leser; C++ ist nur noch optionaler Vergleichs-Oracle (`cpp-oracle`). Die Sprache der Anbindung ist somit kein Hinderungsgrund. Es blieben insbesondere Datenprovider/Dateiverwaltung, begrenzter Cache, optionale Downloads mit Integritätsprüfung, Umgang mit fehlenden Sektoren und Regelvalidierung.

**Warum auch das kleine Teilpaket jetzt entfällt:** Es verbessert nur bestimmte Eröffnungen und sehr späte Materialkonstellationen. Das kompakte Eröffnungsbuch deckt den unkomplizierten Nutzen bereits ab. Für die wenigen Endspiele müssten trotzdem Datenformat, Koordinaten, Zugdistanz-/Remisregeln und vollständige Folgeabdeckung validiert werden. Ein unsichtbarer Wechsel zwischen begrenzt suchender KI und exakt spielenden Teilstellungen erschwert zudem die Einordnung unserer fünf Stufen. Etwa 28 MB Zusatzdaten allein machen noch keinen perfekten Gegner.

**Regeln sind ein eigener Nachweis:** Der Sanmill-Regelfilter verlangt unter anderem einfache statt mehrfache Abnahme. Unsere Morabaraba-Variante erlaubt Mehrfachabnahmen und darf die Daten nicht unter ihrem Namen übernehmen. Auch andere Varianten benötigen explizit passende Generatorregeln; Materialzahl und Brettbild reichen nicht. Der Kompressionsbericht selbst nennt die vollständige Regelübereinstimmung samt Laufzeit-Fingerabdruck als offene Freigabebedingung. Der Wurzelzug allein löst Fragen zu Wiederholungen oder späteren Remisgrenzen nicht.

**Wann sich der Aufwand lohnt:** Bei einem eigenständigen optionalen Analyse-/Trainingsmodus mit klarer Anzeige der Abdeckung. Dann zuerst klassische Regeln gegen Generator-Konventionen nachweisen, ein reproduzierbares WDL-Paket samt Herkunft/Rechten/Hashes bereitstellen, Downloads und Speichergrenzen auf Geräten testen und unbekannte Stellungen ausdrücklich als Suche kennzeichnen. Eine 1-Bit-Sicherheitsbibliothek wäre separat zu benennen. Aktuell kein Download, kein Platzhalter-Schalter und keine Behauptung perfekter Spielstärke. Die zurückgestellten Akku-/VoiceOver-Prüfungen bleiben zurückgestellt.

## Primärquellen

- [Sanmill-Eröffnungsbuch und Schichten](https://github.com/calcitem/Sanmill/blob/8901a06f088bf49a1602fee8686ed25ac5a33925/docs/OPENING_BOOK.md), [explizit lizenzierte Orakelquelle](https://github.com/calcitem/Sanmill/blob/8901a06f088bf49a1602fee8686ed25ac5a33925/src/ui/flutter_app/tool/mill_opening_book_oracle_source.dart).
- [Perfect-DB-Kompressionsbericht](https://github.com/calcitem/Sanmill/blob/8901a06f088bf49a1602fee8686ed25ac5a33925/docs/Perfect_DB_Compression_Assessment_for_Mill_Expert_Review.md), [Rust-Paket](https://github.com/calcitem/Sanmill/blob/8901a06f088bf49a1602fee8686ed25ac5a33925/crates/perfect-db/Cargo.toml), [Regelabgleich](https://github.com/calcitem/Sanmill/blob/8901a06f088bf49a1602fee8686ed25ac5a33925/src/ui/flutter_app/lib/games/mill/mill_perfect_database_support.dart).
- [Malom-Projekt: Bedeutung, Quellen und angebotene Datenbanken](https://www.inf.u-szeged.hu/~danner/mills/), online am 01.10.2026 geprüft. Sanmill-Dateien am identischen, lokal vorliegenden gepinnten Quellstand gelesen.
