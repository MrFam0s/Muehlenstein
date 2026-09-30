# Reproduzierbarer Vergleich der Suchverfahren

Dieses Werkzeug ist ein lokaler Entwickler-Test. Es verwendet denselben C-/JSON-Einstieg, dieselben Regeln, dieselbe Stellungsbewertung und dieselben Suchbudgets wie die iOS-App. Der Test läuft als optimiertes Programm auf dem Mac und enthält keine künstliche Zugpause. Der Anwendungscode und die importierten Sanmill-Dateien werden durch das Turnier nicht verändert.

## Ausführen

```sh
bash Scripts/compare-search.sh Docs/Benchmarks/search-confirmation-plan.json .build/mein-neuer-vergleich
```

Der Zielordner muss neu sein. Vorhandene Ergebnisse werden nicht überschrieben. Compiler und Abhängigkeiten kommen aus der bereits eingerichteten lokalen Rust-Umgebung. Es wird nichts hochgeladen. `summary.json` enthält die geprüfte Auswertung; `games.jsonl` enthält jede Partie und jeden berechneten Zug. `manifest.json` enthält den vollständigen Plan und alle vor dem Turnier erzeugten Ausgangsstellungen. `provenance.json` dokumentiert Quell- und Binärprüfsummen sowie die Plattform. Zeitbudgets können zu anderen abgeschlossenen Suchtiefen und Ergebnissen führen; exakte Zeitreproduzierbarkeit wird nicht behauptet.

Tests des Werkzeugs:

```sh
CARGO_HOME="$PWD/.build/cargo" RUSTC="$PWD/.build/rust-sysroot/bin/rustc" RUSTDOC="$PWD/.build/rust-sysroot/bin/rustdoc" /opt/homebrew/bin/cargo test --manifest-path Engine/Cargo.toml --locked --offline --example compare_search
python3 -m unittest discover -s Tests -p test_search_summary.py
```

## Versuchsplan

- Spieler A ist MTD(f), Spieler B PVS. Beide haben dieselbe Stufe, denselben Rechenzeitmodus und denselben Suchspeicher. Verglichen werden die realen Suchkonfigurationen der App einschließlich des zum Verfahren gehörenden Zugsortierkontexts.
- Pro Variante werden mit festem Seed unterschiedliche legale Anfangsstellungen erzeugt. Abwechselnd sind vier, sechs oder acht Setzaktionen vorgegeben. Beide Seiten haben gleich viele Steine; keine vorgegebene Aktion bildet eine Mühle. Lasker startet in diesem Versuch ebenfalls mit gesetzten Steinen. Diese synthetischen Eröffnungen sind kein menschliches Eröffnungsbuch.
- Drehungen und Spiegelungen derselben Brettbelegung werden innerhalb eines Laufs und einer Variante ausgesondert. Die vollständige Sammlung wird vor den Ergebnispartien gespeichert. Sie wird nicht anhand späterer Siege ausgewählt.
- Jede Stellung wird zweimal gespielt: A erhält einmal Weiß, einmal Schwarz. Die Reihenfolge der Farben wechselt zwischen Paaren; Varianten werden abwechselnd getestet. Partien laufen nacheinander.
- Nur reguläre Engine-Ergebnisse zählen. Das Aktionslimit ist keine Remisregel. Fehlgeschlagene oder begrenzte Partien werden getrennt aufgeführt; ihr ganzes Farbpaar wird aus der Punkteauswertung ausgeschlossen. Das Gesamtzeitlimit wird seit dem Bestätigungslauf zwischen Einzelberechnungen geprüft, sodass noch höchstens eine bereits laufende Suche hinzukommt.
- Der erste Plan umfasst 32 Paare je Variante, 256 Partien insgesamt. Der vor Beginn festgelegte Bestätigungslauf verwendet einen neuen Seed und 256 Paare je Variante, also 2.048 Partien. Beide gelten ausschließlich für die damalige Stufe 2, Rechenzeit Normal; seit Einführung der Fünferskala entspricht das unverändert Stufe 3. Der Bestätigungslauf hat einen eigenen vollständigen Ergebnisbericht; Vor- und Bestätigungslauf werden nicht ungekennzeichnet zusammengerechnet.

