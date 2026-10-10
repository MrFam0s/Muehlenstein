# Prüfstand — begonnen 30.09.2026, ergänzt 01.10.2026

Lokaler Entwicklungsstand, Xcode 27.0, Swift 6.4, offizieller projektlokaler Rust-Compiler 1.98.1. Deployment-Ziel iOS 18.0. Die Simulatoren verwenden iOS 27.0.

## Bestätigte Icon-Farbinversion — 01.10.2026

Das Standard-Icon mit beigem Hintergrund und waldgrünem Motiv entspricht
bytegenau der bestätigten Vorschau `App-Icon-Beige-Study.png`. Der Generator
erzeugt die neue Standardpalette dauerhaft; `--icons-only` überspringt bei
reinen Icon-Farbänderungen die unveränderten Logo-PDFs. Die aktualisierte
Vorschau aller Erscheinungsbilder wurde bei 29/40/60 pt gesichtet.
Das Icon ist weiterhin 1024 × 1024 Pixel groß, RGB und ohne Alphakanal.
Der Release-Simulatorbuild inklusive Asset-Katalog besteht
(`.build/Icon-Beige-build.log`). Keine Logikänderung und daher kein erneuter
Spieltestlauf. Dieser Entwicklungsnachtrag liegt nach dem festen Tag `v1.0.2`;
kein neues Gerätearchiv und keine neue Veröffentlichung bei Apple.

## Logo und Version 1.0.2 (5) — 01.10.2026

- Gemeinsame Core-Graphics-Geometrie für das neue Rauten-Signet, zwei
  transparente PDF-Vektorlagen in der App sowie drei App-Icon-Varianten.
  Der Asset-Katalog kompiliert erfolgreich; keine neue Projektdatei-Referenz
  nötig. Das bestehende Startseiten-Layout ist unverändert.
- Drei UI-Tests und ein Modelltest im Release-Simulatorbuild erfolgreich:
  Start/Konfiguration ohne Scrollen, Farbauswahl mit Speicherung und Neustart,
  „Über Mühlenstein“ sowie Bundlewerte/Lizenzpaket. Ergebnis:
  `.build/Logo-Forest.xcresult`, Protokoll `.build/Logo-Forest.log`.
- Sichtprüfung der exportierten Startseite in Hell, Dunkel und Aubergine:
  beide Logo-Lagen sichtbar, Akzentwechsel korrekt, Schriftzug und Brett
  behalten ihre Anordnung. Aktuelle Waldgrün-Aufnahmen unter
  `Previews/Forest-Home-iPhone-Light.png` und `Previews/Forest-Home-iPhone-Dark.png`.
- Alle drei Icon-PNGs sind 1024 × 1024 Pixel, sRGB, ohne Alphakanal. Vorschau
  mit großen Icons sowie 60/40/29 pt in `Previews/App-Icon-Appearances.png`
  gesichtet; die kleinsten Motive bleiben unterscheidbar. Die Vorschau ersetzt
  keine erneute Geräteprüfung der iOS-Tönung oder Systemeffekte.
- Alle 170 bestehenden Farbrollenprüfungen bestehen weiterhin. Keine neuen
  Abhängigkeiten, Änderungen am Spielkern oder neue Lizenztexte.
- Die erzeugte App enthält `org.amosystems.Muehlenstein`, Version `1.0.2`,
  Build `5`. Die Zulässigkeit von Patchversionen ist mit Apple-Quellen in
  `RELEASE.md` dokumentiert. Kein neues Gerätearchiv, keine Installation auf
  dem physischen iPhone und kein App-Store-Upload in diesem Schritt.

Die folgenden Abschnitte dokumentieren die jeweiligen früheren Prüfstände.

## Spielhilfen und Computeroptionen

- **Rust:** 11 eigene Schnittstellentests und 288 unveränderte Upstream-Bibliothekstests erfolgreich, insgesamt 299. Beide Suchverfahren und beide Zeitbudgets liefern in allen vier sichtbaren Varianten legale Antworten in Anfangs- und Schlagstellungen. Vollständige KI-Partien mit MTD(f) und PVS enden in jeder dieser Varianten regulär. Abbruchkennungen bleiben getrennt; unbekannte Suchoptionen werden abgelehnt.
- **Swift-Modell:** Alle 11 Modelltests erfolgreich. Neu geprüft sind die getrennt gespeicherten Anzeigeoptionen, das Laden älterer Einstellungen ohne Suchparameter, neue Einstellungen im Speicherformat und der Wechsel während einer laufenden Computersuche. Dabei bleibt die Partie erhalten, genau eine Computerantwort wird ausgeführt und die neue Konfiguration wird gespeichert.
- **iPhone 17e:** Alle 15 unterschiedlichen Bedienungstests sind über den Gesamtlauf und die unten genannten gezielten Nachläufe erfolgreich. Die neuen Tests prüfen Marker ein/aus, unveränderte Brettkoordinaten, gespeicherte Schalter nach Neustart, Stufenanzeige, Auswahl von PVS und längerer Rechenzeit sowie den vollständigen Text einschließlich Empfehlung, Stärken und Schwächen.
- **iPad mini A17 Pro:** Die beiden neuen Funktionsabläufe für Computeroptionen und dauerhaft gespeicherte Spielhilfen sind ebenfalls erfolgreich.
- **iPhone SE, 3. Generation:** Die neuen Optionen lassen sich bei größter Dynamic-Type-Stufe im Querformat vollständig ohne Scrollen bedienen. Die Schalteränderung selbst wird dabei geprüft, nicht nur ihre Erreichbarkeit.
- **Sichtprüfung:** Exportierte Simulatorbilder der Optionen, der Erläuterung und des Bretts ohne Spielhilfen geprüft. Die zunächst gekürzte Dialogüberschrift wurde auf „Computer“ verkürzt. Die Dateien unter `Previews/` dokumentieren den tatsächlichen Entwicklungsstand.
- **Builds:** Simulator und unsignierter generischer iPhone-Gerätebuild erfolgreich. Keine Installation auf echter Hardware und keine Veröffentlichung.

Im ersten Lauf betätigte ein neuer Test den Mittelpunkt der von SwiftUI als Schalter gemeldeten gesamten Zeile statt des Schalters am rechten Rand. Ein anderer Test wählte eine Navigationstaste aus der darunterliegenden Ansicht. Die Tests wählen nun gezielt die tatsächlichen Bedienelemente; beide Abläufe bestehen einschließlich Prüfung des geänderten Wertes. Die App-Logik musste hierfür nicht geändert werden.

## Weiterhin geprüfter Layout- und Spielumfang

Der Gesamtlauf bestätigt auch die vorherigen zwölf Bedienungsabläufe: Start/Konfiguration, alle 24 Bretttasten, Hoch-/Querformat, größte Schrift, stabile Brettkoordinaten nach Wischgeste und Zugwechsel, Computerantwort/Rücknahme, Mühle/Abnahme, Wiederherstellung, englische Benennung sowie seitenweise Regeln und Lizenz. Die vorherigen Layoutabnahmen auf iPad mini und iPhone SE sind zusätzlich dokumentiert in den `FixedLayout-…`-Archiven.

Ein Modelltest zerlegt den vollständigen mitgelieferten AGPL-Text einschließlich Unicode-Testzeichen in Seiten und setzt ihn bei zwei Schriftgrößen unverändert zusammen. Keine Zeichen fehlen oder werden dupliziert. Eigene Ansichten enthalten weiterhin keine ScrollView-, List- oder Form-Container.

Alle 85 importierten Sanmill-Dateien stimmen mit dem SHA-256-Importmanifest überein. Die Integration wählt unveränderte upstream Suchverfahren; sie ersetzt keine Mühleregeln oder Stellungsbewertung durch Swift-Code. Keine vollständige Ausführung sämtlicher separater Upstream-Integrations-/Benchmarkprogramme und keine erschöpfende Prüfung aller Regelkombinationen behauptet.

## Reproduzierbare Nachweise

`bash Scripts/test-engine.sh` führt die Rust-Prüfungen aus. Die iOS-Tests stehen in `Tests/GameStoreTests.swift`, `Tests/MuehlensteinUITests.swift` und im gemeinsamen Xcode-Scheme.

Aktuelle lokale, nicht versionierte Nachweise:

- `.build/options-engine-tests.log` — 299 bestandene Rust-Tests.
- `.build/options-iphone-01.log` — Gesamtlauf: 11 Modelltests und 13 Bedienungstests erfolgreich; zwei neue Bedienungstests mit den beschriebenen Auswahlproblemen. Xcode hing anschließend beim Ergebnisexport; der eigene Prozess wurde beendet. Dieses Ergebnisarchiv ist nicht als vollständiger Nachweis verwendbar, das Textprotokoll ist erhalten.
- `.build/Options-iPhone-02.xcresult` — beide korrigierten Bedienungstests erfolgreich, mit Bildern.
- `.build/Options-iPhone-Final.xcresult` — betroffener Computer-Dialog nach verkürzter Überschrift erneut geprüft.
- `.build/Options-iPad-01.xcresult` — beide neuen Funktionsabläufe erfolgreich.
- `.build/Options-SE-02.xcresult` — größte Schrift, Querformat und tatsächliche Schalterbetätigung erfolgreich.
- `.build/options-device-final.log` — unsignierter iPhone-Gerätebuild.

## Ergänzung Suchvergleich

Der neue Entwickler-Turnierläufer besteht fünf Rust- und drei Python-Tests. Ein 2.048-Partien-Bestätigungslauf mit 1.024 vollständigen Farbpaaren hat keine Engine-Fehler oder Testlimit-Abbrüche; Herkunftsprüfung aller 85 Upstream-Dateien erfolgreich. Der geänderte Erläuterungstext besteht den Dialogtest in `.build/SelfPlay-Explanation.xcresult`. Die Produktions-Suchlogik wurde dabei nicht geändert. Details und Grenzen stehen in `Benchmarks/ERGEBNISSE-2026-09-30.md`; dies ist keine allgemeine Spielstärke- oder Geräteabnahme.

## Ergänzung fünf Stufen und vereinfachte Optionen

Die App nutzt jetzt Stufe 1–5, MTD(f) / Normal / Stufe 3 als Voreinstellung und einen getrennten erweiterten Bereich. Speicherung mit Schema 2, ohne Übernahme früherer Entwicklungsstände.

- **301 Rust-Tests**, fünf Turnierläufer-Tests und drei Auswertungstests bestanden. Alle fünf Profile liefern legale Züge über beide Verfahren und alle vier sichtbaren Varianten; ungültige Stufen werden abgewiesen.
- **11 aktuelle iOS-Modelltests** bestanden: unter anderem Speicherung aller fünf Stufen, Wiederherstellung, Suchabbruch, Änderungen während der Computerberechnung und unveränderte Zugpausen.
- Alle **16 Bedienungsabläufe** im Gesamtlauf und den gezielten Nachprüfungen bestanden. Zwei neue Tests trafen zunächst mehrdeutige native Zurück-/Abbrechen-Tasten unter verschachtelten Sheets. Die Auswahl erfolgt jetzt innerhalb der sichtbaren Navigationsleiste. Übernehmen, Verwerfen, alle fünf Stufen, Hilfetexte, gespeicherte Spielhilfen und Wiederherstellung bestehen im Nachlauf.
- iPhone SE bei größter Schrift und im Querformat: alle normalen und erweiterten Optionszeilen erreichbar, ohne Scrollbereich; Screenshots visuell geprüft. Beide neuen Funktionsabläufe zusätzlich auf iPad mini erfolgreich.
- Unsignierter iOS-Gerätebuild erfolgreich. Kein Test auf physischer Hardware behauptet.

Nachweise: `.build/five-levels-engine.log`, `.build/five-levels-runner.log`, `.build/FiveLevels-iPhone-02.xcresult`, `.build/FiveLevels-SE.xcresult`, `.build/FiveLevels-iPad.xcresult`, `.build/five-levels-device.log`. Der erste Gesamtlauf liegt als Text in `.build/five-levels-iphone-01.log`; nach abgeschlossenen Tests hing sein Xcode-Prozess beim Export und wurde beendet. Sein Ergebnisarchiv wird nicht als vollständiger Nachweis verwendet.

Die zusätzlichen Entwicklungsvergleiche umfassen 1.232 Partien in vollständig abgeschlossenen Serien sowie einen separat ausgewiesenen begrenzten Vorlauf. Rohdaten, Profile, Herkunft und Unsicherheiten stehen in `Benchmarks/SPIELSTUFEN-2026-09-30.md`. Eine allgemeine Rangfolge oder menschliche Elo-Kalibrierung ist damit nicht nachgewiesen.

## Ergänzung Xcode-Projekt und direkte Partie-Einstellungen

`org.amosystems.Muehlenstein` und das vorhandene Team `4WHV5UZ8E5` sind über eine nicht generierte `Configuration/App.xcconfig` konfiguriert. `xcodebuild -showBuildSettings` bestätigt die wirksamen Werte für App, UI- und Modelltests in Debug und Release. Das geöffnete Xcode zeigt das Team, den exakten Identifier und die neuen ordnerbezogenen Gruppen. Es wurden keine Anmeldedaten, Zertifikate oder Store-Einträge angelegt.

Das frühere Projekterzeugungsskript ergänzt jetzt nur fehlende Swift-Dateien und erhält bestehende Konfigurationen. Ein Regressionstest fügt eine neue Quelldatei hinzu, bewahrt individuell gesetztes Team, Bundle-ID und Entitlement-Pfad und prüft wiederholte Ausführung. Ein weiterer Aufruf am echten Projekt lässt die Datei bytegenau unverändert.

