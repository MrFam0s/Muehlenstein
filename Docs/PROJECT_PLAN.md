# Muehlenstein — Projektplanung

Aktualisiert am 30.09.2026. Die ursprüngliche Rechts- und Produktplanung liegt unverändert in `Research/Projektplanung_native_iOS_Muehle.pdf`; daneben steht das Rechercheprotokoll zur Namensgebung. Name und Arbeitsordner sind nun festgelegt.

| Meilenstein | Ergebnis und Abnahme | Stand |
| --- | --- | --- |
| 0 — Grundlage | Deutsche/internationale Benennung, Arbeitsordner, Preis-/Open-Source-Modell, festgehaltener Sanmill-Quellstand | Lokal umgesetzt |
| 1 — Design und native Anbindung | SwiftUI-Start, Partie, Konfiguration, iPhone/iPad, Hell/Dunkel, echter Rust-Spielkern, lokale Speicherung, Simulatorprüfung | Bestätigter spielbarer Prototyp; erster lokaler Commit erstellt |
| 2 — Offline-Stabilität | Vollständige Partien einschließlich Ziehen/Springen/Schlagen/Remis, Varianten, Wiederherstellung und Abbruch, Geräte-/VoiceOver-/Energietests | Lokale Regressionsprüfungen erfolgreich: 18 feste Partien, Wiederherstellung nach 1.000 Aktionen, Sonderregeln und Unterbrechungen; echte Geräte, ältere iOS-Versionen, VoiceOver und Energie offen |
| 3 — Sanmill-Funktionsumfang | Weitere sieben Presets und erweiterte Regeln, zusätzliche Suchverfahren, KI gegen KI, Analyse/Stellungseditor, Eröffnungsbuch/Human DB/Perfect DB mit Herkunftsnachweisen | Teilweise: MTD(f)/PVS und Rechenzeitwahl mit Erläuterungen umgesetzt; übriger Umfang geplant |
| 4 — Lernen und Sammlung | Einführung, Rätsel mit geklärten Inhaltsrechten, Import/Export, navigierbare Nachspiel- und Analyseansicht | Geplant |
| 5 — Veröffentlichung | Quellarchiv passend zum Binary, Rechte-/Abhängigkeitsprüfung, Signierung, Datenschutz/Barrierefreiheit/Geräte, Support/Store-Inhalte, deutscher Zielpreis 0,99 € | Geplant |
| 6 — Netzwerk | Zunächst Game-Center-Eignung prüfen; validierte Zugnachrichten, Einladungen/Wiederverbindung/Ergebnisse, Tests auf zwei Geräten; eigener Dienst bei Bedarf | Später |

## Jetzt beurteilen

Die warme Steinrichtung wurde positiv beurteilt. Computerzüge erhalten auf Wunsch ein ruhigeres Tempo und dauerhafte Markierungen des letzten Zuges. Auf Wunsch sind Start-, Spiel- und weitere Ansichten nun ohne Scrollbereiche aufgebaut; längere Inhalte werden in Seiten aufgeteilt. Die Layoutabnahme umfasst kompakte Geräte, Querformat, Großschrift und unbewegliche Brettkoordinaten bei Gesten/Zugwechseln. Offen bleiben insbesondere die echte Geräte-/VoiceOver-Abnahme und das Energie-/Speicherverhalten bei längeren Partien. Änderungen am lokalen Prototyp benötigen keine erneute grundsätzliche Freigabe.

## Nächste Etappe nach dem ersten Commit

Der aktuelle Stand ist als spielbarer Entwicklungsmeilenstein bereit für die erste lokale Versionierung: Die direkte Partie-Konfiguration wurde bestätigt, die Projektidentität bleibt erhalten und die dokumentierten Simulator- und Build-Prüfungen bestehen. Die Abnahme für eine Veröffentlichung steht weiterhin aus.

Als Nächstes wird Meilenstein 2 abgeschlossen:

