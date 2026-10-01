# Muehlenstein — Projektplanung

Aktualisiert am 01.10.2026. Markierter Release-Quellstand: **Version 1.0.1, Build 4, Tag v1.0.1**; dieser Stand ist noch nicht als Gerätearchiv erstellt. Das Archiv zu `v1.0` bleibt als historischer Nachweis erhalten. Die App ist bei Apple registriert, noch nicht zur Prüfung eingereicht. Die ursprüngliche Rechts- und Produktplanung liegt unverändert in `Research/Projektplanung_native_iOS_Muehle.pdf`; daneben steht das Rechercheprotokoll zur Namensgebung.

| Meilenstein | Ergebnis und Abnahme | Stand |
| --- | --- | --- |
| 0 — Grundlage | Deutsche/internationale Benennung, Arbeitsordner, Preis-/Open-Source-Modell, festgehaltener Sanmill-Quellstand | Lokal umgesetzt |
| 1 — Design und native Anbindung | SwiftUI-Start, Partie, Konfiguration, iPhone/iPad, Hell/Dunkel, echter Rust-Spielkern, lokale Speicherung, Simulatorprüfung | Bestätigter spielbarer Prototyp; erster lokaler Commit erstellt |
| 2 — Offline-Stabilität | Vollständige Partien einschließlich Ziehen/Springen/Schlagen/Remis, Varianten, Wiederherstellung und Abbruch, Geräte-/VoiceOver-/Energietests | Lokale Prüfungen und erster physischer iPhone-Gesamtlauf erfolgreich; erste CPU-/Speicherwerte vorhanden. Weitere Geräte, ältere iOS-Versionen, vollständige Barrierefreiheit und Energie-Langzeittest offen |
| 3 — Sanmill-Funktionsumfang | Weitere sieben Presets und erweiterte Regeln, zusätzliche Suchverfahren, KI gegen KI, Analyse/Stellungseditor, Eröffnungsbuch/Human DB/Perfect DB mit Herkunftsnachweisen | Teilweise: MTD(f)/PVS, Rechenzeitwahl, Spielstil und kleines klassisches Eröffnungsbuch umgesetzt. Perfect DB nach Aufwand-/Nutzenprüfung vorerst zurückgestellt; Analyse bleibt späteres Vorhaben |
| 4 — Lernen und Sammlung | Einführung, Rätsel mit geklärten Inhaltsrechten, Import/Export, navigierbare Nachspiel- und Analyseansicht | Geplant |
| 5 — Veröffentlichung | Quellarchiv passend zum Binary, Rechte-/Abhängigkeitsprüfung, Signierung, Datenschutz/Barrierefreiheit/Geräte, Support/Store-Inhalte, deutscher Zielpreis 0,99 € | Version 1.0.1 (Build 4) als Quellstand v1.0.1 markiert; bisheriges Archiv zu v1.0, DE/EN-Store-Unterlagen, Screenshots, Datenschutz und Support vorbereitet. Bundle-ID und Store-Datensatz 6818139673 registriert. Neues Archiv und aktuelle Store-Aufnahmen für v1.0.1, Distributionssignierung, Store-Inhalte, Apple-Validierung und Einreichung offen |
| 6 — Netzwerk | Zunächst Game-Center-Eignung prüfen; validierte Zugnachrichten, Einladungen/Wiederverbindung/Ergebnisse, Tests auf zwei Geräten; eigener Dienst bei Bedarf | Später |

## Jetzt beurteilen

Die warme Steinrichtung wurde positiv beurteilt. Waldgrün ist der Standardakzent; vier weitere Farben sind unter Darstellung dauerhaft wählbar. Computerzüge erhalten auf Wunsch ein ruhigeres Tempo und dauerhafte Markierungen des letzten Zuges. Steine gleiten mit einer kurzen, sanften Animation; diese ist unter Mehr → Darstellung abschaltbar und berücksichtigt „Bewegung reduzieren“. Start-, Spiel- und Konfigurationsansichten bleiben ohne Scrollbereiche. Regeln und Zuglisten verwenden Seiten; die Informationsrubriken unter „Über Mühlenstein“ sind auf Wunsch vom 01.10.2026 hingegen als gegliederte, scrollbare Leseseiten gestaltet. Die Layoutabnahme umfasst kompakte Geräte, Querformat, Großschrift und unbewegliche Brettkoordinaten bei Gesten/Zugwechseln. Die erste echte iPhone-Prüfung ist abgeschlossen. VoiceOver und Akkutests sind auf Wunsch vom 30.09.2026 zurückgestellt; sie bleiben vor einer Veröffentlichung einzuplanen. Änderungen am lokalen Prototyp benötigen keine erneute grundsätzliche Freigabe.