Die Neue-Partie-Seite enthält Gegenspieler-Tasten, den Regler 1–5, vier Variantentasten und direkt aufklappbare Suchoptionen. Info-Schaltflächen öffnen die Erläuterungen. Während einer Partie gibt es dieselben Computer-Bedienelemente in einem kompakten Dialog. Spielhilfen haben ein kleineres Blatt und keine unnötige Ein-Seiten-Navigation.

- 11 Modelltests und die drei ersten neuen UI-Abläufe erfolgreich: `.build/InlineSetup-iPhone-01.xcresult`.
- Vollständiger Lauf aller 16 Bedienungsabläufe erfolgreich: `.build/InlineSetup-iPhone-Final.xcresult`, einschließlich Spiel, Rücknahme, Wiederherstellung, Hilfe, Hoch-/Querformat und großer Schrift.
- Beide neuen Funktionsabläufe auf iPad erfolgreich: `.build/InlineSetup-iPad-03.xcresult`. Ein anfänglicher Messfehler des Lazy-Rasters aktivierte dort fälschlich die kompakte Abschnittsauswahl. Ein kleines vollständig berechnetes Raster mit festgelegter Breite behebt dies; die Blatthöhe ist ausdrücklich vorgegeben. Der erste fehlgeschlagene iPad-Lauf hing später beim Export und wurde beendet; der zweite Fehlerlauf ist als Diagnose archiviert.
- Die Bildkontrolle entdeckte trotz zunächst bestandener Sichtbarkeitstests eine Überdeckung unterster Variantentasten bei maximaler Schrift auf dem iPhone SE im Querformat. Die kompakte Ansicht lässt dafür die doppelte Variantenüberschrift weg; ihre Info-Taste sitzt neben den Abschnittstasten. Die Tests prüfen nun zusätzlich die Trennung vom Startknopf und wählen alle vier Varianten tatsächlich aus.
- Alle drei abschließenden SE-Prüfungen bestehen nach dieser Korrektur: `.build/InlineSetup-SE-Verified.xcresult`. Die exportierten Bilder bestätigen die vollständige Darstellung der Varianten und Suchoptionen bei maximaler Schrift im Querformat sowie des aufgeklappten Formulars bei normaler Schrift im Hochformat.
- Der aktuelle unsignierte Gerätebuild besteht: `.build/inline-setup-device-final.log`. Keine Installation auf physischer Hardware behauptet.

Neue Ansichten sind unter `Docs/Previews/New-Game-Inline-…` dokumentiert. Die Suchprofile und der Spielkern wurden bei diesem Oberflächenumbau nicht verändert.

## Ergänzung Offline-Stabilität

Die neue feste Testauswahl in `Tests/Fixtures/offline-games.json` enthält die jeweils kürzeste abgeschlossene Partie je sichtbarer Variante und Ergebnisgrund aus dem archivierten 2.048-Partien-Vergleich. Das sind 18 Partien mit 1.000 Aktionen. Herkunft, Prüfsumme, Partiekennung sowie die unveränderten erwarteten Ergebnisse und Endstellungen sind enthalten. Geprüft werden alle vier Varianten, Siege durch Blockade bzw. Steinverlust, volles Brett in den betreffenden Zwölfsteinvarianten und Remis durch dreifache Wiederholung bzw. Zugregel. Dies ist ein Regressionstestbestand, keine neue Spielstärkemessung.

- **Rust:** 18 eigene Schnittstellentests und 288 unveränderte Upstream-Bibliothekstests erfolgreich, insgesamt **306**. Die festen Partien werden über jeden Verlaufsschritt erneut geprüft, einschließlich tatsächlicher Sprünge zu nicht benachbarten Feldern, Endergebnis und Ablehnung weiterer Aktionen nach Spielende. Zusätzliche Fälle sichern geschützte Mühlen, die Ausnahme bei ausschließlich geschlossenen Mühlen, eine bzw. zwei Abnahmen bei einer Doppelmühle und Lasker-Ziehen während der Setzphase ab. Eine bereits laufende längere Suche wird bei beiden Suchverfahren nach Abbruch innerhalb des großzügigen lokalen Testlimits von einer Sekunde beendet; daraus wird keine Hardware-Latenzgarantie abgeleitet.
- **Swift:** Alle **17 Modelltests** erfolgreich. Jede der 1.000 Referenzaktionen wird über die Bretteingabe gespielt, gespeichert und in einer neuen GameStore-Instanz geladen. Zugverlauf, Stellung, legale Aktionen und letzte Zugmarkierung stimmen überein; alle Partien lassen sich bis zum Anfang zurücknehmen. Weitere Fälle prüfen Wiederherstellung zwischen zwei Morabaraba-Abnahmen, Neustart einer unterbrochenen Computer-Abnahme, verworfene Hinweise, falsche Metadaten/Akteure und illegale gespeicherte Züge. Ungültige Dateien bleiben unverändert erhalten.
- **Bedienung:** Drei neue Abläufe auf iPhone 17e erfolgreich: direkte Zugauswahl bei bereits ausgewähltem Lasker-Stein, Hintergrund und Neustart vor einer ausstehenden Abnahme sowie genau eine Computerantwort über Hintergrund und Neustart hinweg. Die Zugauswahl besteht zusätzlich auf iPhone SE. Die neuen Abläufe ergänzen die zuvor bestandenen 16; ein erneuter Gesamtlauf aller 19 wird hier nicht behauptet.
- **Fehler und Korrektur:** Der Zuglisten-Test reproduzierte, dass die bisherige Simulation zweier Brettberührungen den ausgewählten Ausgangsstein abwählte und bei Lasker stattdessen einen neuen Stein setzte. Die Liste führt jetzt die vollständige, erneut auf Legalität und Zugberechtigung geprüfte Aktion aus. Derselbe Test besteht nach der Korrektur. Ein erster Testentwurf hatte noch die falsche Menübeschriftung; erst der korrigierte Nachweislauf wird als Reproduktion des Produktfehlers gewertet.
- **Projekt und Herkunft:** Vier Python-Prüfungen bestehen, einschließlich Erhalt bestehender Projekteinstellungen beim Ergänzen von Quelldateien. Alle 85 importierten Sanmill-Dateien stimmen weiterhin mit dem Importmanifest überein. Die gemeinsamen Partie-Fixtures sind ausschließlich im Modelltest-Bundle enthalten.
- **Build:** Der aktuelle unsignierte iOS-Gerätebuild ist erfolgreich. Das ist keine Ausführung auf physischer Hardware.

Nachweise: `.build/offline-engine-final.log`, `.build/Offline-Models-Final.xcresult`, `.build/Offline-Stability-01.xcresult`, `.build/Offline-Chooser-SE.xcresult`, `.build/offline-device-build.log`. Die Fehlerreproduktion liegt unter `.build/Offline-Chooser-Reproduction-02.xcresult`.

Die Geräteabfrage fand kein erreichbares physisches Testgerät; verfügbar ist nur die iOS-27-Simulatorlaufzeit. Tests auf älteren unterstützten iOS-Versionen, manuelles VoiceOver und Messungen von Energie/Speicher auf Hardware sind deshalb weiterhin offen.

## Erste Prüfung auf physischem iPhone

Am 30.09.2026 wurde der Stand von Commit `42bf05b` auf einem physischen iPhone 18 Pro mit iOS 27.0.1 ausgeführt. Die aktuelle App wurde mit dem bereits konfigurierten Team signiert; Modelltests verwenden temporäre Dateien, Bedienungstests die vorhandenen isolierten Test-Speicherbereiche.

Alle **19 Bedienungstests und 17 Modelltests** bestehen im vollständigen Gerätelauf: `.build/Hardware-FA-iPhone-01.xcresult`. Darunter sind Hoch-/Querformat, größte Schrift, unbewegliche Brettkoordinaten, alle fünf Stufen, gespeicherte Optionen, Zugliste, Mühle/Abnahme, Hintergrund, Beenden/Neustart und Rücknahme. Die exportierten Gerätebilder von Spiel, direkter Partie-Konfiguration und großen erweiterten Optionen wurden visuell geprüft.

Zusätzliche automatische Barrierefreiheitsprüfungen wurden erstmals ergänzt. Ihr erster Lauf meldete unter anderem Kontrast und fehlende Schriftvergrößerung beim rein dekorativen „M“ in der Brettmitte sowie zu kleine tatsächliche Berührungsflächen der Info-Symbole. Die Deko-Beschriftung ist entfernt; die Info-Tasten haben eine ausdrückliche rechteckige Berührungsfläche innerhalb ihrer vorhandenen 44-Punkt-Rahmen. Ein rein dekoratives Trennzeichen wird als kleine Kreisform gezeichnet. Skalenbeschriftung und Abbrechen-Taste verwenden die kräftigere Textfarbe. Nur bei UI-Teststarts wird der Ruhezustands-Timer vorübergehend deaktiviert; gewöhnliche App-Starts behalten das normale Geräteverhalten.

Der abschließende Nachlauf `.build/Hardware-Final-FA-iPhone.xcresult` besteht vollständig: **sechs Bedienungsprüfungen und zwei Leistungsprüfungen**. Die neuen Prüfungen für Elementerkennung, Berührungsflächen, Beschriftung und Accessibility-Traits bestehen auf Start-, Spiel- und Einstellungsseite. Eine getrennte Prüfung vergleicht die tatsächlich gerenderte Textgröße vor/nach größter Dynamic-Type-Einstellung (Höhe mindestens Faktor 1,8), prüft die Erreichbarkeit von Varianten und Suchoptionen und zeichnet die drei Abschnitte auf. Die Bilder unter `Previews/Hardware-iPhone-…` wurden visuell geprüft. Normale und erweiterte Partie-Konfiguration sowie größte Schrift im Querformat bestehen zusätzlich nach den Änderungen.

