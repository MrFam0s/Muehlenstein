# Lizenzprüfung für Muehlenstein

Prüfstand: 01.10.2026. Geprüft wurde der tatsächliche native iOS-Build mit
`Engine/Cargo.lock` und Sanmill `8901a06f088bf49a1602fee8686ed25ac5a33925`.
Dies ist eine technische Quellen-/Lizenzprüfung, keine anwaltliche Zusicherung
über die vollständige historische Rechtekette fremder Projekte.

## Ergebnis und Grenzen

**Projektentscheidung vom 01.10.2026:** Der Projektinhaber bevorzugt die
Veröffentlichung der bestehenden App, solange kein konkreter entgegenstehender
Lizenzbefund vorliegt. Die ausdrückliche Sanmill-Zusatzgenehmigung ist die
Vertriebsgrundlage, nicht lediglich das Fehlen eines Verbots. Die Nachprüfung
hat keinen solchen konkreten Gegenbefund nachgewiesen; sie hat zugleich die
historische Rechtekette nicht vollständig bestätigt. Deshalb wird keine
vorsorgliche Komplettentwicklung begonnen. Die folgenden Restunsicherheiten
bleiben unverändert dokumentiert. Zunächst wird nur die Veröffentlichung
vorbereitet; es erfolgt noch kein Upload oder Store-Release. Das Repository
bleibt als frei zugänglicher Quellkanal öffentlich.

