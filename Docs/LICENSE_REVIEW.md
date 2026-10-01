# Lizenzprüfung für Muehlenstein

Prüfstand: 01.10.2026. Geprüft wurde der tatsächliche native iOS-Build mit
`Engine/Cargo.lock` und Sanmill `8901a06f088bf49a1602fee8686ed25ac5a33925`.
Dies ist eine technische Quellen-/Lizenzprüfung, keine anwaltliche Zusicherung
über die vollständige historische Rechtekette fremder Projekte.

## Ergebnis und Grenzen

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

**Verbleibende Vertriebsgrenze:** Die drei verwendeten Rust-Pakete und das
Eröffnungsorakel sind ausdrücklich AGPL-3.0-or-later deklariert. Es wurde
kein abweichend lizenzierter Quellheader in diesen übernommenen Rust-/Dart-
Dateien gefunden. Sanmills globale AUTHORS-Datei nennt jedoch historische
Übernahmen unter anderem aus Stockfish und PerfectAI; einzelne Rust-Kommentare
beziehen sich auf Stockfish. Die öffentliche pauschale App-Store-Erlaubnis
beweist für sich allein keine lückenlose Befugnis jedes ursprünglichen
Rechteinhabers. Die Prüfung setzt daher keine verifizierte Übertragung aller
Drittrechte voraus. Vor einem App-Store-Binary ist diese Restfrage bei Bedarf
anhand der konkreten Herkunft mit Upstream bzw. fachkundig zu klären; eine
öffentliche AGPL-Quellveröffentlichung wird dadurch nicht zur Store-Freigabe.
Es wurde niemand im Namen des Anbieters kontaktiert und kein Store-Upload vorgenommen.

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
