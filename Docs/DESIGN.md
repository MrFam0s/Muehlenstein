# Mühlenstein — Designsprache 0.1

Stand: 01.10.2026. Beschlossene Namen: **Mühlenstein** auf Deutsch, **Muehlenstein** international und technisch. Die Gestaltung ist ein erster umgesetzter Vorschlag zur Beurteilung in der laufenden App.

## Ruhig, präzise, greifbar

Ein klassisches Brettspiel mit Raum zum Nachdenken. Warme Kalktöne, Graphit, dezent modellierte Spielsteine und Petrol als sparsamer Akzent. Das Brett trägt die Identität. Die Offline-Version benötigt weder Werbung noch ein Benutzerkonto.

| Farbe | Hell | Dunkel | Verwendung |
| --- | --- | --- | --- |
| Kalk | #F6F3EB | #171D20 | Hintergrund |
| Brett | #EDE8DD | #222C30 | Spielfläche, Bedienleiste |
| Graphit | #263337 | #EFECE4 | Haupttext |
| Nebenfarbe | #596460 | #ADB7B4 | Ergänzende Angaben |
| Petrol | #17695F | #8AD0BD | Auswahl und Aktionen |
| Brettlinien | #727E77 | #81938C | Geometrie |
| Steinrand | #6D7772 | #9BAAA4 | Kontur beider Steinfarben |

Systemschrift mit Serifen für Produkt- und Zugüberschriften; serifenlose Systemschrift für Bedienung und Erläuterungen. Die Schrift folgt Dynamic Type. Native Navigation, Menüs und Dialoge greifen die aktuelle iOS-Darstellung auf. Das Brett selbst erhält eine ruhige, stabile Fläche.

## Bildschirmaufbau

1. **Start:** Nur Name/Marke, Brettillustration sowie Fortsetzen, neue Partie und Spielregeln. Die bisherigen Werbesätze und die Fußzeile entfallen vollständig.
2. **Neue Partie:** Kompakte Auswahl von Gegenspieler, Spielstärke und Variante, mit fest erreichbarer Startaktion. Nur das Ersetzen einer noch laufenden Partie wird bestätigt. Nach Sieg, Niederlage oder Remis startet die gewählte neue Partie ohne weitere Rückfrage.
3. **Partie:** Zugstatus, kompakter Vorrat beider Seiten, festes Brett, Rücknahme/Tipp/Verlauf. Details zu Variante, Steinzahlen und aktueller Aktion sind über die Info-Taste erreichbar. Bei einer Mühle wechselt der Hinweis zur Steinabnahme. Formmarkierungen ergänzen die Farbe.
4. **Verlauf und Zugauswahl:** Nummerierte Aktionen auf Seiten mit Vor-/Zurück-Tasten. Die Zeilenzahl richtet sich nach verfügbarer Höhe und Schriftgröße.
5. **Regeln, Herkunft und Lizenz:** Vollständige Texte mit explizitem Seitenwechsel. Die Lizenz wird weder gekürzt noch zusammengefasst.
6. **Spielhilfen:** Zahnrad auf der Startseite und Eintrag im Partiemenü. Zugziele, letzter Zug und Spielstufe lassen sich unabhängig ausblenden. Steinanimationen sind separat schaltbar. Die Auswahl bleibt nach dem Neustart erhalten.
7. **Partie-Einstellungen:** Gegenspieler direkt wählen, Spielstärke mit einem fünfstufigen Regler, Varianten als antippbares 2×2-Raster mit kleinen Brettsymbolen. Erweiterte Suchoptionen klappen auf derselben Seite auf; keine zusätzliche Einstellungsnavigation. Info-Schaltflächen neben den Einstellungen öffnen die Erläuterungen. Das Blatt passt seine Höhe an Gegnerwahl und aufgeklappte Optionen an. Bei sehr großer Schrift und geringer Höhe wechseln kompakte Symbolreiter mit zugänglichen Beschriftungen den sichtbaren Abschnitt innerhalb desselben Blatts. Während einer Partie gibt es dieselben Computer-Bedienelemente als kompakten Dialog.