## Auswertung und Grenzen

Ein Sieg zählt einen Punkt, ein Remis einen halben. Zwei farbvertauschte Partien sind eine gemeinsame Beobachtung. Die fünf möglichen Paarwerte werden protokolliert. Einseitige Auswertungen, die nur Weißpartien zählen, oder eine Behandlung beider Partien als unabhängige Stichproben würden die Unsicherheit falsch beschreiben. Die Paarbetrachtung wird auch in [Stockfishs Fishtest-Methodik](https://official-stockfish.github.io/docs/fishtest-wiki/Fishtest-Mathematics.html) verwendet. Dieses Werkzeug implementiert nicht Fishtests vollständiges Testsystem.

Für den Mittelwert der Paarwerte in [0,1] verwenden wir eine bewusst konservative Hoeffding-Schranke: Radius `sqrt(log(2/alpha)/(2*n))`. Zusätzlich werden über die geplanten Varianten simultane 95%-Grenzen durch Aufteilung von alpha ausgewiesen. Die Grenzen setzen eine unabhängige Stichprobe von Eröffnungspaaren voraus und beziehen sich auf unsere künstliche Eröffnungsverteilung. Sie belegen keine Gleichwertigkeit gegen beliebige menschliche Gegner. Auch bei ausschließlich ausgeglichenen Paaren bleibt eine Unsicherheit bestehen.

Die Laufzeitbeobachtungen stammen aus den tatsächlich gespielten und damit teilweise unterschiedlichen Stellungen. Sie sind kein direkter Geschwindigkeitsvergleich identischer Positionen und kein Energietest. Eine belastbare Effizienzaussage braucht einen eigenen gepaarten Stellungstest auf echter iPhone-Hardware. Eine Elo-Zahl benötigt zusätzlich eine definierte und kalibrierte Vergleichsgruppe.

## Nächster aussagekräftiger Schritt

Für die höchste Stufe ist eine größere, gesonderte Serie nötig, weil hier Zeitgrenzen statt nur Tiefengrenzen wirken. Danach normale und längere Rechenzeit sowie benachbarte Spielstufen vergleichen. Für eine tatsächliche Benutzerempfehlung außerdem menschliche Partien und Geräteverbrauch prüfen. Die aktuelle App-Empfehlung wird nicht allein wegen eines knappen Einzelturniers geändert.

## Fünf Spielstufen

Neue Pläne geben pro Spieler `"level_scale": "five"` und eine Stufe von 1 bis 5 an. Fehlt dieses Feld, gilt unverändert die alte Skala 1 bis 3; insbesondere werden archivierte Pläne nicht stillschweigend neu interpretiert. Die neuen Pläne unter `level-plans/` vergleichen benachbarte Stufen bei MTD(f) und normaler Rechenzeit. Ergebnisse und Einschränkungen stehen in `SPIELSTUFEN-2026-09-30.md`.

## Optionale Spielstile

Seit 01.10.2026 unterstützt ein Spieler zusätzlich `"style": "balanced"` oder `"style": "blocking"`. Ohne Feld bleibt die bisherige ausgewogene Bewertung erhalten. Die beiden Stilpläne vergleichen ausschließlich diesen Parameter bei ansonsten gleichen Einstellungen. Ergebnisse der getrennten Vor- und Folgeserie stehen in `SPIELSTILE-2026-10-01.md`; die Option wird nicht als zusätzliche Stärkeordnung ausgegeben.

## Eröffnungsbuch-Probe

`2026-10-01-eroeffnungsbuch/probe.json` enthält einen gesonderten Quellen-/Laufzeitcheck (leeres Brett + 24 erste Steine, jeweils Buch ein/aus) und eine vollständige Selbstpartie. Ausgeführt durch `Engine/examples/check_opening_book.rs`; Umfang, Quellen, Reproduktion und Grenzen stehen in `../OPENING_AND_DATABASE.md`. Dies ist kein Stärketurnier. Der bisherige Turnierläufer sendet kein `opening_book` und prüft damit bewusst weiterhin reine Suchprofile. Archivierte Stufen-/Stilvergleiche behaupten keine neue Einordnung der Buchzüge.