**Grenze der Barrierefreiheitsprüfung:** Die umfassenderen Inspector-Läufe melden weiter Kontrast bei einzelnen kleinen Ziffern bzw. der nativen Abbrechen-Taste und pauschal teilweise nicht unterstützte Schriftgrößen bzw. möglichen Textbeschnitt. Sichtprüfung und direkte Größen-/Bedienprüfung zeigen dagegen skalierende, erreichbare Inhalte; auch das Weglassen der eigenen iPad-Blattgrößenberechnung beseitigte die Meldungen nicht. Ähnliche Widersprüche sind in einem [Apple-Forumsbeitrag mit Antwort eines Apple-Engineers](https://developer.apple.com/forums/thread/823968) beschrieben. Das ist ein Hinweis auf mögliche Messgrenzen, kein Beweis, dass sämtliche hiesigen Befunde Fehlalarme sind. Die finalen automatischen Accessibility-Prüfungen sind deshalb ausdrücklich auf Elementerkennung, Berührungsflächen, Beschriftung und Traits begrenzt; die Textskalierung wird separat funktional geprüft. Eine vollständige Kontrast-/Dynamic-Type-/VoiceOver-Abnahme wird **nicht** behauptet. Offene Diagnoseprotokolle: `.build/hardware-audit-01.log`, `.build/hardware-audit-02.log`, `.build/audit-sheet-sizing-diagnostic.log`, `.build/audit-contrast-diagnostic-02.log`, `.build/accessibility-verified-se.log`.

Mehrere fehlgeschlagene Diagnose-Läufe hingen nach Testende beim Xcode-Ergebnisexport; ausschließlich die betreffenden eigenen Prozesse wurden beendet. Ihre Textprotokolle bleiben erhalten, unvollständige Ergebnisarchive werden nicht als abgeschlossene Nachweise verwendet. Die beiden oben genannten erfolgreichen Geräteläufe besitzen vollständige Ergebnisarchive.

**Erste Ressourcenmessung:** Je fünf wiederholte Suchanfragen in einer festen Stellung, MTD(f), Swift Debug und Rust Release; die künstliche Zugpause ist ausgeschlossen. Stufe 3 / Normal benötigt im Mittel 0,533 ms, Stufe 5 / Länger 1,330 s. Die CPU-Zeit der längeren Suche beträgt ebenfalls etwa 1,330 s. Der mittlere gemessene Speicherhöchstwert des gesamten Testprozesses beträgt bei Stufe 3 / Normal 42,5 MB und bei Stufe 5 / Länger 38,7 MB. Die unterschiedlichen Höchstwerte erlauben keine Rangfolge der Speicheranforderungen, da Prozesszustand und Allokator-Caches mitwirken. Rohwerte, Stellung und Grenzen stehen in `Benchmarks/2026-09-30-device/measurements.json`. Dies ist weder eine Akkulaufzeitmessung noch ein Nachweis über Speicherverluste oder den Verlauf langer Partien.

Eine zusätzliche, auf den App-Prozess begrenzte Instruments-Aufzeichnung mit Power Profiler kam nicht zustande: Die Namensauflösung fand den Prozess zunächst nicht, der Versuch mit bestätigter Prozesskennung endete beim Warten auf das Gerät mit Timeout. Es liegen deshalb keine belastbaren Energiewerte aus dieser Sitzung vor (`.build/hardware-idle-power-pid.log`).

## Kontrast und App-Icon — 30.09.2026

Auf Wunsch wurden vollständiges VoiceOver und Akkutests zurückgestellt. Diese Etappe umfasst Kontrast und Icon; keine neue Energie- oder VoiceOver-Abnahme wurde durchgeführt.

**Farbprüfung und Korrekturen:** `python3 Scripts/check-contrast.py --json Docs/Contrast/semantic-colors.json` prüft 34 tatsächliche sRGB-Farbpaare in Hell/Dunkel nach relativer Luminanz. Textziel 4,5:1, relevante Grafiken 3:1. Alle bestehen: geringster Textwert 4,88:1 auf der transparenten Auswahlfläche, geringster Grafikwert 3,46:1 bei hellen Brettlinien. Die vorherigen hellen Brettlinien lagen bei 2,66:1, die transparente Zuglinie bei 2,76:1. Die Linien sind jetzt kräftiger bzw. deckend; Nebenbeschriftungen besitzen mehr Reserve. Steinränder haben definierte semantische Farben; die vorher impliziten Steinverläufe haben explizite Endfarben. Innere Abnahmeringe folgen der Steinfarbe statt dem Hell-/Dunkelmodus. Ausgewählte kompakte Reiter erhalten eine Kontur; gedrückte primäre Tasten verlieren keine Deckkraft.

**Gerenderte Ansichten:** Neun Zustände jeweils hell und dunkel auf iPhone 17e / iOS 27 im Simulator sowie iPhone 18 Pro / iOS 27.0.1 auf Hardware: Start, Regeln, Spielhilfen, neue Partie, erweiterte Optionen, Partie, Verlauf und Abnahme auf beiden Steinfarben. Die Kontrast-Review-Tests archivieren jeden Inspector-Befund und prüfen den Ablauf; ihr erfolgreicher Teststatus bedeutet ausdrücklich nicht „keine Inspector-Warnungen“. Auf Hardware besteht zusätzlich die bestehende Prüfung der größten Schrift im Querformat. Nachweise: `.build/Contrast-Review-Final.xcresult`, `.build/Contrast-Review-Hardware.xcresult`. Ein abschließender Gerätelauf nimmt die Bilder erst nach der Audit-Abfrage auf, damit die Berührungsrückmeldung abgeklungen ist: `.build/Contrast-Stable-Hardware.xcresult`. Die versionierten Hardwarebilder stammen aus diesem letzten Lauf; der frühere Lauf mit einer eingeblendeten privaten Systembenachrichtigung bleibt ausschließlich im ignorierten Build-Verzeichnis.

**Inspector-Abgleich:** Auf Start, Partie und Abnahme keine gemeldeten Textkontrastprobleme. Der Inspector meldet weiter einzelne native Fertig-/Abbrechen-Tasten sowie kleine Ziffern (Simulator 2/3, iPhone 3). `Scripts/check-rendered-contrast.py` liest die gemeldeten Rahmen aus den ungekürzten Berichten und bestätigt, dass die vorgesehenen vollen Glyphenfarben tatsächlich im Screenshot vorkommen. Gegen den häufigsten Hintergrundpixel des jeweiligen Rahmens liegen die 28 repräsentativen Messungen zwischen 6,14:1 und 14,43:1: Fertig hell 6,14:1/dunkel 6,34:1, Abbrechen hell 12,29:1/dunkel 9,53:1, Skala hell 11,75:1/dunkel 14,43:1. Messwerte, Pixelzahlen, Rahmen und Screenshot-Prüfsummen stehen in `Contrast/rendered-text.json`; das Hilfsskript benötigt Pillow. Die geprüften Ansichten zeigen lesbare Beschriftungen. Dies widerlegt nicht jede mögliche Inspector-Ursache: Die Stichprobe misst repräsentative Flächen und volle Glyphen, nicht jeden Kantenglättungspixel oder jeden zukünftigen Glas-Hintergrund. Die Rohbefunde bleiben sichtbar und werden nicht als bestandener Inspector-Audit ausgegeben.

**Icon:** Der bisherige Export bestand nach Pixelprüfung vollständig aus Schwarz (1.048.576 Pixel RGB 0/0/0). Der neue Core-Graphics-Export erzeugt drei sichtbare, deckende sRGB-PNGs mit 1024 × 1024 Pixeln für Standard, Dunkel und Tönung. Die originäre Vektorgeometrie bleibt im Swift-Generator editierbar; ein Plausibilitätscheck weist einfarbige/nahezu leere Exporte zurück. Große und kleine Vorschauen bei 60/40/29 Punkten wurden visuell beurteilt. Xcodes Asset-Compiler akzeptiert alle Varianten, der signierte Build wurde auf dem iPhone installiert. Das sind Asset-Catalog-Icons; ein mehrschichtiges Icon-Composer-Dokument und eine vollständige Abnahme sämtlicher Home-Screen-Effekte sind nicht Teil dieser Etappe. Vorschau: `Previews/App-Icon-Appearances.png`.

Vier vorhandene Python-Prüfungen bestehen weiterhin. Die Engine wurde nicht verändert. Der vollständige frühere Regel-/Modelltestbestand wurde für diese Darstellungsänderung nicht erneut ausgeführt.

Quellen für die Kriterien: [W3C Textkontrast](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum), [W3C Nicht-Text-Kontrast](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html), [Apple Asset-Catalog-Icons](https://developer.apple.com/documentation/xcode/configuring-your-app-icon). Keine pauschale Barrierefreiheitszertifizierung: Die vollständige assistive Bedienung und offene Dynamic-Type-/Beschnitt-Heuristiken bleiben separat zu prüfen.

## Sanfte Steinbewegungen und abschaltbare Animationen — 30.09.2026

Steine besitzen jetzt eine rein visuelle, aus ihrer ursprünglichen Setzaktion rekonstruierte Identität. Ziehen/Springen interpoliert dadurch dieselbe Figur zum Ziel, statt zwei feldgebundene Ansichten auszutauschen. Setzen und Abnehmen blenden in 320 ms weich ein/aus; Rücknahme rekonstruiert dieselben Identitäten. Die Engine-Stellung bleibt maßgeblich. Ein neuer Partiestart setzt die Zeichenebene zurück; für statische Illustrationen bzw. unbekannte künftige Notationen gibt es eine direkte Darstellung der Engine-Belegung. Die Spieltasten sind von der nicht interaktiven Zeichenebene getrennt. Bewegte Steine liegen über Linien und Zielpunkten, innere Abnahmeringe bleiben auf den Figuren sichtbar.

Unter „Spielhilfen“ steht der standardmäßig aktive, gespeicherte Schalter „Steinanimationen“. Ausgeschaltet wechselt die Figur unmittelbar; die iOS-Option „Bewegung reduzieren“ unterdrückt die Animation ebenfalls. Erläuterung und Beschriftung sind auf Deutsch und Englisch ergänzt. Die Denkpause der KI und die Zugausführung warten nicht auf Animationen. Das Blatt enthält vier Optionen ohne Scrollbereich und verwendet bei sehr großer Schrift weiterhin seine vorhandene Seitenaufteilung.

**Nachweise:** Drei fokussierte Modellprüfungen bestehen (`.build/Stone-Motion-Models.xcresult`): gespeicherte Voreinstellung, neue Partie gegenüber Zug/Rücknahme sowie Identität und korrekte Belegung über die 18 Referenzpartien mit 1.000 Aktionen. Dabei werden Verschieben, Springen, Abnehmen und Rekonstruktion der jeweils vorherigen Identitäten geprüft. Vier vorhandene Python-Prüfungen bestehen; die Projektänderung ergänzt ausschließlich den neuen Quellverweis und behält vorhandene Einstellungen.

Zwei Simulator-Abläufe prüfen Mühle/Abnahme/Rücknahme und denselben Lasker-Zug mit aktivierter/deaktivierter Animation. Vier erste iPhone-Prüfungen bestehen: Computerantwort/Rücknahme, größte Schrift im Querformat, gespeicherte Optionen über Neustart und feste Brettkoordinaten bei beiden Animationszuständen (`.build/Stone-Motion-Hardware.xcresult`). Nach einer Sichtkorrektur der Ebenenreihenfolge bestehen die drei abschließenden iPhone-Prüfungen für feste Zugtasten, Abnahme/Rücknahme sowie Elementerkennung/Berührungsflächen/Beschriftungen/Traits (`.build/Stone-Motion-Final-Hardware.xcresult`). Der entsprechende Simulator-Nachlauf besteht ebenfalls (`.build/Stone-Motion-Final-UI.xcresult`).

Eine Simulatoraufnahme wurde bildweise geprüft (`.build/stone-motion-final.mp4`): der helle Stein durchläuft zwischen etwa 18,72 und 19,00 Sekunden mehrere Zwischenpositionen; nach Ausschalten wechselt er zwischen zwei aufeinanderfolgenden Auswertebildern direkt vom Ausgang zum Ziel. Das ist ein Funktions-/Sichtnachweis, keine Messung der garantierten Bildrate. Fünf Ausschnitte stehen unter `Previews/Stone-Motion-Sequence.png`, der Schalter auf dem Gerät unter `Previews/Stone-Animation-Option-iPhone-DE.png`. Das iPhone war beim ersten Startversuch gesperrt; nach dem Entsperren liefen die Tests erfolgreich. Die aktuelle App wurde anschließend normal gestartet.

Vollständige VoiceOver- und Akkutests bleiben wie gewünscht zurückgestellt. Die Reduce-Motion-Systemoption wurde über die native SwiftUI-Umgebung angebunden, nicht als neue vollständige assistive Geräteabnahme ausgegeben. Referenz: [Apple SwiftUI-Animationen](https://developer.apple.com/documentation/swiftui/animations), [Reduce Motion](https://developer.apple.com/documentation/swiftui/environmentvalues/accessibilityreducemotion).

## Neustart nach Spielende und unmittelbare Auswahlrückmeldung — 01.10.2026

Die Rückfrage beim Starten einer neuen Partie richtet sich jetzt an beiden Einstiegen nach dem tatsächlichen Spielstatus. Nach Sieg, Niederlage oder Remis entfällt sie; eine noch laufende Partie bleibt geschützt. Der deutsche und englische Dialog benennt ausdrücklich die laufende Partie. Eine Rücknahme des letzten, spielbeendenden Zuges macht die Partie wieder schutzbedürftig.

Der Auswahlring liegt außerhalb der animierten Steinebene. Beim Zug verschwindet er unmittelbar, ohne Ausblenden oder Mitgleiten; die Steinbewegung behält ihre 320 ms. Die aktivierbaren Markierungen des letzten Zuges bleiben davon unabhängig.

**Nachweise:** Zwei fokussierte Modelltests bestehen (`.build/Restart-Markers-Models-02.xcresult`), darunter alle 18 Referenzpartien mit laufenden, wiederhergestellten und beendeten Ständen sowie Rücknahme. Die Bedienungsprüfungen decken den direkten Neustart nach einer tatsächlich ausgespielten Partie von Brett und Startseite, Abbrechen/Bestätigen beim Ersetzen einer laufenden Partie sowie Bewegung mit aktivierter/deaktivierter Animation ab. Der erste Abbruch-Test adressierte eine im nativen iOS-27-Popover nicht sichtbare Abbrechen-Taste; er verwendet nun die native Abbruchgeste außerhalb des Popovers. Die Simulatoraufnahme `.build/restart-markers.mp4` wurde in Einzelbildern geprüft: Beim Beginn des Gleitens ist der Auswahlring bereits entfernt, ohne Nachbild an Ausgangspunkt oder bewegtem Stein.

Der signierte Gerätebuild wurde auf FA-iPhone installiert. Ein erneuter automatischer Start scheiterte am inzwischen gesperrten Gerät; für diese Änderung wird keine zusätzliche physische Bedienungsprüfung behauptet. VoiceOver- und Akkutests bleiben zurückgestellt.

Alle drei Bedienungsprüfungen bestehen im abschließenden Lauf `.build/Restart-Markers-Verified.xcresult`.

## Original-KI-Optionen und optionaler Spielstil — 01.10.2026

Der öffentliche Sanmill-HEAD wurde gegen den importierten Stand abgeglichen und ist identisch. `AI_OPTIONS.md` bewertet die Original-Einstellungen einzeln, einschließlich irreführender deutscher Bezeichnungen, Datenbankabhängigkeiten, Fallenanzeige gegenüber Fehlerkorrektur und Sprachmodell-Analyse. Die fünf Suchbudgets und die Voreinstellung bleiben erhalten. Der eigene Adapter übergibt optional Sanmills originalen Blockierparameter; alle 85 importierten Dateien sind unverändert.

**Engine und Speicherung:** Alle 19 Brückentests bestehen (`.build/Styles-Rust.log`), darunter beide Stile mit beiden Suchverfahren, beiden Rechenzeitmodi und allen vier Varianten; die 1.000 Referenzaktionen behalten beim Stilwechsel denselben exportierten Spielzustand. Ein fehlender Stil behält die bisherige Zugwahl. Fünf Tests des Vergleichsläufers und vier Python-Prüfungen bestehen. Drei fokussierte Swift-Tests bestehen (`.build/Styles-Models.xcresult`): Stil speichern/laden, unveränderte Regeln, bisherige fünf Stufen und Wechsel während einer laufenden Suche mit genau einer gültigen Computerantwort.

**Vergleichspartien:** 64 reguläre Partien auf Stufe 2 und separat 512 auf Stufe 3; keine Fehler oder künstlichen Abbrüche. Auf Stufe 3 erreicht Blockierend 30,9–44,5 % der Punkte je Variante. Die konservativen simultanen Intervalle schließen 50 % ein; keine allgemeine Rangfolge oder Elo wird behauptet. Pläne, Rohdaten, Quellstände und Grenzen sind unter `Benchmarks/SPIELSTILE-2026-10-01.md` und dem zugehörigen Archiv festgehalten. Es gibt keine neue Energie- oder Geräteleistungsmessung.

**Bedienung:** Auswahl beider Stile, Erklärungen mit Vor-/Nachteilen, Verwerfen, Übernehmen und Fortbestehen nach App-Neustart bestehen auf iPhone 17e; der identische Einstellungs-/Erklärungsablauf besteht auf iPad mini (`.build/Styles-UI-iPad.xcresult`). Bei größter Schrift im Querformat bestand der iPhone-SE-Test sofort (`.build/Styles-UI-Compact.xcresult`). Auf iPhone 17e fand der erste Lauf eine Überlappung der Rechenzeittasten mit der Starttaste um weniger als einen Punkt, statt des geforderten Mindestabstands von zwei Punkten. Weniger Zwischenraum oberhalb der kompakten Inhalte behebt dies ohne kleinere Tasten oder Schrift. Der Nachlauf besteht (`.build/Styles-Layout-Final.xcresult`). Der erste iPhone-Lauf bleibt wegen dieses korrigierten Layoutfehlers als fehlgeschlagenes Protokoll `.build/Styles-UI-iPhone.log` erhalten; sein hängender Xcode-Ergebnisexport wurde beendet.

Die erweiterten iPad- und kompakten SE-Ansichten wurden visuell geprüft. Der signierte Gerätebuild ist auf FA-iPhone installiert; der anschließende normale Start wurde vom gesperrten Gerät abgelehnt. Die vollständigen VoiceOver- und Akkutests bleiben wie vereinbart zurückgestellt; die neuen Bedienungsprüfungen erfolgten im Simulator.

## Klassisches Eröffnungsbuch und Perfect-DB-Entscheidung — 01.10.2026

Das klassisch verfasste Sanmill-Orakel ist reproduzierbar aus einer zusätzlichen unveränderten, ausdrücklich lizenzierten Quelldatei extrahiert. Alle 86 importierten Dateien stimmen mit ihren SHA-256 überein; die erzeugte Tabelle stimmt exakt mit dem Oracle-Teil des originalen NMM-Assets überein. `generate-opening-book.py --check` ist Teil von Build und Engine-Testskript. Die native Zusatzdatei umfasst 14.925 Byte. Die konkrete Prüfung von Eröffnungs-/Datenbankquellen und der bewusste Verzicht auf eine vollständige oder partielle Perfect DB stehen in `OPENING_AND_DATABASE.md`.

**Regeln und Engine:** 22 Brückentests bestehen (`.build/Book-Rust.log`), einschließlich Legalität aller 437 Buchkandidaten in allen 16 Symmetrien, Filter nach Variante/Stufe/Phase, Buch-Aus, fehlendem Treffer, Abnahme-Stellungen, Stornierung und identischem Spielzustand unabhängig von der Zugquelle. Die ursprünglichen Such- und Verlaufsprüfungen bestehen ebenfalls. Die erste Kompilierung des neuen Abbruchtests benötigte eine Namespace-Korrektur; der angegebene vollständige Nachlauf besteht.

**Quellenwechsel und Aufwand:** Der Host-Probelauf liefert für leeres Brett und alle 24 ersten Steine jeweils mit/ohne Buch 50 legale Antworten. 9 der 25 Stellungen treffen das Buch und suchen keine Knoten. Eine vollständige Selbstpartie beendet sich regulär nach 65 Einzelaktionen mit 12 Buchtreffern. Die Rohdaten sind unter `Benchmarks/2026-10-01-eroeffnungsbuch/probe.json` samt SHA-256 gespeichert. Die beobachteten Mac-Zeiten sind keine Geräte-/Akkuprüfung oder Stärkekalibrierung. Der lokale Release-Lauf meldete eine bekannte fehlende LLVM-Bibliothek beim optionalen Debug-Stripping, erstellte und führte das Programm aber erfolgreich aus; die dokumentierte Wiederholung deaktiviert dieses Stripping ausdrücklich.

**App und Layout:** Zwei fokussierte Swift-Tests bestehen (`.build/Book-Models.xcresult`): Buch-/Suchauswahl und Speicherung sowie Änderung während einer laufenden Computersuche einschließlich persistiertem Buch-Aus. Zwei iPhone-Bedienungsprüfungen bestehen (`.build/Book-UI-iPhone.xcresult`): beide Optionen, deutschsprachige Erklärung mit Grenzen, Übernehmen, Verwerfen und Fortbestehen nach App-Neustart. Der gleiche Einstellungs-/Erklärungsablauf besteht auf iPad mini (`.build/Book-UI-iPad.xcresult`). Größte Schrift im Querformat auf iPhone SE bleibt ohne Scrollen und ohne Überlappung mit der Starttaste (`.build/Book-UI-Compact.xcresult`). iPad-Gesamtansicht und kompakte Eröffnungsansicht wurden zusätzlich an den exportierten Screenshots visuell geprüft.

Der signierte Gerätebuild besteht (`.build/Book-Device.log`). Die aktualisierte App wurde auf FA-iPhone installiert und erfolgreich normal gestartet. Das ist kein zusätzlicher physischer Bedienungs-/Energietest. Vollständige VoiceOver- und Akkutests bleiben wie vereinbart zurückgestellt.

## Ruhige Spielansicht, Verlaufsraster und erklärte Tipps — 01.10.2026

Die Spielüberschrift ist zentriert; die bisherige Info-Taste und Stufenplakette entfallen. Variante, Zustand, Steinbestände und Computer-Konfiguration stehen im Verlauf unter „Spieldetails“. Der Verlauf verwendet bei normaler Schrift zwei Spalten auf dem iPhone und drei auf dem iPad, mit expliziten Seitenwechseln bei längeren Partien. Die möglichen Züge öffnen als kompaktes Auswahlraster. Große Schrift reduziert die Spaltenzahl; es entsteht kein Scrollbereich. Die Zählung heißt „Züge“ bzw. „1 Zug“ und entspricht wie bisher den protokollierten Einträgen einschließlich einzelner Abnahmen.

Schnelle Tipps zeigen keine Ladeanzeige. Ein abbrechbarer Timer blendet diese erst nach zwei Sekunden tatsächlicher Berechnung ein und endet vor einer etwaigen künstlichen Zugpause. Das Info-Symbol neben dem fertigen Vorschlag erklärt überprüfbare unmittelbare Folgen und die Quelle Buch/Suche. Die eigene Rust-Brücke wendet dafür den Kandidaten ausschließlich auf dem lokalen Anfragezustand über Sanmills Regeln an; exportierte Stellung und gespeicherte Partie bleiben unverändert. Erkannte Mühlen, Abnahmen, blockierte Linien und neue offene Zweierlinien berücksichtigen die aktive Variante. Es wird keine vollständige Suchbegründung oder garantierte Spielstärke behauptet.

**Engine und Modell:** Alle 24 Brückentests bestehen (`.build/CalmGame-Rust.log`), darunter die neuen Erklärungsfälle für klassische und diagonale Mühlen, mehrere erlaubte Abnahmen, Linienblockade und offene Zweierlinien. Vier fokussierte Swift-Prüfungen bestehen (`.build/CalmGame-Models.xcresult`): Timerabbruch ohne späteres Aufblitzen, Tipp ohne Änderung des Spielstands, lückenlose Reihenfolge über verschiedene Rastergrößen/Schriftgrößen und gespeicherte Spielhilfen. Zwei bestehende Prüfungen für verworfene Hinweise und Mindestzeit der Computerantwort bestehen ebenfalls (`.build/CalmGame-Initial.xcresult`).

**Bedienung und Sichtprüfung:** Die neuen iPhone-Abläufe prüfen stabile Brettkoordinaten beim Tipp, Erklärung, zweispaltigen Verlauf, Spieldetails einschließlich Stufe und direktes Ausführen eines Rasterzuges (`.build/CalmGame-UI-iPhone.xcresult`). Beide neuen Abläufe bestehen auch auf iPad mini einschließlich dreier Verlaufsspalten (`.build/CalmGame-UI-iPad.xcresult`). Auf iPhone SE bestehen die Prüfung von Start/Brett bei größter Schrift und der neue Querformat-Ablauf für Hinweise und Seitenwechsel (`.build/CalmGame-UI-Compact.xcresult`). Der abschließende SE-Lauf nach Text- und Ausrichtungskorrekturen besteht mit zwei Tests (`.build/CalmGame-Compact-Final.xcresult`), einschließlich vollständiger Sichtbarkeit der Seitenanzeige nach dem Wechsel. Die exportierten iPhone-/iPad-Raster, Erklärungsblätter und kompakten Ansichten wurden visuell geprüft. Die Aufnahmen erfassen Entwicklungsansichten, keine fertigen Store-Grafiken. Drei abschließende iPhone-Regressionstests bestehen für Computerantwort/Rücknahme, Mühle/Abnahme/Verlauf und das Speichern der drei verbliebenen Spielhilfen über einen App-Neustart (`.build/CalmGame-Final-Regression.xcresult`).

Der signierte Gerätebuild besteht (`.build/CalmGame-Device.log`). Die App wurde auf Fa-iPhone installiert und erfolgreich normal gestartet. Dies ist kein zusätzlicher physischer Bedienungs- oder Energietest. Die unveränderten Upstream-Dateien wurden nicht bearbeitet; vollständige VoiceOver- und Akkutests bleiben zurückgestellt.

## Ausblendbare Tipps und kürzere Erklärung — 01.10.2026

„Tipp“ schaltet den Zugvorschlag jetzt ein und aus. Der zweite Tastendruck entfernt Vorschlag, Info-Symbol, Tippmarkierung und die automatisch gesetzte Steinauswahl. Er bricht auch eine noch laufende Tippberechnung ab und verwirft deren Ergebnis; die Stellung und der Verlauf ändern sich dabei nicht. Der Erklärungstext endet nach dem Satz zur Vorausberechnung mit der gewählten Spielstufe. Der nachfolgende ausführliche Hinweis entfällt auf Deutsch und Englisch.

Zwei Modelltests und ein Bedienungstest bestehen (`.build/Hint-Toggle.xcresult`): erneutes Anzeigen nach dem Ausblenden, unveränderte Stellung, Entfernen der Auswahl in einer echten Zugstellung, kein spätes Wiederauftauchen nach Abbruch sowie stabile Brettkoordinaten und gekürzter Text in der Oberfläche. Der signierte Gerätebuild besteht (`.build/Hint-Toggle-Device.log`); die App ist auf Fa-iPhone installiert und erfolgreich gestartet. Es wurde keine zusätzliche physische Bedienungs-, VoiceOver- oder Akkuprüfung durchgeführt.

## Impressum, Buildinformationen und Lizenzpaket — 01.10.2026

„Über Mühlenstein“ enthält Anbieter/Anschrift/USt-ID aus den beiden vom Nutzer benannten Apps, direkte E-Mail-/Website-Links, eine zum Offline-Verhalten passende Datenschutzbeschreibung, Herkunft/Quellcode und vollständige offline lesbare Lizenzhinweise. Version 0.1.0 und Build 2 stammen aus Xcode-Einstellungen; Info.plist und Anzeige enthalten keine fest codierte Kopie der Nummern. Die gewöhnliche Steuernummer wurde nicht zusätzlich übernommen. Der vollständige Prüfbericht mit der verbleibenden Dritt-Rechtefrage vor einem App-Store-Binary steht in `LICENSE_REVIEW.md`.

**Lizenzumfang:** 86 unveränderte Vendor-Dateien mit übereinstimmenden Hashes; 21 Einträge im erreichbaren Cargo-Graph einschließlich eigener Brücke und drei Sanmill-Paketen, davon 17 Registry-Pakete. Build-/Prozedurmakros sind separat gekennzeichnet. Alle Original-Lizenz-/Copyright-/Notice-Dateien dieser Registry-Pakete und die vollständigen offiziellen Rust-Standardbibliotheks-Hinweise werden mitgeliefert. Die native Leseansicht teilt letztere in 157 begrenzte Abschnitte, ohne die Inhalte zu kürzen. Die unbearbeitete Rust-HTML-Datei bleibt ebenfalls im App-Paket. Der Generator-Check läuft erfolgreich und ist in den Xcode-Build integriert. Root-, Upstream- und App-AGPL stimmen bytegenau überein.

**Prüfungen:** Ein Modell-/Pakettest sowie zwei iPhone-Bedienungstests bestehen (`.build/About-Licenses.xcresult`): reale Bundlewerte, vorhandene Lizenzressourcen, Impressumsangaben, Quell-/Kontaktlinks, kein Scrollbereich und die vollständige AGPL mit größter Schrift im Querformat. Vier vorhandene Python-Prüfungen bestehen. Der iPad-Nachlauf besteht (`.build/About-Licenses-iPad-Final.xcresult`); im ersten Lauf hatte der Test die hinter dem Blatt liegende Navigation angesprochen und damit das Blatt geschlossen. Der Test adressiert nun explizit die aktive Impressums-/Herkunftsnavigation. Die iPhone-/iPad-Aufnahmen wurden visuell geprüft. Der signierte Gerätebuild besteht (`.build/About-Licenses-Device.log`). Keine neue Engine-, VoiceOver- oder Akkuprüfung war Teil dieser Änderung.

**Veröffentlichungsvorbereitung:** Eine gezielte Musterprüfung sämtlicher 438 bisheriger Git-Historienblobs auf typische Zugangsschlüssel, private Schlüssel und Zugangsdaten-Dateien ergab keine Treffer. Das ersetzt keine universelle Geheimniserkennung. Build-Caches, Provisionierungsprofile und persönliche Xcode-Zustände sind nicht Teil der versionierten Dateien. Es wurden keine bestehenden Commitverläufe umgeschrieben.

## App-Store-Unterlagen und lokales Release-Archiv — 01.10.2026

Auf Nutzerwunsch bleibt diese Etappe auf die Vorbereitung begrenzt. Store-Texte, Review Notes und öffentliche Support-/Datenschutzseiten sind auf Deutsch und Englisch vorbereitet. Die bestehende Engine bleibt erhalten; die Entscheidung und die unverändert offene historische Rechtekette stehen in `LICENSE_REVIEW.md`. Es wurde kein App-Store-Connect-Datensatz angelegt, kein Binary hochgeladen und kein Vertrag oder Preis geändert.

**App-Paket:** Das signierte Release-Archiv `.build/Archives/Muehlenstein-Store-Preparation.xcarchive` wurde erfolgreich erstellt und besteht `codesign --verify --deep --strict`. Es enthält Version 0.1.0 (2), die unveränderte Bundle-ID `org.amosystems.Muehlenstein`, die vollständigen Lizenzressourcen und das neue Privacy-Manifest im Wurzelverzeichnis des App-Pakets. Die Signatur verwendet das vorhandene Entwicklungsprofil; Distributionssignierung und Apples Validierung stehen noch aus. `Store/README.md` dokumentiert Prüfsumme, Manifestgründe und die Grenzen der Quell-/Symbolprüfung. Die Projektaktualisierung verändert keine Buildkonfiguration und ist bei erneutem Aufruf wirkungslos.

**Aufnahmen:** Der Release-Screenshotablauf besteht auf iPhone 18 Pro Max und iPad Pro 13 Zoll (M5) mit jeweils deutscher und englischer Oberfläche (`.build/Store-Screenshots-Final.xcresult`). 16 unveränderte XCTest-PNGs zeigen Spiel, Tipp, Neue Partie und Startseite. Der Export prüft Format, Größe, Anzahl und eindeutige Zuordnung und hinterlegt SHA-256-Werte. Repräsentative iPhone-/iPad-Aufnahmen wurden visuell geprüft; der deutsche iPad-Systembereich bleibt auch bei englischer App-Sprache sichtbar. Im ersten Lauf fehlte die Testbarkeit des Release-Testhosts; der Nachlauf aktiviert sie ausschließlich für die Tests, nicht für das Gerätearchiv.

**Weitere Prüfungen:** Vier vorhandene Python-Tests, die vollständige Vendor-/Lizenzprüfung, die Eröffnungsbuchprüfung und die Plist-Prüfung bestehen. Store-Texte halten die geprüften Feldlängen ein. Spielregeln, Suche und App-Oberfläche wurden nicht verändert; deren vollständige Tests wurden nicht erneut ausgeführt. Keine neue physische Geräte-, VoiceOver- oder Akkuprüfung war Teil dieser Etappe.

## Version 1.0, Build 3 und Quelltag v1.0 — 01.10.2026

Die App-Version ist in `Configuration/App.xcconfig` von 0.1.0 auf 1.0 angehoben, die Buildnummer von 2 auf 3. Der bestehende Versionsanzeige-Test erwartet den neuen Stand. Interne Cargo-Paketversionen, Abhängigkeiten, Regeln, Suchverfahren und Spielansichten bleiben unverändert. Versionshinweise, Projektplanung, Store-Metadaten und Einreichungsunterlagen beziehen sich jetzt auf `v1.0`. Die früheren Prüfprotokolle bleiben als historische Nachweise erhalten.

**Archiv:** `.build/Archives/Muehlenstein-1.0-3.xcarchive` wurde im Release-Modus erfolgreich erstellt. Bundle-Version 1.0, Build 3, Bundle-ID, Exportdeklaration, vollständige Lizenzressourcen und bytegleiches Privacy-Manifest wurden im fertigen App-Paket geprüft. `codesign --verify --deep --strict` besteht mit Zugriff auf den macOS-Schlüsselbund; die Sandbox-Prüfung konnte zuvor die Zertifikatskette nicht bestätigen. Das vorhandene Entwicklungsprofil bleibt aktiv, Distributionssignierung und Apple-Validierung sind weiterhin offen. SHA-256 des Executables: `0f45980e5b36dc79846493fb67efdb69457f0bed0f5396f704bf7a2e01b60bd0`.

**Tests:** Zwei fokussierte vorhandene Tests bestehen im Release-Modus auf dem Mühlenstein-iPhone-Simulator: Bundlewerte/Lizenzpaket und „Über Mühlenstein“ einschließlich angezeigter Version 1.0/Build 3, Impressum und Offline-Lizenzhinweisen (`.build/Version-1.0-Checks.xcresult`). `ENABLE_TESTABILITY=YES` gilt nur für diesen Testlauf, nicht für das Gerätearchiv. Vier vorhandene Python-Prüfungen, Vendor-/Lizenz- und Eröffnungsbuchprüfung bestehen; der Projektgenerator lässt das bestehende Xcode-Projekt unverändert.

Die 16 Store-Screenshots bleiben unverändert verwendbar, da sie keine Versionsanzeige enthalten und sich die abgebildeten Ansichten nicht geändert haben. Keine erneute vollständige Spiel-, VoiceOver- oder Akkuprüfung und kein Upload zu Apple waren Teil der Versionsanhebung.

## Einstellungswege und ruhige Voreinstellungen — 01.10.2026

Auf der Startseite ersetzt ein Regelbuch das Zahnrad; der bisherige zweite Regeln-Einstieg unter den Partietasten entfällt. Gegner, Variante und Spielstärke bleiben in „Neue Partie“. Das Mehr-Menü der Partie gruppiert Neue Partie/Spielstärke und Darstellung/Zugauswahl/Regeln. „Spielstärke“ ersetzt „Computer einstellen“ auch als Blatttitel und erscheint nur bei Computerpartien. „Darstellung“ ersetzt „Spielhilfen“ und ist ausschließlich aus der Partie erreichbar.

Zugziele und letzter Zug sind ohne gespeicherte Präferenz aus. Der Schalter „Steinanimationen deaktivieren“ ist umgekehrt an die unveränderte positive Speicherpräferenz gebunden: Er ist ebenfalls anfangs aus, sodass die sanften Bewegungen aktiv bleiben. Explizit gespeicherte Entscheidungen bleiben erhalten. Die deutsch- und englischsprachigen Erklärungen erläutern die Bedeutung; iOS „Bewegung reduzieren“, ausdrücklich angeforderte Tipps und die separate Zugauswahl behalten ihr Verhalten.

**Nachweise:** Der vorhandene Modelltest für Voreinstellungen und Speicherung sowie die iPhone-Prüfungen für Startseite/Neue Partie und paginierte Regeln bestehen im ersten Lauf (`.build/Settings-Organization-iPhone.log`). Drei Bedienungstests fanden zunächst die neuen Menüeinträge nicht über technische Kennungen; das native iOS-Menü veröffentlicht diese Einträge unter ihren Beschriftungen. Die Tests verwenden jetzt diese Beschriftungen. Nach Testende hing der erste Xcode-Ergebnisexport und wurde beendet; sein Protokoll bleibt erhalten.

Alle vier betroffenen Nachprüfungen bestehen (`.build/Settings-Organization-iPhone-Final.xcresult`): ausgeschaltete Darstellungsschalter, Aktivieren/Deaktivieren und Speicherung über Neustart, sichtbare Computerantwort mit optionaler letzter-Zug-Markierung/Rücknahme, Spielstärke samt verworfenen erweiterten Änderungen sowie feste Brettziele mit aktivierter/deaktivierter Animation. Auf dem iPad bestehen die Einstellungs-/Speicherprüfung und Startseite/Neue Partie (`.build/Settings-Organization-iPad.xcresult`). Auf dem kompakten iPhone bestehen beide Prüfungen für größte Schrift im Querformat, einschließlich lesbarer Animationsbeschriftung, Seitenwechseln und erreichbaren Bedienelementen ohne Scrollbereich (`.build/Settings-Organization-Compact.xcresult`). Repräsentative Start-, Menü- und Darstellungsaufnahmen aller drei Größen wurden visuell geprüft. Vier vorhandene Python-Prüfungen bestehen.

Regeln und KI sind unverändert; eine neue vollständige Engine-, physische Geräte-, VoiceOver- oder Akkuprüfung war nicht Teil dieser Änderung. Der Tag `v1.0` und sein Archiv bleiben unverändert; das Changelog und die Store-Unterlagen kennzeichnen die spätere Änderung auf `main` und die vor dem nächsten Release zu erneuernden Aufnahmen.

## Harmonische Brettanordnung und Berlin-Hinweis — 01.10.2026

Das Impressum ergänzt „Entwickelt mit ♥ in Berlin“ bzw. „Developed with ♥ in Berlin“.
Auf der Startseite werden Logo/Titel, Vorschaubrett und Partietasten als zusammengehörige
Gruppe mittig angeordnet. Die verfügbare Höhe und die tatsächliche Texthöhe bestimmen
die Brettgröße. Bei Platzmangel entfällt ausschließlich die dekorative Vorschau;
die Partietasten dürfen vollständig umbrechen. In der Partie teilen Vorratszeile,
Brett und Bedienleiste im Hochformat dieselbe Breite. Das Brett sitzt mittig zwischen
Vorratszeile und Bedienleiste. Im Querformat stehen Status und Bedienelemente als
mittige Gruppe neben dem Brett.

**Prüfungen:** Release-Simulatorbuild erfolgreich. Auf dem Mühlenstein-iPhone bestehen
Impressum/Lizenznavigation, deutscher und englischer Start, Partiekonfiguration und
feste Brettziele in beiden Ausrichtungen (`.build/Harmonious-Layout-iPhone-Run.xcresult`).
Auf dem iPad bestehen Querformat, Start/Neue Partie, Tipp, Verlauf und Zugauswahl
(`.build/Harmonious-Layout-iPad.xcresult`). Die erste zusätzliche Zentrierungsprüfung
verwendete nur den Rahmen des weißen Spielers und meldete deshalb zwei Punkte
Abweichung, wenn die aktive Markierung beim schwarzen Spieler lag. Der Test misst
jetzt beide Spielerrahmen; der gezielte Nachlauf besteht mit unveränderter Brettanordnung
(`.build/Harmonious-Layout-iPad-Center.xcresult`).

Auf dem kompakten iPhone bestehen feste Brettziele, Start/Neue Partie und größte Schrift
in beiden Ausrichtungen (`.build/Harmonious-Layout-Compact.xcresult`). Die anschließende
Sichtprüfung fand eine zu kleine dekorative Vorschau und eine gekürzte Fortsetzen-
Beschriftung bei größter Schrift. Beides wurde korrigiert. Alle drei betroffenen
kompakten Prüfungen bestehen erneut (`.build/Harmonious-Layout-Compact-Final.xcresult`);
die Knopftexte sind auf den finalen Aufnahmen vollständig, ohne Scrollen. Die normale
Startansicht wurde danach auch auf iPhone (DE/EN) und iPad erneut erfolgreich geprüft
(`.build/Harmonious-Layout-iPhone-Home-Final.xcresult`,
`.build/Harmonious-Layout-iPad-Home-Final.xcresult`).

Die exportierten Originalaufnahmen von Start, Partie, Querformat, größter Schrift,
Impressum DE/EN, Konfiguration, Verlauf und Zugauswahl wurden visuell beurteilt.
Beide Lokalisierungsdateien bestehen `plutil -lint`; `git diff --check` besteht.
Der erste eingeschränkte Testaufruf konnte CoreSimulator nicht erreichen; der Lauf
mit Simulatorzugriff ersetzte ihn. Keine neue physische Geräte-, VoiceOver- oder
Akkuprüfung. Tag `v1.0`, sein Gerätearchiv und die Store-Screenshots bleiben historische
Stände; vor dem nächsten Upload sind Archiv und Store-Aufnahmen zu erneuern.

## Startmarke und scrollbare Informationsseiten — 01.10.2026

Logo und Name stehen auf der Startseite höher im freien Bereich zwischen
Werkzeugleiste und Brett. Die dezente Unterzeile lautet „Mühle. Zug für Zug.“
bzw. „Morris. Move by move.“; bei sehr großer Schrift entfällt sie zugunsten
der Bedienelemente. Die Spielansicht bleibt unverändert und ohne Scrollbereich.

Die Übersicht „Über Mühlenstein“ und ihre Informationsrubriken verwenden nun
Scrollbereiche statt Seitensteuerungen. Anbieter, Kontakt, Umsatzsteuer-ID und
Berlin-Hinweis bilden getrennte Abschnitte. Datenschutz und Herkunft erhalten
Zwischenüberschriften; technische Angaben sind aufklappbar. Fließtext nutzt
Silbentrennung und auf breiten Zeilen Blocksatz. Die erste Sichtprüfung zeigte
auf dem iPhone zu große Wortabstände; dort und bei großer Schrift bleibt Text
nun linksbündig. Die Lizenzdateien und Autorenangaben bleiben inhaltlich
unverändert und sind vollständig scrollbar zugänglich. Regeln, Spielhilfen
und Zugverlauf behalten ihre bisherige Bedienung.

**Prüfungen:** Release-Simulatorbuild erfolgreich. Im ersten iPhone-Lauf bestehen
Start/Neue Partie, deutsche Startseite mit gespeicherter Partie, englische
Startseite und englisches Impressum sowie feste Brettziele. Der Modelltest für
Versionsdaten und vollständige eingebundene Lizenzhinweise besteht ebenfalls
(`.build/Info-Reading-iPhone.xcresult`). Die angepassten Infoseiten-Tests suchten
zunächst nach Buttons statt nativen Links und erwarteten für TextKit-Absätze
nur einen statt zwei Accessibility-Knoten; diese Testannahmen wurden korrigiert.
Die vollständige Navigation durch Übersicht, Impressum, Datenschutz, Herkunft
und Lizenzhinweise besteht anschließend (`.build/Info-Reading-iPhone-Final.xcresult`).
Die zugehörigen Originalaufnahmen wurden visuell geprüft.

Der erste iPad-Lauf bestätigt weiterhin feste Brettziele und die Start-/Spiel-
und Konfigurationsansichten in beiden Ausrichtungen; er enthielt dieselben
korrigierten Testannahmen. Nach Testende hing die Diagnoseerfassung und wurde
beendet; das Testprotokoll bleibt unter `.build/Info-Reading-iPad.log` erhalten.
Die vollständige Informationsnavigation besteht im korrigierten iPad-Nachlauf
(`.build/Info-Reading-iPad-Final.xcresult`); Übersicht und breite Lesespalte wurden
anhand der exportierten Aufnahmen kontrolliert. Der kompakte Simulator startete
in zwei Anläufen keine Tests zuverlässig; diese Läufe wurden beendet. Sie zählen
nicht als erfolgreiche Geräteprüfung.

Die größte Schrift besteht auf dem iPhone im abschließenden Projektlauf
(`.build/Info-Reading-Large-Text-Project.xcresult`): feste Spielziele, erreichbare
Start- und Konfigurationsaktionen sowie vollständiger, scrollbar zugänglicher
AGPL-Text im Querformat. Der vorausgehende Start über die gespeicherte
Testkonfiguration blieb ohne Testbeginn und wurde beendet.

Beide Lokalisierungen bestehen `plutil -lint`; `git diff --check` besteht.
Keine erneute Prüfung auf physischer Hardware oder vollständige VoiceOver-Abnahme.
Tag `v1.0`, Archiv und Store-Aufnahmen bleiben historische Stände und müssen vor
dem nächsten Upload erneuert werden.

## Unterzeile entfernt und Lizenztextfluss — 01.10.2026

Die Unterzeile der Startansicht entfällt in beiden Sprachen. Ein skalierter
Abstand hält die bestätigte Position von Logo, Name und Brett stabil. Die
Akzentfarbe bleibt bis zur Auswahl aus den separat gezeigten Farbstudien unverändert.

Die Darstellung sämtlicher Lizenztexte löst feste Quelldatei-Zeilen auf und
entfernt übermäßige Leerzeilen. Absätze, Aufzählungen, Abschnittsüberschriften
und wörtliche Beispiele bleiben getrennt. Sanmills Markdown-Überschriften,
Hervorhebungen und Verweise erscheinen formatiert; Linkziele bleiben sichtbar.
Die Originaldateien und das generierte Lizenzinventar wurden nicht verändert.

**Prüfungen:** Release-Simulatorbuild erfolgreich. Zwei Modelltests prüfen die
Struktur beim Zusammenführen und den Erhalt aller Nicht-Leerraum-Zeichen in
allen 177 Dokumenten einschließlich AGPL und verschachtelter Rust-Hinweise.
Vier iPhone-Bedienungstests bestehen: Informationsnavigation mit Sanmill-
Formatierung, feste Brettziele/Startansicht, größte Schrift im Querformat sowie
AGPL-, Apache- und Rust-Lizenznavigation (`.build/License-Reflow.xcresult`).
Die Originalaufnahmen von Startseite und Lizenztexten wurden visuell geprüft.
Die neue Lizenznavigation verwendet anschließend präzise Navigationstitel,
um im Hintergrund liegende Werkzeugleisten nicht als Zurück-Taste anzusprechen.
Der entsprechende iPad-Nachlauf besteht ebenfalls
(`.build/License-Reflow-iPad.xcresult`).

Die vier Farbstudien verwenden unveränderte Sand-, Brett- und Steinfarben mit
Waldgrün, Schieferblau, Aubergine oder Terrakotta als Akzent. Rechnerischer
Kontrast für weiße Knopfschrift in den hellen Entwürfen: mindestens 5,47:1;
Akzent auf Sand: mindestens 4,93:1. Das ist noch keine Abnahme einer ausgewählten
App-Farbpalette. Die Vorschau schaltet lokal zwischen den vier Varianten um.

Beide Lokalisierungen und `git diff --check` sind geprüft. Keine neue physische
Geräte-, VoiceOver- oder Akkuprüfung. Der Tag `v1.0` und das bisherige Archiv
bleiben unverändert; diese Änderungen liegen im späteren Quellstand auf `main`.

## Wählbare Akzentfarben — 01.10.2026

Waldgrün ist der Standard bei fehlender oder unbekannter gespeicherter Farbauswahl.
Unter Partie → Mehr → Darstellung stehen zusätzlich Schieferblau, Aubergine,
Terrakotta und Petrol bereit. Die Auswahl aktualisiert die Oberfläche ohne
Navigationsneustart und wird unabhängig von der Partie gespeichert. Die vorhandenen
Darstellungsschalter behalten ihre Werte und Ausgangseinstellungen.

**Prüfungen:** Release-Simulatorbuild erfolgreich. Vier gezielte iPhone-Tests
bestehen (`.build/Accent-Palettes.xcresult`): Speicherung sämtlicher Paletten und
Rückfall bei unbekanntem Wert, Auswahl aller Farben mit Wiederherstellung nach
App-Neustart und Wechsel zwischen Hell/Dunkel, unveränderte Schalterwirkung samt
Brettposition sowie Erreichbarkeit aller Farben bei größter Schrift im Querformat.
Die Konfigurationsansichten enthalten weiterhin keinen Scrollbereich. Der zusätzliche
iPad-Test für Farbauswahl, Speicherung und Hell/Dunkel besteht ebenfalls
(`.build/Accent-Palettes-iPad.xcresult`); die Anordnung des Einstellungsblatts
wurde anhand der Originalaufnahme geprüft.

`Scripts/check-contrast.py` prüft jetzt jede Palette anhand der eingebundenen
Farbassets: **170 von 170 Prüfungen bestanden**. Das schwächste Textpaar erreicht
4,57:1, die schwächste bedeutungstragende Brettgrafik 3,46:1. Terrakotta ist im
Hellmodus etwas dunkler als in der Farbstudie, um auch auf getönten Auswahlflächen
4,5:1 einzuhalten. Abnahmemarkierungen folgen der Palette und der Steinfarbe,
damit sie in beiden Systemdarstellungen lesbar bleiben. Dies ist eine Prüfung
der definierten Farbrollen, keine erneute vollständige Accessibility-Abnahme.

Die iPhone-Aufnahmen von Startseite, Farbauswahl in Hell/Dunkel, Spiel mit Tipp
und größter Schrift im Querformat wurden visuell geprüft. Aktuelle Beispiele:
[Startseite](Previews/Forest-Home-iPhone-Light.png),
[Farbauswahl hell](Previews/Accent-Colors-iPhone-Light.png),
[Farbauswahl dunkel](Previews/Accent-Colors-iPhone-Dark.png).
Beide Lokalisierungen bestehen `plutil -lint`; `git diff --check` besteht.
Das App-Icon bleibt ein statisches Asset. Keine neue physische Geräte- oder
Akkuprüfung; Tag `v1.0` und Release-Archiv bleiben unverändert.

## Bestätigung im Startknopf — 01.10.2026

Beim Ersetzen einer laufenden Partie entfällt das native Bestätigungs-Popover.
Der erste Tipp ändert die Beschriftung des vorhandenen Startknopfs zu
„Laufende Partie ersetzen“ / „Replace current game“. Erst der zweite Tipp
ersetzt die Partie. Beide Beschriftungen reservieren dieselbe Fläche;
Spieloptionen und Knopf verschieben sich dabei nicht. Änderungen an der
Konfiguration setzen die Bestätigung zurück. Abbrechen erhält den Spielstand.
Nach einer abgeschlossenen Partie startet die neue Partie weiterhin direkt.

**Prüfungen:** Release-Simulatorbuild und drei gezielte iPhone-Bedienungstests
bestehen (`.build/Inline-Replacement.xcresult`): Wiederherstellung nach App-Neustart,
Abbrechen ohne Spielverlust, Bestätigen von Startseite und Brett, Zurücksetzen
bei geänderten Optionen, direkter Neustart nach tatsächlich ausgespielten Partien
sowie identische Knopfposition bei größter Schrift im Querformat. Die Aufnahmen
in Hoch- und Querformat wurden visuell geprüft.
[Neue Bestätigung](Previews/Replace-Game-Inline-iPhone.png).

Der Ressourcengenerator ist zugleich mit den bereits freigegebenen Informations-
und Farbtexten sowie Paletten abgeglichen. Ein Probelauf in einem temporären
Verzeichnis erzeugt semantisch identische deutsche/englische Lokalisierungen
und alle 18 Farbassets. Dadurch setzt eine spätere Ressourcenerzeugung diese
Anpassungen nicht zurück. Lokalisierungen bestehen `plutil -lint`, der Diff
besteht `git diff --check`. Keine neue physische Geräteprüfung; Versionsnummer,
Tag und Release-Archiv bleiben unverändert.

## Version 1.0.1, Build 4 und Quelltag v1.0.1 — 01.10.2026

Die App-Version steigt von 1.0 auf **1.0.1**, die Buildnummer von 3 auf **4**.
Beide Werte bleiben zentral in `Configuration/App.xcconfig` hinterlegt; der
bestehende UI-Test für die Versionsanzeige wurde entsprechend aktualisiert.
Der neue annotierte Quelltag `v1.0.1` enthält die im Changelog zusammengefassten
Gestaltungs- und Bedienungsänderungen seit `v1.0`. Der alte Tag bleibt unverändert.
README, Release-Unterlagen, Projektplanung und lokale Store-Metadaten führen den
neuen Quellstand. Der zuletzt dokumentierte Apple-Versionsdatensatz bleibt
getrennt als 1.0 ausgewiesen; es wurde keine Apple-Schreiboperation ausgeführt.

**Prüfungen:** Release-Simulatorbuild und beide vorhandenen fokussierten Tests
bestehen (`.build/Version-1.0.1-Checks.xcresult`): Bundlewerte/Lizenzpaket und
„Über Mühlenstein“ mit **Version 1.0.1 · Build 4**, Impressum und Lizenznavigation.
Die erzeugte App-Info.plist enthält 1.0.1, Build 4 und unverändert
`org.amosystems.Muehlenstein`. `ENABLE_TESTABILITY=YES` gilt nur für diesen
Testlauf. Store-JSON und Versions-/Tagwerte sind konsistent; `git diff --check`
besteht. Die lokale Xcode-Projektbereinigung bleibt uncommitted: erreichbare
Projektobjekte und Build-Einstellungen stimmen nach Normalisierung der
Plist-Zahlendarstellung mit der versionierten Projektdatei überein.

Dies ist eine neue Quellmarkierung mit Simulatornachweis. Das Gerätearchiv
zu 1.0 (3) und die ursprünglichen Store-Aufnahmen bleiben historische Artefakte;
für 1.0.1 wurden hier weder ein neues Gerätearchiv noch ein Upload oder eine
Einreichung erzeugt. Die vorher dokumentierten Geräte-, VoiceOver- und
Energieprüfungen wurden nicht wiederholt.

## Noch offen

Weitere physische Geräte, insbesondere iPad und ältere unterstützte iOS-Versionen; vollständige VoiceOver-Abnahme und weitere assistive Eingaben einschließlich der dokumentierten Dynamic-Type-/Beschnitt-Heuristiken; Kontrast auf weiteren Systemversionen und Systemmaterialien; vorerst zurückgestellte Energie-/Speicherprüfung bei längeren Partien und längerer Rechenzeit; genaue Abbruchlatenz auf Hardware; Vergleich weiterer Stufen/Rechenzeitmodi und Kalibrierung mit Menschen; Datenbank- und Feature-Parität; Netzwerkprüfung. Die automatischen Prüfungen ersetzen keine vollständige Barrierefreiheitsabnahme. Es wird noch keine Elo-/Glicko-Wertung angezeigt.


## Schieferblau und Rosé — 02.10.2026

Schieferblau ist bei fehlender oder unbekannter gespeicherter Farbauswahl der
Standard und steht in der Auswahl an erster Stelle. Bestehende gespeicherte
Paletten bleiben erhalten; Waldgrün hat dafür ein eigenes Farbasset. Rosé
übernimmt den Farbcharakter der Wildrose-Palette aus „Besser Lesen“ und verwendet
#964665 im Hellmodus sowie #E095AF im Dunkelmodus. Standard- und Dunkel-Icon
verwenden die Schieferblauwerte #4A6074 und #A8BED1; alle drei Icons sind
1024 × 1024 Pixel, deckendes RGB. Die bestehende Vektorgeometrie ist unverändert.

Release-Build und drei vorhandene Prüfungen bestehen:
Speichern/Wiederherstellen der Darstellung, Farbauswahl einschließlich erstem
Eintrag und Rosé nach Neustart, Erreichbarkeit aller Farben bei größter Schrift
im Querformat. Ergebnis: `.build/Slate-Rose-Verified.xcresult`.
Der erste eingeschränkte Testprozess konnte CoreSimulator nicht erreichen;
der nachfolgende Lauf mit Simulatorzugriff besteht vollständig.

Alle 204 semantischen Kontrastprüfungen für sechs Paletten bestehen;
geringster Textkontrast 4,57:1, geringster Grafikkontrast 3,46:1.
Nachweis: `.build/Slate-Rose-Contrast.json`. Startansicht in Schieferblau sowie
Rosé-Auswahl in Hell und Dunkel visuell geprüft. Screenshots:
`Previews/Slate-Home-iPhone-Light.png`,
`Previews/Slate-Rose-Options-iPhone-Light.png` und
`Previews/Slate-Rose-Options-iPhone-Dark.png`.

Diese Änderungen sind im Quellrelease **1.1 (Build 7)** enthalten.
Es wurde kein neuer Build hochgeladen und kein laufender Review verändert.

## Version 1.1, Build 7 und Quelltag v1.1 — 02.10.2026

Version und Buildnummer sind zentral in `Configuration/App.xcconfig` auf
**1.1** und **7** angehoben. Der bestehende UI-Test erwartet entsprechend
**Version 1.1 · Build 7**. README, Changelog, Design, Projektplanung,
Release-Dokumentation und lokale Store-Metadaten führen den neuen Quellstand;
die bestätigte Einreichung von 1.0.2 (6) bleibt als eigener, datierter Nachweis
erhalten. Der annotierte Tag **v1.1** gehört zu diesem Quellrelease.

**Prüfungen:** Release-Simulatorbuild und beide vorhandenen fokussierten Tests
bestehen ohne Fehler (`.build/Version-1.1-Checks.xcresult`):
Bundlewerte/gebündelte Lizenzen sowie Versionsanzeige, Impressum, Datenschutz,
Quelllinks und Lizenznavigation unter „Über Mühlenstein“. Die erzeugte
App-Info.plist bestätigt `org.amosystems.Muehlenstein`, Version **1.1**, Build
**7**. `ENABLE_TESTABILITY=YES` gilt nur für den Testlauf. Store-Metadaten und
Farbasset-JSON sind gültig; Versions-, Build- und Tagwerte sind konsistent.
`git diff --check` besteht. Die oben dokumentierten drei Farb-/Darstellungstests
und 204 Kontrastprüfungen wurden vor diesem reinen Versionswechsel ausgeführt.

Für 1.1 wurden kein Gerätearchiv, Upload oder Review-Antrag erstellt. Physische
Geräte-, VoiceOver- und Energieprüfungen wurden in dieser Runde nicht wiederholt.

## TestFlight 1.1 (7) — 02.10.2026

Auf Nutzerauftrag wurde der unveränderte Quelltag `v1.1` für TestFlight
archiviert, mit App-Store-Distributionssignatur exportiert und hochgeladen.
Archiv und IPA bestehen die Codesign-Prüfung; Bundlewerte, Exportangabe,
Datenschutzmanifest und Lizenzressourcen sind geprüft. Die vorhandenen zwei
Release-Tests aus `.build/Version-1.1-Checks.xcresult` wurden als bestanden
bestätigt; kein erneuter Testlauf.

Apple bestätigt **`VALID`** für Build
`18bcd44b-2552-4988-8cb2-5244793f0843`. Die Zuordnung zur bestehenden Gruppe
**Externe Tests**, deutsche/englische Testhinweise und aktivierte automatische
Benachrichtigung sind erneut abgefragt. Die Beta-Prüfung wurde um **13:53:58 Uhr
(Europe/Berlin)** eingereicht; bestätigter Zustand:
**`WAITING_FOR_BETA_REVIEW`**. Externe Installation ist erst nach Apples
Freigabe möglich. [Vollständiges Protokoll](../Store/TESTFLIGHT-1.1-7.md).

## Gemerkte Spielstärke und Start auf Stufe 1 — 06.10.2026

Neue Konfigurationen beginnen mit Stufe 1 · Sehr leicht. Eine bestätigte
Computerstufe wird unabhängig vom Spielstand in den lokalen Einstellungen
abgelegt und beim Öffnen von „Neue Partie“ auf Startseite und Spielfeld geladen.
„Partie beginnen“ und „Fertig“ übernehmen die Auswahl; Abbrechen und lokale
Partien überschreiben die gespeicherte Computerstufe nicht. Ungültige gespeicherte
Stufen fallen auf 1 zurück. DE/EN-Hilfetexte und ihre Generatorquelle sind angepasst.

Der Release-Simulatorbuild und fünf gezielte Tests bestehen in
`.build/Remember-Difficulty.xcresult` (Protokoll `.build/Remember-Difficulty.log`):

- Anfangswert 1 sowie Speichern/Wiederherstellen aller fünf Stufen und Rückfall
  bei ungültigen gespeicherten Werten.
- Alle fünf Stufen im Spielstand und in der Engine.
- Änderungen während einer Computersuche erhalten die laufende Partie.
- Bedienung von der ersten Konfiguration bis zur nächsten Partie, Abbrechen
  einer vorgeschlagenen Ersetzung, Ändern/Bestätigen/Abbrechen unter Spielstärke,
  App-Neustart sowie eine lokale Partie zwischen Computerpartien.
- Bestehende Prüfung aller Reglerstufen und verworfener erweiterter Änderungen.

Beide Sprachdateien bestehen `plutil -lint`. Versionsnummer, veröffentlichte
Tags und Apple-Builds wurden in diesem Entwicklungsschritt nicht geändert.

## Fünf zusätzliche native Sprachen — 06.10.2026

Japanisch, Koreanisch, Chinesisch, Französisch und Spanisch ergänzen DE/EN.
Chinesisch besitzt vereinfachte und traditionelle Schriftfassungen. Alle acht
Lokalisierungen enthalten 181 Texte einschließlich Regeln, KI-Hilfen,
Zugerklärungen, Datenschutzhinweisen, Impressum und Bedienhilfen.
[Auswahl, Quellen und Pflege](LOCALIZATION.md).

**Bestanden:** Release-Simulatorbuild sowie Bundle- und UI-Prüfungen auf
beiden Geräten mit iOS 27, Hochformat, heller Darstellung und Standardtextgröße:

- iPhone, 390 × 844 Punkte: `.build/Native-Localizations-Verified.xcresult`.
- iPad, 744 × 1133 Punkte: `.build/Native-Localizations-iPad-Verified.xcresult`.
- Jeweils der vollständige Ablauf für `fr`, `es`, `ja`, `ko`, `zh-Hans` und
  `zh-Hant`: Startseite, Regeln, Datenschutz, neue Partie mit Stufe 1,
  erweiterte Optionen, Spielfeld, Hinweis und Darstellung. Startseite,
  Einrichtung und Spiel bleiben ohne Scrollansicht bedienbar.
- Der Bundle-Test bestätigt acht eingebundene Sprachen, vollständige
  Schlüssel, passende Formatargumente und die drei Absätze für Datenschutz
  und Herkunft. Die Texte der neuen Fassungen werden tatsächlich geladen.
- Je Gerät 48 Bildschirmaufnahmen; Sichtprüfung ausgewählter Anordnungen,
  darunter alle sechs iPhone-Einrichtungen, lange französische Beschriftungen,
  asiatische Schriften und iPad-Dialoge. Beispielaufnahmen stehen unter
  `Docs/Previews/Localization-*`.
- Ressourcenprüfung mit `--check-localizations`, `plutil -lint` für alle
  16 Sprachdateien und beide Python-Projektsynchronisierungstests bestehen.
  Die Synchronisierung ist wiederholbar; vorhandene Signierung, Ziel- und
  Build-Einstellungen bleiben erhalten.

Im ersten iPad-Test wählte der Test die Navigationsleiste der Hauptansicht
hinter dem Dialog. Die Auswahl wurde auf den Titel des Datenschutzdialogs
begrenzt; der erneute vollständige Durchlauf besteht. Eine koreanische
Kurzbeschriftung wurde vor dem finalen iPad-Build sprachlich geglättet.

Keine Änderungen am Spielkern, an den Lizenzoriginalen, am Versions-/Buildwert
oder an bestehenden Tags. Kein Upload; Store-Metadaten bleiben separat.
Physische Geräte und große Bedienhilfentextgrößen wurden in dieser
Lokalisierungsrunde nicht zusätzlich geprüft.

## Quellrelease 1.2 (Build 8) — 06.10.2026

Versions- und Buildwert in `Configuration/App.xcconfig` auf **1.2 / 8**
angehoben. Der annotierte Quelltag **v1.2** umfasst die fünf zusätzlichen
Sprachen einschließlich beider chinesischer Schriften sowie den Einstieg
auf Stufe 1 mit gemerkter bestätigter Spielstärke. Vorhandene Tags bleiben
unverändert. README, Changelog, Release-/Store-Dokumentation, Sprachübersicht
und lokale Produktdaten einschließlich DE/EN-Versionshinweisen sind aktualisiert.
Das bereits vorhandene TestFlight-Protokoll zu 1.1 (7) wird als datierter
Nachweis mitgeführt; gespeicherte Build- und Verteilungsnachweise bestätigen
den dort festgehaltenen Zustand vom 02.10.2026. Keine neue Apple-Statusabfrage.

**Bestanden:** Release-Simulatorbuild und drei fokussierte Tests in
`.build/Version-1.2-Checks.xcresult` (Protokoll `.build/Version-1.2-Checks.log`):

- Bundlewerte und gebündelte Lizenztexte.
- Alle acht eingebauten Lokalisierungen, vollständige Schlüssel,
  Formatargumente und Absatzstruktur.
- Tatsächliche Anzeige „Version 1.2 · Build 8“ unter „Über Mühlenstein“,
  Impressum, Datenschutz, Quelllinks und Lizenznavigation.

Die erzeugte App-Info.plist bestätigt **1.2**, **8** und
`org.amosystems.Muehlenstein`. Der Build enthält `de`, `en`, `es`, `fr`,
`ja`, `ko`, `zh-Hans` und `zh-Hant`. `ENABLE_TESTABILITY=YES` wurde nur für
den Testlauf verwendet. Der Ressourcen-Prüfmodus, die unverändert bleibende
Projektsynchronisierung, die Produktdaten-/Textlängenprüfung und
`git diff --check` bestehen. Die vorstehend dokumentierten vollständigen
Sprachabläufe auf iPhone und iPad wurden vor diesem Versionswechsel geprüft.

Für 1.2 wurden kein Gerätearchiv, Upload oder Review-Antrag erstellt.


## Distribution 1.2 (8) — 06.10.2026

Signiertes Gerätearchiv und App-Store-Export des Quelltags `v1.2` erfolgreich.
Das exportierte IPA bestätigt Identität, Version, Build, alle acht Sprachen,
Datenschutzmanifest, Lizenzressourcen und Distributionsentitlements;
strikte Codesign-Prüfung bestanden. Apple verarbeitet Build 8 als `VALID`.

Der bestehende Store-Screenshotablauf wurde auf acht Sprachfassungen erweitert.
Die Läufe auf iPhone 18 Pro Max und iPad Pro 13 Zoll bestanden; 64 Originalbilder
wurden gesichtet, exportiert und bei Apple hochgeladen. Alle Bilder sind
`COMPLETE`; Reihenfolge, Abmessungen und MD5-Prüfsummen stimmen überein.
`ENABLE_TESTABILITY=YES` gilt ausschließlich für den Screenshot-Testlauf.

Alle 16 Store-Metadatendateien, acht TestFlight-Beschreibungen und acht
Testhinweise wurden nach dem Speichern erneut abgeglichen. Metadatenprüfung
und abschließende strikte Einreichungsprüfung: keine Fehler oder Warnungen.
App-Store- und TestFlight-Prüfung sind eingereicht und warten auf Apple.
[Nachweise und IDs](../Store/RELEASE-1.2-8.md).

## Lokales Netzwerkspiel — 07.10.2026

**Bestanden:** Der reale Verbindungsablauf zwischen dem physischen FA-iPhone
(iPhone 18 Pro, iOS 27) als Host und einem iPad-mini-Simulator als Gast. Bonjour
findet die Partie; eine Einladung wird ausdrücklich angenommen, ohne Code.
Beide Geräte setzen abwechselnd Steine, Weiß schließt eine Mühle und schlägt
einen schwarzen Stein. Nach Hintergrundwechsel, Beenden und Neustart der
Gast-App wird dieselbe gespeicherte Partie ohne neue Einladung verbunden.
Anschließend werden weitere Züge beider Farben erfolgreich abgeglichen.

Nachweise: `.build/Network-Phone4-Host.xcresult` und
`.build/Network-Phone4-Guest.xcresult`, je ein bestandener UI-Test. Die
Testaufnahmen dokumentieren Einladung, Schlagen und Wiederaufnahme. Die Tests
verwenden eigene Spielstanddateien und überschreiben keine Benutzerpartie.
Bei Netzwerktests warten Eingaben ausdrücklich auf die Freigabe des Bretts;
ein bereits angezeigter empfangener Stein allein bestätigt noch nicht den
Abschluss der Gegenstellenbestätigung.

Weitere erfolgreiche Prüfungen:

- `.build/Network-Final-Unit.xcresult`: alle 37 funktionalen GameStore-Tests,
  einschließlich Einladungsfreigabe, Ablehnen ohne Spielstandverlust,
  Protokoll-/Größenprüfung, Wiederaufnahme nach verlorener Bestätigung,
  doppelten Zugvorschlägen und verspäteten Bestätigungen. Die 18 vollständigen
  Referenzpartien aller vier Varianten werden auf beiden simulierten
  Protokollseiten bis zum identischen Ende gespielt; diese Protokolltests
  ersetzen keine Prüfung der Funkverbindung.
- `.build/Network-Checks.xcresult`: vier UI-Regressionen zu kompakter
  Netzwerkeinrichtung, Abbruch ohne Spielstandverlust, Startseite, Querformat
  und gemerkter Spielstärke; die dort ebenfalls bestandenen 37 Funktionstests
  wurden im vorstehenden finalen Lauf nach der letzten Speicheranpassung
  erneut ausgeführt.
- Signierter Release-Gerätebuild und Release-Simulatorbuild erfolgreich:
  `.build/Network-Final-Device-Build.log` und
  `.build/Network-Final-Simulator-Build.log`.
- Alle 212 Textschlüssel in acht Sprachen vollständig. Lokale
  Netzwerkberechtigung und Bonjour-Dienst im Bundle geprüft.
- Fünf Python-Prüfungen, unveränderte wiederholte Projektsynchronisierung und
  `git diff --check` erfolgreich.

Vorherige reine Simulator-Paarversuche fanden die Partie, scheiterten aber
beim Verbindungsaufbau. Auch nach der gemeldeten Firewall-Freigabe wurde diese
Konstellation nicht erfolgreich bestätigt; die genaue Ursache bleibt offen.
Der anschließend bestandene iPhone-/Simulator-Test bestätigt einen echten
verschlüsselten Datenaustausch, nicht nur den Mock-Transport.

**Verbleibende Geräteabdeckung:** Zwei physische iOS-Geräte im selben WLAN
(auch mit vertauschten Rollen), längere Funkunterbrechungen, Gastnetze und
verweigerte bzw. später widerrufene Netzwerkberechtigung sind vor der
Veröffentlichung zusätzlich praktisch zu prüfen. VoiceOver und Akkumessungen
bleiben wie vereinbart zurückgestellt. Version 1.2 (8) und vorhandene Tags
bleiben unverändert; dieser Entwicklungsstand wurde nicht bei Apple hochgeladen.


## Releasevorbereitung 1.3 (9) — 08.10.2026

Release-Simulatorbuild, signiertes Gerätearchiv und App-Store-Export bestanden.
Am IPA sind Version 1.3, Build 9, Identität, Signatur, Distributionsentitlements,
alle acht Sprachen, Bonjour-Dienst und Datenschutzmanifest geprüft.

`.build/Release-1.3-9/Store-iPhone.xcresult`: 41 bestandene Tests ohne Fehler
oder übersprungene Tests (39 GameStore-Tests einschließlich Leistungsprüfungen,
Versions-/Impressums-/Lizenznavigation und vollständiger Screenshotablauf).
`.build/Release-1.3-9/Store-iPad.xcresult`: ein bestandener Screenshotablauf
über alle acht Sprachen. 80 neue Original-Screenshots einschließlich WLAN-
Einrichtung; alle 16 Kontaktbögen geprüft, Abmessungen und Prüfsummen erfasst.

Die zusätzliche Zwei-iPhone-Prüfung konnte wegen gesperrter Geräte nicht
starten; die wartenden Testprozesse wurden beendet. Der Nutzer hat die
Veröffentlichung ohne diese zusätzliche Prüfung ausdrücklich bestätigt.
Der bestehende erfolgreiche
reale iPhone-/Simulator-Test vom 07.10.2026 bleibt gültig für die unveränderte
Netzwerklogik und ist zusammen mit den erneut bestandenen Release- und
Protokolltests die Prüfbasis dieser Einreichung. Aktueller Apple-Stand und Artefakte:
[Releaseprotokoll](../Store/RELEASE-1.3-9.md).

App-Store-Einreichung am 08.10.2026 um 00:16:57 Uhr bestätigt:
`WAITING_FOR_REVIEW`, automatische Veröffentlichung nach Freigabe.
Alle 80 Screenshots sind `COMPLETE`; Reihenfolge, Abmessungen und Prüfsummen
stimmen mit den Originalen überein. Abschließende strikte ASC-Validierung:
0 Fehler, 0 Warnungen, 0 Blocker. Die Datenschutzveröffentlichung wurde über
die öffentliche Store-Seite bestätigt. Keine Änderung der Binärquellen nach
Quelltag `v1.3`.

## Anfängermodus und feste Einrichtungshöhe — 08.10.2026

**Bestanden:** 27 Rust-Adaptertests, fünf Tests des Vergleichsprogramms und
sechs Python-Prüfungen. Geprüft sind reproduzierbare Fehlentscheidungen,
regelgerechte Auswahl in den Zwischenständen aller 18 Referenzpartien,
Mühlen-/Schlagphasen, unveränderte Ausgangsstellungen, getrennte Tipp-Suche und
Abbruch. Sämtliche importierten Sanmill-Dateien stimmen mit dem Manifest überein.
Die beiden Vergleichsserien mit insgesamt 256 abgeschlossenen Partien sind in
`AI_OPTIONS.md` und `Benchmarks/2026-10-08-anfaengermodus/` dokumentiert.

Release-Simulatorbuild und alle 38 funktionalen GameStore-Tests bestanden,
einschließlich der Trennung von Anfängerzügen und berechneten Tipps. Der Test
für die getrennte Darstellung einer Computer-Mühle und anschließenden Abnahme
verwendet nun die berechnende Stufe 2, da Stufe 1 Mühlen bewusst übersehen darf.
Speicherung, Abbruch, Offline-Partien und Netzwerkprotokoll bleiben geprüft.

- `.build/Beginner-Checks.xcresult`: iPhone, 390 × 844 Punkte; vier UI-Tests
  für feste Einrichtungshöhe in allen drei Modi, auch ausgeklappt, Abbruch der
  WLAN-Einrichtung, Querformat und gemerkte Spielstärke; zusätzlich 38 Funktionstests.
- `.build/Beginner-iPad.xcresult`: iPad mini, 744 × 1133 Punkte; feste
  Einrichtungshöhe sowie erweiterte Einstellungen, Erklärungen und Speicherung.
- Die Layoutprüfung vergleicht tatsächliche Bildschirmkoordinaten vor/nach dem
  Moduswechsel, prüft deaktivierte Computeroptionen und die neue Reihenfolge
  Spielvariante vor Spielstärke. Keine Scrollansicht in der Einrichtung.
- Alle 212 Textschlüssel in acht Sprachen vollständig; Änderungen an den sechs
  KI-Hilfetexten lokalisiert. Keine externen Sprachprüfer hinzugezogen.

Der signierte Release-Gerätebuild wurde erfolgreich erstellt und auf dem
FA-iPhone installiert (`.build/Beginner-Device-Build.log`,
`.build/Beginner-Phone-Install.log`). Das ist noch kein dokumentierter Spieltest
mit menschlichen Anfängern auf dem Gerät.

Protokolle: `.build/Beginner-Engine-Verified.log`,
`.build/Beginner-Benchmark-Tests.log`, `.build/Beginner-Checks.log` und
`.build/Beginner-iPad.log`. Bildschirmaufnahmen der Einrichtung und ihrer
inaktiven Optionen wurden zusätzlich gesichtet.

Menschliche Anfänger wurden in dieser Runde nicht kalibriert. VoiceOver und
Akkumessungen bleiben zurückgestellt. Kein Versionswechsel, Tag oder Apple-Upload.


## Release 1.3.1 (11) — 08.10.2026

Der Produktstand für den Anfängermodus wurde erneut geprüft: 27
Rust-Adaptertests und 288 Sanmill-Tests bestanden. Build 10 bestand
41 Release-Tests auf iPhone (38 funktionale Tests, Versions-/Lizenzanzeige,
feste Einrichtungshöhe und Screenshotablauf) sowie den iPad-Screenshotablauf.
80 Original-Aufnahmen in acht Sprachen wurden exportiert und visuell geprüft.

Build 11 unterscheidet sich ausschließlich in Versions-/Buildkonfiguration;
die 191 Produktdateien wurden per SHA-256 verglichen. Zwei weitere
Versions-/Lizenzprüfungen bestanden für 1.3.1 (11). Insgesamt 44
Release-Prüfungen ohne Fehler und ohne übersprungene Tests. Signatur,
Distributionsentitlements, Bundlewerte, Netzwerkangaben und Sprachressourcen
sind am exportierten IPA verifiziert.

Apple bestätigt `VALID`, `WAITING_FOR_REVIEW` und
`WAITING_FOR_BETA_REVIEW`. Die strikten Vorprüfungen enthalten keine Fehler,
Warnungen oder Blocker. Alle 80 Screenshots sind verarbeitet; Prüfsummen,
Reihenfolge und Abmessungen stimmen. 16 Metadatendateien und acht
Testhinweise sind feldgenau mit Apple abgeglichen. Automatische
Store-Veröffentlichung und Benachrichtigung der drei vorhandenen Tester
nach Apple-Freigabe sind aktiv.

Nachweise: `.build/Release-1.3.1-11/` und `.build/Release-1.3-10/`.
[Releaseprotokoll](../Store/RELEASE-1.3.1-11.md). Der Quelltag `v1.3.1`
entspricht den archivierten Produktdateien. Die bisherigen Grenzen der
physischen Netzwerk-Testabdeckung bleiben bestehen.

## Veröffentlichungsstatus 1.3.1 (11) — 08.10.2026, 20:55 Uhr

App Store Connect bestätigt `READY_FOR_DISTRIBUTION` für Version 1.3.1
mit Build 11. Apples öffentliche Lookup-API für Deutschland liefert
Version 1.3.1 und den Veröffentlichungszeitpunkt `2026-10-08T08:53:55Z`.
Die erneute Prüfung erfolgte um `2026-10-08T18:55:38Z`.

TestFlight meldet separat `WAITING_FOR_BETA_REVIEW`; die Beta-Einreichung
steht auf `WAITING_FOR_REVIEW`. Die Gruppenzuordnung von Build 11 zu
**Externe Tests**, drei Gruppenmitglieder und `autoNotifyEnabled = true`
sind direkt über die API bestätigt. Damit ist der Store-Release verfügbar,
die externe Beta-Installation wartet noch auf Apple.

Branch und Quelltag sind auf GitHub vorhanden; seit `v1.3.1` gibt es keine
Änderungen am App-Produktcode. Kein neuer Build oder Upload erforderlich.
Diese Prüfung betrifft den Distributionsstatus; die früheren Build- und
Geräteprüfungen wurden nicht erneut ausgeführt. Nachweise:
`.build/Release-Status-2026-10-08/` und
[aktuelles Releaseprotokoll](../Store/RELEASE-1.3.1-11.md).

## Verlauf, Spielende und Schlagziele — 10.10.2026

**Bestanden:** Release-Simulatorbuild, alle 40 funktionalen GameStore-Tests
und sechs gezielte UI-Abläufe. Die Änderungen liegen nach dem veröffentlichten
Stand 1.3.1 (11); Versionsnummer, Buildnummer und Quelltag sind unverändert.

- Der Verlauf behält angezeigte Tipps, Rücknahmen und verworfene Zugzweige
  nach Speichern und erneutem Öffnen. Abbruch/Ausblenden eines Tipps,
  nicht verfügbare Rücknahmen und eine neue Partie sind getrennt geprüft.
- Ein veröffentlichter Spielstand ohne Journal wird weiter gelesen. Frühere
  Hilfen gelten ausdrücklich als unbekannt; neue Ereignisse werden ergänzt.
- Die 18 archivierten Offline-Partien prüfen die Ergebnisbestätigung,
  Wiederherstellung sowie Rücknahme und erneutes Erreichen des Endes.
  Die Netzwerk-Referenzpartien prüfen zusätzlich, dass unveränderte
  Positionsmeldungen eine bestätigte Meldung nicht erneut öffnen.
- UI-Prüfungen decken Verlauf/Spieldetails einschließlich Neustart,
  ein- und ausgeschaltete Schlagziele für beide Steinfarben, geschützte
  Mühlen, ruhige Tippanzeige und den bestehenden Schlag-/Rücknahmeablauf ab.
  Siegmeldung, Bestätigung und Neustart sowie ein englisches Remis bei
  größter Schrift im Querformat sind ebenfalls bestanden.
- Die gesichteten Aufnahmen zeigen einen festen leuchtenden Rand um erlaubte
  Schlagziele, lesbare Hilfen-Zähler und eine eindeutige Ergebnis-Meldung.
  Der Rand verschwindet unmittelbar nach der Abnahme. Die Ergebnis-Meldung
  verwendet den nativen Dialog; bei größter Schrift kann dessen Inhalt
  scrollen, die Schaltfläche bleibt erreichbar.
- Alle 221 Textschlüssel in acht Sprachen sind vollständig. Sechs bestehende
  Python-Prüfungen sowie die Prüfung auf Whitespace-Fehler bestehen ebenfalls.

Nachweise: `.build/Feedback-Verified.xcresult` (40 Funktions- und vier UI-Tests,
Gesamtlauf erfolgreich), `.build/Feedback-Checks.xcresult` (die beiden
erfolgreichen Ergebnis-UI-Tests) und zugehörige Protokolle/Attachment-Exporte.
Im ersten Lauf wurden zwei Testannahmen korrigiert: die vorherige Anzahl von
212 Sprachschlüsseln und das Antippen der ganzen Schalterzeile statt des
eigentlichen Schalters. Der zweite Lauf bestätigt diese Prüfungen.

Eine ergänzende Sichtprüfung im Dunkelmodus auf dem Projekt-iPhone 17e
bestätigt Verlauf, Spieldetails, ein-/ausgeschaltete Schlagmarkierung und
die Ergebnis-Meldung mit anschließender Brettansicht. Keine Überlagerungen
oder abgeschnittenen Texte gefunden. Screenshots, UI-Hierarchie und
Interaktionsprotokolle: `.build/Feedback-Visual-Dark/`. Die Prüfsitzung ist beendet.

Geprüft auf dem projektspezifischen iPhone-Simulator mit iOS 27. Kein erneuter
Test auf einem physischen iPhone, kein zweiter WLAN-Gerätetest, kein Apple-Upload.
VoiceOver und Akkumessungen bleiben wie vereinbart zurückgestellt.