Keine eigene Haupt-, Spiel-, Konfigurations- oder Leseansicht enthält einen Scrollbereich. Im Hochformat steht das Brett zwischen Status und Bedienung; im Querformat daneben. Seine quadratische Größe richtet sich nach der tatsächlich verbleibenden Breite **und Höhe**, maximal 700 pt im Spiel. Status und Hinweise reservieren eine feste Zeilenzahl: Ein längerer Zughinweis verschiebt keine Brettkoordinate. 44-pt-Bretttasten bleiben erhalten. Bei sehr kleinen Flächen und großer Schrift ist zusätzlich die separate Zugauswahl verfügbar.

Bei großer Schrift entfällt die dekorative Brettillustration, wenn nicht genug Platz bleibt. Im Spiel werden umfangreiche Texte in die Zugdetails ausgelagert und die Aktionsleiste verwendet beschriftete Accessibility-Symbole. Dynamic Type bleibt aktiv; längere Dokumente erhalten entsprechend mehr Seiten. Bei großer Schrift stehen auch die Vorratszahlen und die Aktionszahl in den Zugdetails, damit das Brett ausreichend Platz behält. VoiceOver erhält Koordinaten, Belegung, Auswahl und letzte Zugmarkierung. Ein vollständiger Test mit VoiceOver auf einem Gerät steht noch aus.

Unter Erweitert steht zusätzlich der Spielstil Ausgewogen/Blockierend mit einer eigenen Info-Taste. Ausgewogen bleibt auf jeder Stufe voreingestellt. Bei sehr großer Schrift steht der Stil in einem eigenen Abschnitt desselben Konfigurationsblatts; die Starttaste bleibt fest erreichbar. Die Partiedetails nennen den gewählten Stil.

## Spieltempo und letzter Zug

Computerzüge bleiben vor ihrer Ausführung ungefähr eine Sekunde sichtbar angekündigt: 850–1150 ms beim Setzen und 950–1250 ms beim Ziehen. Nach einer Mühle folgt die Steinabnahme mit einer eigenen Pause von 650–900 ms. Die tatsächliche Berechnung läuft innerhalb dieser Zeit; langsamere Antworten bekommen keine zusätzliche Wartezeit. Tipps erscheinen ohne künstliche Verzögerung.

Steine gleiten beim Ziehen und Springen in 320 ms mit sanftem Beschleunigen und Abbremsen zum Ziel. Der Auswahlring verschwindet beim Antippen des Ziels sofort, ohne Ausblenden oder Mitgleiten. Beim Setzen und Entfernen werden Steine in derselben Zeit ein- bzw. ausgeblendet, ohne Hüpfen oder Nachfedern. Die Darstellung folgt auch beim Zurücknehmen derselben Steinidentität. Eine neue Partie setzt die visuelle Identität zurück; beim Öffnen einer gespeicherten Partie erscheint unmittelbar der gespeicherte Stand.

Die Einstellung „Steinanimationen“ steht unter „Spielhilfen“, ist standardmäßig aktiv und bleibt auf dem Gerät gespeichert. Ausgeschaltet oder bei aktiver iOS-Option „Bewegung reduzieren“ wechseln Steine sofort. Die Animation betrifft nur die Zeichenebene: Die 24 Bretttasten behalten ihre Koordinaten, Eingaben und Spielzustand werden nicht verzögert. Die Denkpause des Computers wird unabhängig davon gesteuert.