Der vorliegende Quellstand kann nach den gefundenen Lizenzangaben als
unabhängiger AGPL-3.0-or-later-Fork veröffentlicht werden. Ein Verkaufspreis
von 0,99 € ist mit diesem Open-Source-Modell vereinbar; die Empfänger behalten
die Rechte der Lizenz, einschließlich Weitergabe und Änderung. Ein bezahlter
Download macht den Quellcode nicht proprietär. Grundlage sind AGPL §§4–6 und
die [Erläuterung der FSF zum Verkauf freier Software](https://www.gnu.org/philosophy/selling.en.html).

Sanmill erteilt in seinem README ausdrücklich eine zusätzliche Erlaubnis nach
AGPL §7 für App-Store-Vertrieb, unter Erhalt eines frei zugänglichen
AGPL-Quellkanals. Sie ist im importierten README unverändert enthalten.
Für die eigenständigen Muehlenstein-Anteile ist eine entsprechend begrenzte
Erlaubnis in `APP_STORE_PERMISSION.txt` dokumentiert. Name und Bundle-ID sind
vom Original verschieden; die App benennt den unabhängigen Fork.

**Vertiefte Nachprüfung vom 01.10.2026:** Die App-Store-Erlaubnis ist ausdrücklich
auch auf unabhängig benannte Forks ausgerichtet und wurde beim Wechsel von GPL
zu AGPL beibehalten. Ein Verbot entgeltlicher Downloads steht dort nicht.
PerfectAI ist keine Abhängigkeit unseres Builds. Die verbleibende Frage betrifft
konkret die Rechte an möglichen übernommenen Ausdrucksformen im Rust-Kern und
am klassischen Eröffnungsorakel, nicht sämtliche historischen Sanmill-Beiträge.
Die Git-Historie dokumentiert eine Migration und gezielte Übertragungen aus
dem älteren C++-Kern; eine vollständig unabhängige Neuentwicklung ist dadurch
nicht belegt. Eine öffentliche Rechtebestätigung für diese Übernahmen wurde
in den unten bezeichneten Quellen nicht gefunden. **Die Store-Rechtefrage ist
damit eingegrenzt, aber noch nicht abschließend geklärt.** Eine gezielte
[Anfrage an Upstream](UPSTREAM_LICENSE_INQUIRY.md) ist vorbereitet, noch nicht
versandt. Die App und ihre Lizenzheader wurden nicht verändert.

## Herkunft und Reichweite der Zusatzgenehmigung

Die Nachprüfung verwendet die vollständige erreichbare Git-Historie bis zum
festgehaltenen Commit (7.506 Commits), gezielte Quelldiffs und Blame-Abfragen.
Sie ist keine vollständige Ähnlichkeitsanalyse jeder Funktion gegen alle
historischen Fremdprojekte. Der öffentliche `master` entsprach am Prüftag
weiterhin dem festgehaltenen Commit.

| Feststellung | Beleg und Bedeutung |
| --- | --- |
| Calcitem fügte die App-Store-Ausnahme am 02.01.2023 unter GPL §7 hinzu. | [Commit 4b93c0e](https://github.com/calcitem/Sanmill/commit/4b93c0e45829c418242ff612fc8efe3a7b7ad649) ändert README und gebündelten Lizenztext. Die angrenzenden Regeln sprechen ausdrücklich über Forks. Die Ausnahme ist keine bloß aus dem eigenen iOS-Vertrieb abgeleitete Annahme. |
| Am 30.06.2026 wurden Lizenztext, Paketmetadaten und SPDX-Header auf AGPL umgestellt. | [Commit b1088e1](https://github.com/calcitem/Sanmill/commit/b1088e156bd3f98eeb67eff4f57bd368d5596c92) passt auch die Ausnahme ausdrücklich auf AGPL §7 an. Seine Beschreibung enthält keine Erklärung zur Befugnis über historische Fremdbeiträge. |
| Die drei Rust-Pakete wurden ab April 2026 aufgebaut. | [Initialer Workspace, bd4bfe0](https://github.com/calcitem/Sanmill/commit/bd4bfe039c61b1d4bda881bcb46ef9fadf3e197b). Die pfadbezogene Historie der drei Pakete und der heutigen Orakeldatei enthält die Git-Autornamen Calcitem und Cursor Agent. Diese Metadaten belegen weder alleinige Rechtsinhaberschaft noch Freiheit von übernommenem Code. |
| Die Umstellung war keine belegte unabhängige Neuimplementierung ohne Kenntnis des alten Codes. | [MovePicker-Übertragung, 67611b9](https://github.com/calcitem/Sanmill/commit/67611b98fb9297214cac72e5684dcea99e659260), [Quieszenzsuche, 80ae4c2](https://github.com/calcitem/Sanmill/commit/80ae4c29a8326df6a041de69163f6be9b993f756) und [Such-/Wiederholungsparität, fd8ed35](https://github.com/calcitem/Sanmill/commit/fd8ed3520a74df40f4538cc3942dd55d252b3646) beschreiben ausdrücklich die Nachbildung alter C++-Funktionen und ihres Ablaufs. |
| Die alten C++-Dateien wurden gelöscht. | [Commit ff357aa](https://github.com/calcitem/Sanmill/commit/ff357aadc8ec398d6b58b667e23a3f4dc8fa4f41). Das entfernt die Dateien aus dem aktuellen Build, klärt aber keine Rechte an eventuell in Rust übertragenen Bestandteilen. |
| Das klassische Orakel ist von den benannten Eröffnungslinien getrennt. | [Commit ac1084d](https://github.com/calcitem/Sanmill/commit/ac1084d710d5e353632a09a0359c916be14b8f18) verlagert das vorhandene Orakel nach `tool/` und ergänzt getrennt kuratierte Eröffnungen mit Bezug auf NMM_LLM. Muehlenstein übernimmt nur das NMM-Orakel. Der Commit ist keine eigenständige Rechtebestätigung für dessen frühere Herkunft. |

### Konkrete Stockfish-Bezüge

Im verwendeten Rust-Quellbestand stehen drei ausdrückliche Stockfish-Verweise:

- `tgf-search/src/tt.rs:124`: seitenbündige Speicherreservierung; hinzugefügt
  durch [435b719](https://github.com/calcitem/Sanmill/commit/435b719b3e182dc7e738035f69637e3b45bdcbc9).
  Die Funktion verwendet Rusts Speicherallokation und eigene gepackte Tabellen.
- `tgf-mill/src/rules/mod.rs:1667`: Bitmasken für Mühlenlinien; hinzugefügt
  durch [85d0f97](https://github.com/calcitem/Sanmill/commit/85d0f975237503341c5153856171d7f5b679bd45).
  Der Kommentar beschreibt die Übertragung einer Optimierungsidee auf Mühle.
- `tgf-core/src/game.rs:107`: Schnittstelle zur Zählung wiederholter Stellungen;
  hinzugefügt durch den oben verlinkten Commit `fd8ed35`. Die Standardmethode
  liefert null; die konkrete Suche und Historienbehandlung liegen anderswo.

Diese Stellen belegen eine technische Bezugnahme, für sich allein jedoch
keine Übernahme urheberrechtlich geschützter Ausdrucksformen. Ideen und
Grundsätze sind nach [§69a Abs. 2 UrhG](https://www.gesetze-im-internet.de/urhg/__69a.html)
vom Programmschutz ausgenommen. Umgekehrt beseitigt eine Übertragung in eine
andere Programmiersprache nicht automatisch fremde Rechte.

Ein weiterer Treffer in den Commitbeschreibungen, die Stockfish-artige
Lazy-SMP-Abstimmung aus [c1b2419](https://github.com/calcitem/Sanmill/commit/c1b2419a19908694184770ec818756311c9a65b9),
betrifft `tgf-cli/src/mill_uci/`, das nicht übernommen wurde. Der vorhandene
generische Thread-Pool in `tgf-search` ist davon zu unterscheiden. Nur nach
dem Wort Stockfish zu suchen wäre deshalb sowohl zu weit als auch zu eng:
entscheidend ist die Herkunft der tatsächlich übernommenen Umsetzung.

### Rechtliche Schlussfolgerung und nächster Schritt

[AGPL §7](https://www.gnu.org/licenses/agpl-3.0.en.html#section7) erlaubt
Zusatzgenehmigungen im Umfang der entsprechenden urheberrechtlichen Befugnis.
Die [GNU-FAQ zu Ausnahmen](https://www.gnu.org/licenses/gpl-faq.en.html#GPLIncompatibleLibs)
erläutert, dass ein Autor eine solche Ausnahme nicht eigenmächtig für fremde
GPL-Beiträge erteilen kann. Auch die Kombinationserlaubnis in GPL/AGPL §13
ersetzt keine Rechtefreigabe; GPL-Anteile behalten dabei ihre Lizenz.

Im aktuellen `CONTRIBUTING.md` steht keine Abtretung oder Vollmacht zur
Vergabe zusätzlicher Rechte. In den durchsuchten öffentlichen Issues und
Pull Requests zu `license`, `permission`, `AGPL` und `Stockfish` sowie den
Kommentaren der beiden Lizenzcommits wurde keine einschlägige Bestätigung
gefunden. Das ist ein begrenztes negatives Rechercheergebnis, kein Nachweis,
dass private Zustimmungen fehlen.

**Empfehlung:** Zunächst Calcitem um eine auf die drei Pakete und das
klassische Orakel begrenzte Herkunfts-/Rechtebestätigung bitten. Nicht
pauschal alle in AUTHORS genannten Personen anschreiben. Eine belastbare
Antwort sollte benennen, welche Teile eigene Implementierungen sind,
welche fremden geschützten Beiträge gegebenenfalls fortbestehen und wodurch
deren App-Store-Vertrieb gedeckt ist. Eine bloße Wiederholung des README
würde den offenen Punkt nicht beantworten.

Bei vollständiger Bestätigung mit nachvollziehbarer Grundlage: Antwort bzw.
Freigabe dauerhaft zum konkreten Quellstand dokumentieren und die übrigen
Store-Prüfungen fortsetzen. Bei ausdrücklich ausgenommenen Teilen: diese
gezielt ersetzen oder eine eigene Erlaubnis der betroffenen Rechteinhaber
einholen. Bei unklarer Antwort: die konkreten Fundstellen fachkundig prüfen
lassen. Kommentare entfernen, SPDX-Header ändern oder eine Funktion nur
abschalten wäre keine verlässliche Rechteklärung. Die bisherigen Befunde
beweisen keinen Rechtsverstoß und erzwingen für sich genommen keine komplette
Neuentwicklung. Eine eigenständige Engine ist aber eine sinnvolle alternative
Produktentscheidung, wie im folgenden Abschnitt bewertet.

## Alternative: eigener nativer Spielkern

Auf Nachfrage des Projektinhabers bewertet: **Eine eigenständige Swift-Engine
ist für dieses Produkt technisch sinnvoll, wenn Unabhängigkeit und langfristige
Wartbarkeit wichtiger sind als der schnellstmögliche Store-Start.** Das wäre
ein eigenes Entwicklungspaket; die derzeitige App wurde dafür noch nicht
umgestellt. Eine vollständige Klärung der Sanmill-Rechte wäre dadurch für
einen zukünftigen Build ohne Sanmill-Material nicht mehr erforderlich; sie
wird damit nicht rückwirkend für den bestehenden Fork beantwortet.

Die eigene SwiftUI-Oberfläche greift über `Engine.query` auf einen begrenzten
Datenvertrag zu. Der Spielkern lässt sich hinter dieser Grenze austauschen,
ohne das Bedienkonzept neu zu entwickeln. Zu ersetzen wären aber **Regeln,
Zugwahl und Eröffnungsdaten**, nicht nur die drei ausdrücklich Stockfish
erwähnenden Stellen. Aktuell genutzt werden klassische Mühle, Zwölfsteinmühle,
Morabaraba und Lasker-Mühle, fünf Schwierigkeitsstufen, MTD(f)/PVS, zwei
Spielstile, Zeitbudgets, Abbruch, Zughinweise und das klassische Orakel.

Vorgeschlagener Ablauf, noch keine beauftragte Umsetzung:

1. Eigenständige, quellenbelegte Regelspezifikation für die vier Varianten
   und ihre Grenzfälle erstellen: Setzen, Ziehen, Springen, Abnehmen,
   Mehrfachmühlen, volle Bretter, Blockade und Remis. Öffentliche Spielregeln
   und Fachliteratur verwenden; keine Übersetzung der Vendor-Implementierung.
2. Zustandsmodell, Zugerzeugung und Regelprüfung in einem reinen Swift-Modul
   implementieren. Eigene Tests aus den Regeln ableiten; Sanmill-Testcode und
   historische Fixtures nicht als eigene Arbeit übernehmen.
3. Zunächst einen gut überprüfbaren Alpha-Beta-Sucher mit schrittweiser
   Suchtiefenerhöhung, begrenztem Stellungsspeicher und sicherem Zeitabbruch
   bauen. Danach PVS als Optimierung prüfen. MTD(f) ist kein Produktziel und
   muss nicht allein wegen seiner bisherigen Existenz nachgebaut werden.
   Allgemeine Suchprinzipien, etwa Alpha-Beta für Mühle, sind in der
   [Fachliteratur beschrieben](https://www.cambridge.org/core/books/abs/games-of-no-chance/solving-nine-mens-morris/855C0BC5C53321E41B6E7991F919B70D).
4. Eigene Bewertungsfunktion entwickeln und durch reproduzierbare Partien
   abstimmen. Fünf unterscheidbare Stufen neu kalibrieren; bisherige
   Benchmarks, Stärkeannahmen und Parameterwerte nicht ungeprüft übertragen.
   Spielstile nur behalten, wenn ihre Wirkung messbar und verständlich ist.
5. Eröffnungen zunächst berechnen. Später bei Bedarf einen kleinen eigenen
   Katalog durch die eigene Suche erzeugen und dessen Herkunft dokumentieren.
   Das bestehende Sanmill-Orakel nicht weiter einbetten. Eine perfekte
   Datenbank bleibt ein separates Vorhaben.
6. Erst nach Regel-, Taktik-, Abbruch- und Geräteleistungstests umschalten.
   Benchmark-Partien dürfen Sanmill als separat betriebenen Gegner nutzen,
   ohne dessen Quellen oder Zugtabellen in die neue Engine zu übernehmen.
   Rust-Brücke, Vendor-Dateien und generierte Fremddaten dann aus dem neuen
   Auslieferungsumfang entfernen und Lizenzinventar/Buildskripte aktualisieren.

Erwarteter Nutzen: keine fremde Spielengine, keine Rust-/C-Übergangsschicht
im App-Build und klare Verantwortung für Regeln und KI. Apple-Frameworks
und die Swift-Laufzeit bleiben selbstverständlich Abhängigkeiten. Ein
pauschales Ziel „keinerlei Fremdsoftware“ wäre hier weder nötig noch sinnvoll.

Der größte Aufwand liegt in einer belastbar starken KI und den Varianten-
Grenzfällen. Gleiche Spielstärke, Geschwindigkeit oder Energieverbrauch wie
Sanmill sind vor Messungen nicht zugesichert. UI, Animationen und Bedienung
können als eigene Arbeit weiterverwendet werden, müssen beim Austausch der
Datenmodelle aber regressionsgeprüft werden.

Rechtlich ist der Unterschied zwischen einer eigenen Umsetzung der Ideen
und einer Bearbeitung des Codes entscheidend:
[§69a UrhG](https://www.gesetze-im-internet.de/urhg/__69a.html) und
[§69c UrhG](https://www.gesetze-im-internet.de/urhg/__69c.html).
Da der bestehende Code bereits untersucht wurde, wäre die jetzige Arbeit
nicht als strikt abgeschottete Clean-Room-Entwicklung zu bezeichnen. Eine
dokumentierte unabhängige Implementierung benötigt eine eigene Spezifikation,
nachvollziehbare Quellen und eine Prüfung auf übernommene Ausdrucksformen;
für einen formalen Clean-Room-Nachweis wären Spezifikation und Implementierung
personell zu trennen. Die Wahl von Swift allein liefert diesen Nachweis nicht.
Der bestehende veröffentlichte AGPL-Stand und seine Fremdhinweise bleiben
historisch erhalten; eine spätere unabhängige Fassung ändert dessen Rechte
nicht rückwirkend. Open Source kann auch für den eigenen Kern beibehalten werden.

## Tatsächlicher Lieferumfang

- **Sanmill:** unveränderte `tgf-core`, `tgf-mill`, `tgf-search` und das klassische,
  ausdrücklich lizenzierte Eröffnungsorakel; 86 importierte Dateien mit
  übereinstimmenden SHA-256 aus `Engine/UPSTREAM_SHA256.json`. Originale
  Lizenz, README, Autorenangaben und Header bleiben erhalten.
- **Eigene Teile:** SwiftUI-Oberfläche, native Brücke, Buildskripte, eigenes
  geometrisches Icon und eigene Tests; AGPL-3.0-or-later, Urheberangabe
  Fabian Amos / AmoSystems. Impressumsdaten wurden als Angaben aus Practify
  und Besser Lesen übernommen; fremder UI-Code wurde dafür nicht kopiert.
- **Cargo-Abhängigkeiten:** 17 Registry-Pakete/Versionen, davon 10 im normalen
  Bibliotheksgraph und 7 Build-/Prozedurmakro-Pakete. Zusammen mit der eigenen
  Brücke und den drei Sanmill-Paketen sind es 21 Einträge. Der vollständige
  versionsgebundene Nachweis steht in `Licenses/dependencies.json`.
- **Lizenzen dieser Cargo-Pakete:** überwiegend MIT oder Apache-2.0 zur Wahl,
  memchr Unlicense oder MIT, zmij MIT, unicode-ident zusätzlich Unicode-3.0.
  Für die alternativ lizenzierten Komponenten ist die MIT-Option nutzbar;
  beide Originaltexte bleiben zur Nachvollziehbarkeit enthalten. Die Unicode-
  Bedingungen werden zusätzlich erhalten. Keine proprietäre SDK-Abhängigkeit
  ist in diesem Cargo-Build enthalten.
- **Zusatzhinweise:** Crossbeam liefert eine vollständige Drittanbieterdatei,
  einschließlich Go/BSD-, Rust- und Beispielhinweisen (CC BY 3.0). Sie wird
  ungekürzt mitgeliefert. Beispiele/Benchmarks wie `matching` werden nicht
  in die iOS-Bibliothek eingebaut. Die Hauptlizenz allein wurde ausdrücklich
  nicht als Ersatz für diese Datei verwendet.
- **Rust-Standardbibliothek 1.98.1:** ihre originale
  `COPYRIGHT-library.html` wird vollständig gebündelt; zusätzlich werden alle
  sichtbaren Textinhalte in native, begrenzte Leseabschnitte übertragen.
  Dieser offizielle Gesamtnachweis enthält auch nicht für iOS verwendete
  Plattformen und Hilfsbibliotheken. Er ist ein konservativer Hinweissatz,
  keine Behauptung, alle darin genannten Pakete würden in Muehlenstein laufen.
- **Nicht enthalten:** Flutter, FRB, Sanmill-Onlinedienste, Perfect-DB-Leser,
  PerfectAI-C++-Oracle, Perfect-/Human-Datenbanken, Original-App-Logo oder Sounds.
  Die drei Rust-Pakete können intern nicht verwendete Hilfsmodule enthalten;
  übernommen ist kein separates Datenbankpaket oder entsprechendes Asset.

## Behobene Lücke und Wiederholbarkeit

Zuvor enthielt das App-Paket nur den AGPL-Text. Jetzt stehen unter „Über
Mühlenstein“ zusätzlich die eigenen und Sanmill-App-Store-Hinweise, Autoren,
sämtliche Lizenzdateien des erreichbaren Cargo-Buildgraphen sowie die Rust-
Standardbibliotheks-Hinweise offline zur Verfügung. Einzelne lange Texte
werden in unveränderte Textabschnitte zerlegt und mit Seitenwechsel gelesen.
Das vollständige Original-Rust-HTML bleibt ebenfalls im Paket erhalten.

`Scripts/generate-license-notices.py` ermittelt die erreichbaren normalen und
Build-Abhängigkeiten für `aarch64-apple-ios`, trennt Prozedurmakros von der
Laufzeit und lässt reine Entwicklungs-/Benchmark-Abhängigkeiten weg. Es
prüft den Vendor-Hashbestand und schreibt Paketversionen, Lizenzangaben,
Herkunftslinks und Hashes der vollständigen Hinweistexte. `--check` vergleicht
bytegenau mit den versionierten Ergebnissen und ist Bestandteil jedes
Xcode-Engine-Builds. Neue Abhängigkeiten erfordern eine erneute Bewertung,
nicht nur ein blindes Neugenerieren.

```sh
bash Scripts/setup-rust.sh
python3 Scripts/generate-license-notices.py --check
```

Die App-Version und Buildnummer stammen aus `MARKETING_VERSION` und
`CURRENT_PROJECT_VERSION` in `Configuration/App.xcconfig`; die Info.plist
verwendet Xcode-Platzhalter. Die Ressourcenregeneration setzt diese Werte
nicht mehr auf fest codierte Nummern zurück. Für eine spätere Binärfreigabe
sind ein unveränderlicher Quelltag und die Zuordnung zu Version/Build zu
archivieren; dieser erste Repository-Push ist noch keine Binärveröffentlichung.

## Impressum und Datenschutztext

Anbieter: AmoSystems, Fabian Amos, Christburger Str. 15/2, 10405 Berlin,
Deutschland; info@fabianamos.com; amosystems.org; USt-IdNr. DE272109895.
Die Daten stimmen in den beiden vom Nutzer benannten Apps überein.
Name, Anschrift, elektronische Kontaktmöglichkeit und USt-ID sind lokal lesbar;
E-Mail und Website sind direkt über beschriftete Tasten erreichbar. Die
gewöhnliche Steuernummer wird nicht zusätzlich veröffentlicht, da sie nicht
zu den hier übernommenen Pflichtangaben aus §5 DDG gehört. Eine nicht belegte
Registereintragung, Rechtsform oder Telefonnummer wurde nicht erfunden.

Der Datenschutztext beschreibt die implementierte Offline-Funktion,
lokale Speicherung, mögliche Systembackups und die freiwillig geöffneten
externen Links. Angaben aus Practifys Cloud-/Mikrofonfunktionen wurden nicht
übertragen. Apples Privacy-Manifest-/Store-Deklarationsprüfung bleibt ein
separater Punkt der Binärveröffentlichung.

## Primärquellen

- [Sanmill, festgehaltener Quellstand und Terms of Use](https://github.com/calcitem/Sanmill/tree/8901a06f088bf49a1602fee8686ed25ac5a33925)
- [GNU AGPL v3, insbesondere §§4–7 und 13](https://www.gnu.org/licenses/agpl-3.0.en.html)
- [FSF: Verkauf freier Software](https://www.gnu.org/philosophy/selling.en.html)
- [Stockfish-Lizenz als Hintergrund zur historischen Herkunft](https://github.com/official-stockfish/Stockfish/blob/master/Copying.txt)
- [§5 DDG](https://www.gesetze-im-internet.de/ddg/__5.html)
- Paketmetadaten und Originaltexte aus dem tatsächlich gesperrten Cargo-Cache;
  Rust-Hinweise aus der im Projekt installierten offiziellen Distribution.

GNU-Seiten waren während einzelner direkter Abrufe zeitweise nicht erreichbar;
die AGPL liegt zusätzlich vollständig und identisch als Projekt-/Upstream-Lizenz
vor. Die Anbieterwebsite war über das Recherchewerkzeug nicht abrufbar;
Anschrift und Kontakt wurden deshalb aus den ausdrücklich benannten lokalen
Apps abgeglichen, nicht als frisch auf der Website bestätigt ausgegeben.
