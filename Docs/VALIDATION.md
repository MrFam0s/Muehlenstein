# Prüfstand — 30.09.2026

Lokaler Entwicklungsstand, Xcode 27.0, Swift 6.4, offizieller projektlokaler Rust-Compiler 1.98.1. Deployment-Ziel iOS 18.0. Die Simulatoren verwenden iOS 27.0.

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

## Noch offen

Echte Geräte und ältere unterstützte iOS-Versionen; vollständige VoiceOver-/Kontrastabnahme und weitere assistive Eingaben; Energie-/Speicherverhalten bei längeren Partien und längerer Rechenzeit; Abbruchlatenz auf Hardware; Vergleich weiterer Stufen/Rechenzeitmodi und Kalibrierung mit Menschen; Datenbank- und Feature-Parität; Netzwerkprüfung. Die Simulatorprüfungen ersetzen keine vollständige Barrierefreiheitsabnahme. Es wird noch keine Elo-/Glicko-Wertung angezeigt.