Währenddessen nennt die Ansicht den Computer ausdrücklich als aktiven Spieler. Anschließend zeigt sie seinen ausgeführten Zug als Text (in kompakten Ansichten über die Zugdetails). Ein Ring markiert das Ziel, eine gestrichelte Linie mit Ursprungskreis den Zugweg und ein Kreuz den entfernten Stein. Die Markierungen bleiben bis zur nächsten gespielten Aktion erhalten; Mühle und zugehörige Abnahme bleiben zusammen nachvollziehbar. Die Bretttasten beschreiben diese Rollen auch in ihren VoiceOver-Werten. Farbe ist damit nicht das einzige Unterscheidungsmerkmal.

## Icon und Medien

Der überarbeitete Entwurf verwendet drei verbundene Quadrate, einen hellen und einen dunkel umrandeten Stein auf Petrol. Die größeren Steine und kräftigeren Linien bleiben auch bei 29–60 Punkten erkennbar. Die Dunkelvariante verwendet Graphit mit hellen Petrol-Linien; die Graustufenvorlage wird vom Betriebssystem eingefärbt. Alle drei Assets sind quadratische, deckende sRGB-PNGs mit 1024 × 1024 Pixeln. Die Systemmaske wird nicht in die Assets eingebrannt. `Scripts/generate-icon.swift` ist die editierbare Vektorquelle und erstellt außerdem `Previews/App-Icon-Appearances.png`. Die Vorschau zeigt nur eine angenäherte Eckenmaske; Tönung und weitere Systemeffekte hängen von iOS ab.

Ein Fehler des bisherigen AppKit-Bitmap-Exports hatte eine praktisch schwarze Icon-Datei erzeugt. Der neue Export benutzt einen expliziten Core-Graphics-RGB-Kontext und bricht bei leerer/einfarbiger Ausgabe ab. Die Geometrie und alle Assets sind eigenständig erstellt. Sanmills Logo, Sounds und Store-Grafiken wurden nicht übernommen. Ein mehrschichtiges Icon-Composer-Dokument ist in dieser Etappe nicht enthalten.

## Nächste Designprüfung

Die aktuellen Hell-/Dunkelansichten, die deutlicheren Steinränder und das Icon in der laufenden App beurteilen. Die Grundrichtung bleibt warme Steinfarben mit Petrol. Vollständige VoiceOver- und Akkutests sind vorerst zurückgestellt.

## Kontrast

Textfarben werden mit mindestens 4,5:1, bedeutungstragende Brettgrafiken mit mindestens 3:1 geprüft. `Scripts/check-contrast.py` liest die tatsächlichen Farbassets und berücksichtigt die transparenten Auswahlflächen sowie beide Enden der Steinverläufe. Die 34 erfassten Farbrollen bestehen; das schwächste Textpaar erreicht 4,88:1, die schwächste Brettgrafik 3,46:1. Das ist eine Prüfung dieser Farbrollen, keine pauschale WCAG-Zertifizierung.

Brettlinien sind 2 pt stark. Zugwege und äußere Zielringe verwenden die volle Akzentfarbe. Innere Abnahmeringe bleiben auf hellen Steinen dunkelpetrol und auf dunklen Steinen hellpetrol, unabhängig vom Erscheinungsbild. So verliert eine helle Figur im Dunkelmodus ihre Markierung nicht. Ausgewählte kompakte Einstellungsreiter erhalten wie die anderen Auswahlen zusätzlich eine Kontur. Gedrückte primäre Schaltflächen verkleinern sich leicht, ohne den Textkontrast durch Ausblenden abzusenken.

Grundlage: [W3C Textkontrast](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum), [W3C Nicht-Text-Kontrast](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html), [Apple App-Icons](https://developer.apple.com/design/human-interface-guidelines/app-icons). Native Glasflächen werden zusätzlich am gerenderten Bild geprüft; Inspector-Warnungen werden dokumentiert und nicht stillschweigend verworfen.

Referenz: [Apple Human Interface Guidelines — Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility). Simulatoransichten sind in `Previews/` abgelegt; sie sind Entwicklungsnachweise und keine fertigen Store-Screenshots.