## Offline-Validierung und Restarbeiten

Der Offline-Stand ist öffentlich versioniert und als Version 1.0.1 (Build 4) markiert. Die direkte Partie-Konfiguration wurde bestätigt, die Projektidentität bleibt erhalten und die dokumentierten Simulator- und Build-Prüfungen bestehen. Als Nächstes folgen bei Freigabe die in `../Store/README.md` aufgeführten Einreichungsschritte; dieser Quellstand wurde noch nicht bei Apple hochgeladen. Die bereits durchgeführten Prüfungen und verbliebenen Lücken bleiben getrennt dokumentiert.

Die verbleibenden Arbeiten an Meilenstein 2 sind:

1. Vollständige Offline-Partien und Randfälle gezielt abnehmen: Setzen, Ziehen, Springen, mehrfache Mühlen, erlaubte Abnahmen, Blockade und Remis in allen vier sichtbaren Varianten. Vorhandene Tests verwenden und nur belegte Lücken ergänzen.
2. Unterbrechungen und Speicherung prüfen: Hintergrund/Vordergrund, Beenden und Wiederöffnen, Rücknahme und neue Partie während einer Computersuche. Ergebnisse und Wiederherstellung müssen konsistent bleiben.
3. Auf echten iPhones und iPads Spielgefühl, VoiceOver, Lesbarkeit, längere Computersuchen sowie Energie- und Speicherverhalten prüfen. Simulatorbefunde und echte Gerätebefunde getrennt dokumentieren.
4. Gefundene Probleme beheben und den stabilen Offline-Stand sichern. Danach den noch fehlenden Sanmill-Funktionsumfang priorisieren, insbesondere Nachspiel/Analyse und weitere Regeln. Die Netzwerkfunktion bleibt eine spätere, eigene Etappe.

Die nächste Arbeit erweitert damit vor allem die Verlässlichkeit des bestätigten Bedienkonzepts. Eine zahlenmäßige Elo-Anzeige bleibt bis zur belastbaren Kalibrierung zurückgestellt.

Fortschritt: Die Punkte 1 und 2 sind mit festen Referenzpartien, ergänzenden Regelprüfungen und App-Unterbrechungstests lokal geprüft. Ein Fehler in der Zugliste bei bereits ausgewähltem Stein wurde reproduziert und korrigiert. Der erste vollständige Gerätelauf auf iPhone 18 Pro / iOS 27.0.1 besteht, ebenso die Nachprüfungen verbesserter Bedienflächen und echter Textvergrößerung. Erste CPU-/Speichermessungen sind archiviert. Punkt 3 bleibt für weitere Geräte, ältere iOS-Versionen, manuelles VoiceOver, offene Inspector-Befunde und Energie über längere Partien offen. Die Einzelbefunde stehen in `VALIDATION.md`.

## Abgeschlossene Gestaltungsetappe: Kontrast und App-Icon

Auf Wunsch vom 30.09.2026 folgen jetzt die Kontrastprüfung und das App-Icon. Vollständige VoiceOver-Abnahme und Akkutests werden vorläufig zurückgestellt. Das ist eine Umpriorisierung, keine Abnahme dieser offenen Punkte.

- Umgesetzt: Kontrast der Texte, Brettlinien, Steinränder, Auswahl- und Abnahmemarkierungen in Hell und Dunkel messen; transparente und native Systemflächen anhand gerenderter Ansichten beurteilen. Ergebnisse unter `Contrast/` und in `VALIDATION.md`.
- Umgesetzt: Eigenes Icon aus Mühle-Geometrie und zwei Steinen, mit Standard-, Dunkel- und Tönungsvorlage. Export, kleine Größen und Xcode-Integration prüfen; Gestaltung anschließend in der laufenden App beurteilen.
- Nach dieser Gestaltungsetappe den nächsten Funktionsumfang auswählen. Netzwerk bleibt eine spätere Etappe.

## Umfang und offene Produktangaben

Die Original-KI-Optionen wurden am 01.10.2026 erneut gegen den aktuellen öffentlichen Sanmill-Stand geprüft (`AI_OPTIONS.md`). Fünf Suchstufen bleiben bestehen. Beweglichkeit ist bereits automatisch aktiv; der nun optionale Blockierstil gehört ausschließlich in die erweiterten Einstellungen. Zwei getrennte Stilserien mit insgesamt 576 vollständigen Partien begründen keine automatische Aktivierung als Stärkeverbesserung. Die Stufenbudgets bleiben unverändert.