1. Vollständige Offline-Partien und Randfälle gezielt abnehmen: Setzen, Ziehen, Springen, mehrfache Mühlen, erlaubte Abnahmen, Blockade und Remis in allen vier sichtbaren Varianten. Vorhandene Tests verwenden und nur belegte Lücken ergänzen.
2. Unterbrechungen und Speicherung prüfen: Hintergrund/Vordergrund, Beenden und Wiederöffnen, Rücknahme und neue Partie während einer Computersuche. Ergebnisse und Wiederherstellung müssen konsistent bleiben.
3. Auf echten iPhones und iPads Spielgefühl, VoiceOver, Lesbarkeit, längere Computersuchen sowie Energie- und Speicherverhalten prüfen. Simulatorbefunde und echte Gerätebefunde getrennt dokumentieren.
4. Gefundene Probleme beheben und den stabilen Offline-Stand sichern. Danach den noch fehlenden Sanmill-Funktionsumfang priorisieren, insbesondere Nachspiel/Analyse und weitere Regeln. Die Netzwerkfunktion bleibt eine spätere, eigene Etappe.

Die nächste Arbeit erweitert damit vor allem die Verlässlichkeit des bestätigten Bedienkonzepts. Eine zahlenmäßige Elo-Anzeige bleibt bis zur belastbaren Kalibrierung zurückgestellt.

Fortschritt: Die Punkte 1 und 2 sind mit festen Referenzpartien, ergänzenden Regelprüfungen und App-Unterbrechungstests lokal geprüft. Ein Fehler in der Zugliste bei bereits ausgewähltem Stein wurde reproduziert und korrigiert. Der vorhandene Simulator läuft mit iOS 27; ältere Laufzeiten und echte Geräte waren nicht erreichbar. Punkt 3 bleibt daher ausdrücklich offen. Die Einzelbefunde stehen in `VALIDATION.md`.

## Umfang und offene Produktangaben

Die ursprünglichen 70–110 Personentage sind die erste Planungsspanne für das gesamte Offline-Produkt. Dieser Prototyp erfüllt noch nicht diesen Gesamtumfang. Nach Geräteintegration und genauer Funktionsabnahme neu schätzen. Die vorläufige Netzwerkplanung bleibt separat: 4–7 Wochen mit Game Center oder 8–14 Wochen mit eigenem Dienst, abhängig vom Umfang.

Bundle-Identifier `org.amosystems.Muehlenstein` und das vorhandene Developer-Team sind im lokalen Projekt dauerhaft konfiguriert. Für eine Veröffentlichung fehlen unter anderem der bestätigte Store-Datensatz, ein öffentliches Quellrepository, Support-Kontakt und die abschließende Rechteprüfung. Für weitere Simulatorarbeit werden keine Zugangsdaten benötigt. Store-Eintrag, Domain und Marke wurden nicht reserviert; kein Repository wurde veröffentlicht.

## Tatsächliche Funktionsabdeckung

Die drei übernommenen Engine-Pakete enthalten alle elf Presets sowie ihre ursprünglichen Bewertungen und Suchalgorithmen. Die App zeigt zunächst vier Varianten, fünf vorläufige Spielstufen sowie MTD(f)/PVS und zwei Rechenzeitmodi ausschließlich unter „Erweitert“. Spielhilfen sind einzeln schaltbar. Sie entspricht damit noch nicht dem gesamten Sanmill-Produkt. Die ursprüngliche Zugwahl über Eröffnungsbuch, Human Database und Perfect Database ist noch nicht eingebunden. Eine Gleichwertigkeit der Spielstärke wurde nicht gemessen.

## Spielstärke und spätere Anpassung

Aktuell wird die gewählte Stufe 1–5 angezeigt, keine erfundene Elo-Zahl. Vor einer numerischen Mühle-Wertung stehen reproduzierbare Vergleichspartien, Varianten- und Geräteabgleich sowie eine Kalibrierung mit Menschen. Glicko-2 mit sichtbarer Unsicherheit ist ein möglicher späterer Ansatz. Ein optionaler adaptiver Gegner darf die Schwierigkeit transparent zwischen Partien vorschlagen; kein versteckter Stufenwechsel mitten im Spiel. Details und Quellen stehen in `AI_OPTIONS.md`. Eine öffentliche Rangliste folgt erst nach dem Netzwerk- und Ergebnisvalidierungskonzept.

Ein reproduzierbarer Turnierläufer ist umgesetzt. Der Bestätigungslauf vom 30.09.2026 umfasst 2.048 reguläre Partien auf Stufe 2 / Normal mit getrennten Ergebnissen für alle vier Varianten und vollständiger Archivierung. Kein belastbarer Vorteil eines Suchverfahrens; die Voreinstellung bleibt unverändert. Der höchste Schwierigkeitsgrad ist noch gesondert mit größerer Stichprobe zu prüfen. Der Ergebnisbericht liegt unter `Benchmarks/ERGEBNISSE-2026-09-30.md`.