Das geprüfte klassische Eröffnungsbuch ist seit 01.10.2026 umgesetzt: 109 Stellungen/437 Kandidaten, 16 Symmetrien, Legalitätsprüfung und Such-Fallback, Automatisch/Aus unter Erweitert, automatische Nutzung nur auf Stufe 4/5. Eine perfekte Datenbank bleibt nach konkreter Bewertung zurückgestellt: selbst die experimentelle exakte WDL-Kompression benötigt rund 2,1 GB, Teilpakete bieten nur begrenzte Abdeckung und die Regelübereinstimmung benötigt einen eigenen Nachweis. Ein späterer optionaler Analysemodus ist der passendere Ort. Details: `OPENING_AND_DATABASE.md`. Zehn Stufen erst bei belegbaren Zwischenabstufungen, Sprachmodell-Erklärungen nur als eigenständige optionale Trainerfunktion. Diese Punkte ersetzen weder die geplante Netzwerkphase noch die zurückgestellten Geräte-/Energieprüfungen.

Die ursprünglichen 70–110 Personentage sind die erste Planungsspanne für das gesamte Offline-Produkt. Dieser Prototyp erfüllt noch nicht diesen Gesamtumfang. Nach Geräteintegration und genauer Funktionsabnahme neu schätzen. Die vorläufige Netzwerkplanung bleibt separat: 4–7 Wochen mit Game Center oder 8–14 Wochen mit eigenem Dienst, abhängig vom Umfang.

Bundle-Identifier `org.amosystems.Muehlenstein` und das vorhandene Developer-Team sind im lokalen Projekt dauerhaft konfiguriert. Bundle-ID und Store-Eintrag **Mühlenstein**, Apple-ID **6818139673**, wurden am 01.10.2026 registriert und überprüft; Zuletzt geprüfter Apple-Stand: Version 1.0 in Vorbereitung zur Übermittlung. Die lokale Anhebung auf 1.0.1 hat diesen Datensatz nicht verändert. Quellrepository, Impressum, Kontakt, Versionsanzeige und Lizenznachweise sind vorbereitet bzw. veröffentlicht; der genaue Prüfstand und die verbleibende Dritt-Rechtefrage stehen in `LICENSE_REVIEW.md`. Für eine Binärveröffentlichung fehlen unter anderem die vollständigen Store-Angaben und die abschließenden Vertriebs-/Datenschutzprüfungen. Für weitere Simulatorarbeit werden keine Zugangsdaten benötigt. Eine neue App-Domain und Marke wurden nicht reserviert. Quellrepository: https://github.com/MrFam0s/Muehlenstein.

## Tatsächliche Funktionsabdeckung

Die drei übernommenen Engine-Pakete enthalten alle elf Presets sowie ihre ursprünglichen Bewertungen und Suchalgorithmen. Die App zeigt zunächst vier Varianten, fünf vorläufige Spielstufen sowie MTD(f)/PVS und zwei Rechenzeitmodi ausschließlich unter „Erweitert“. Zugziele und letzter Zug sind unter Darstellung einzeln zuschaltbar; beide sind anfangs aus. Der anfangs ausgeschaltete Schalter „Steinanimationen deaktivieren“ lässt sanfte Bewegungen aktiv. Sie entspricht damit noch nicht dem gesamten Sanmill-Produkt. Ein kompaktes klassisches Eröffnungsbuch ist eingebunden; Human Database und Perfect Database bleiben außerhalb des aktuellen Produkts. Eine Gleichwertigkeit der Spielstärke wurde nicht gemessen.

## Spielstärke und spätere Anpassung

Aktuell wird die gewählte Stufe 1–5 angezeigt, keine erfundene Elo-Zahl. Vor einer numerischen Mühle-Wertung stehen reproduzierbare Vergleichspartien, Varianten- und Geräteabgleich sowie eine Kalibrierung mit Menschen. Glicko-2 mit sichtbarer Unsicherheit ist ein möglicher späterer Ansatz. Ein optionaler adaptiver Gegner darf die Schwierigkeit transparent zwischen Partien vorschlagen; kein versteckter Stufenwechsel mitten im Spiel. Details und Quellen stehen in `AI_OPTIONS.md`. Eine öffentliche Rangliste folgt erst nach dem Netzwerk- und Ergebnisvalidierungskonzept.

Ein reproduzierbarer Turnierläufer ist umgesetzt. Der Bestätigungslauf vom 30.09.2026 umfasst 2.048 reguläre Partien auf Stufe 2 / Normal mit getrennten Ergebnissen für alle vier Varianten und vollständiger Archivierung. Kein belastbarer Vorteil eines Suchverfahrens; die Voreinstellung bleibt unverändert. Der höchste Schwierigkeitsgrad ist noch gesondert mit größerer Stichprobe zu prüfen. Der Ergebnisbericht liegt unter `Benchmarks/ERGEBNISSE-2026-09-30.md`.
