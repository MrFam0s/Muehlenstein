# Mühlenstein — Designsprache 0.1

Stand: 30.09.2026. Beschlossene Namen: **Mühlenstein** auf Deutsch, **Muehlenstein** international und technisch. Die Gestaltung ist ein erster umgesetzter Vorschlag zur Beurteilung in der laufenden App.

## Ruhig, präzise, greifbar

Ein klassisches Brettspiel mit Raum zum Nachdenken. Warme Kalktöne, Graphit, dezent modellierte Spielsteine und Petrol als sparsamer Akzent. Das Brett trägt die Identität. Die Offline-Version benötigt weder Werbung noch ein Benutzerkonto.

| Farbe | Hell | Dunkel | Verwendung |
| --- | --- | --- | --- |
| Kalk | #F6F3EB | #171D20 | Hintergrund |
| Brett | #EDE8DD | #222C30 | Spielfläche, Bedienleiste |
| Graphit | #263337 | #EFECE4 | Haupttext |
| Nebenfarbe | #616B68 | #ADB7B4 | Ergänzende Angaben |
| Petrol | #17695F | #8AD0BD | Auswahl und Aktionen |
| Brettlinien | #88918A | #81938C | Geometrie |

Systemschrift mit Serifen für Produkt- und Zugüberschriften; serifenlose Systemschrift für Bedienung und Erläuterungen. Die Schrift folgt Dynamic Type. Native Navigation, Menüs und Dialoge greifen die aktuelle iOS-Darstellung auf. Das Brett selbst erhält eine ruhige, stabile Fläche.

## Bildschirmaufbau

1. **Start:** Nur Name/Marke, Brettillustration sowie Fortsetzen, neue Partie und Spielregeln. Die bisherigen Werbesätze und die Fußzeile entfallen vollständig.
2. **Neue Partie:** Kompakte Auswahl von Gegenspieler, Spielstärke und Variante, mit fest erreichbarer Startaktion. Das Ersetzen einer gespeicherten Partie wird bestätigt.
3. **Partie:** Zugstatus, kompakter Vorrat beider Seiten, festes Brett, Rücknahme/Tipp/Verlauf. Details zu Variante, Steinzahlen und aktueller Aktion sind über die Info-Taste erreichbar. Bei einer Mühle wechselt der Hinweis zur Steinabnahme. Formmarkierungen ergänzen die Farbe.
4. **Verlauf und Zugauswahl:** Nummerierte Aktionen auf Seiten mit Vor-/Zurück-Tasten. Die Zeilenzahl richtet sich nach verfügbarer Höhe und Schriftgröße.
5. **Regeln, Herkunft und Lizenz:** Vollständige Texte mit explizitem Seitenwechsel. Die Lizenz wird weder gekürzt noch zusammengefasst.
6. **Spielhilfen:** Zahnrad auf der Startseite und Eintrag im Partiemenü. Zugziele, letzter Zug und Spielstufe lassen sich unabhängig ausblenden. Die Auswahl bleibt nach dem Neustart erhalten.
7. **Partie-Einstellungen:** Gegenspieler direkt wählen, Spielstärke mit einem fünfstufigen Regler, Varianten als antippbares 2×2-Raster mit kleinen Brettsymbolen. Erweiterte Suchoptionen klappen auf derselben Seite auf; keine zusätzliche Einstellungsnavigation. Info-Schaltflächen neben den Einstellungen öffnen die Erläuterungen. Das Blatt passt seine Höhe an Gegnerwahl und aufgeklappte Optionen an. Bei sehr großer Schrift und geringer Höhe wechseln kompakte Symbolreiter mit zugänglichen Beschriftungen den sichtbaren Abschnitt innerhalb desselben Blatts. Während einer Partie gibt es dieselben Computer-Bedienelemente als kompakten Dialog.

Keine eigene Haupt-, Spiel-, Konfigurations- oder Leseansicht enthält einen Scrollbereich. Im Hochformat steht das Brett zwischen Status und Bedienung; im Querformat daneben. Seine quadratische Größe richtet sich nach der tatsächlich verbleibenden Breite **und Höhe**, maximal 700 pt im Spiel. Status und Hinweise reservieren eine feste Zeilenzahl: Ein längerer Zughinweis verschiebt keine Brettkoordinate. 44-pt-Bretttasten bleiben erhalten. Bei sehr kleinen Flächen und großer Schrift ist zusätzlich die separate Zugauswahl verfügbar.

Bei großer Schrift entfällt die dekorative Brettillustration, wenn nicht genug Platz bleibt. Im Spiel werden umfangreiche Texte in die Zugdetails ausgelagert und die Aktionsleiste verwendet beschriftete Accessibility-Symbole. Dynamic Type bleibt aktiv; längere Dokumente erhalten entsprechend mehr Seiten. Bei großer Schrift stehen auch die Vorratszahlen und die Aktionszahl in den Zugdetails, damit das Brett ausreichend Platz behält. VoiceOver erhält Koordinaten, Belegung, Auswahl und letzte Zugmarkierung. Ein vollständiger Test mit VoiceOver auf einem Gerät steht noch aus.

## Spieltempo und letzter Zug

Computerzüge bleiben vor ihrer Ausführung ungefähr eine Sekunde sichtbar angekündigt: 850–1150 ms beim Setzen und 950–1250 ms beim Ziehen. Nach einer Mühle folgt die Steinabnahme mit einer eigenen Pause von 650–900 ms. Die tatsächliche Berechnung läuft innerhalb dieser Zeit; langsamere Antworten bekommen keine zusätzliche Wartezeit. Tipps erscheinen ohne künstliche Verzögerung.

Währenddessen nennt die Ansicht den Computer ausdrücklich als aktiven Spieler. Anschließend zeigt sie seinen ausgeführten Zug als Text (in kompakten Ansichten über die Zugdetails). Ein Ring markiert das Ziel, eine gestrichelte Linie mit Ursprungskreis den Zugweg und ein Kreuz den entfernten Stein. Die Markierungen bleiben bis zur nächsten gespielten Aktion erhalten; Mühle und zugehörige Abnahme bleiben zusammen nachvollziehbar. Die Bretttasten beschreiben diese Rollen auch in ihren VoiceOver-Werten. Farbe ist damit nicht das einzige Unterscheidungsmerkmal.

## Icon und Medien

Der erste Icon-Entwurf abstrahiert drei Quadrate und zwei Spielsteine. Die Geometrie wurde neu erstellt. Sanmills Logo, Sounds und Store-Grafiken wurden nicht übernommen. Eigene dezente Klänge können nach der Beurteilung der Bedienung folgen.

## Nächste Designprüfung

Die tatsächlichen Simulatoransichten auf Wärme, Steinkontrast, Brettproportionen und Lesbarkeit beurteilen. Danach Icon, Abstände und Rückmeldungen verfeinern. Alternative Materialien erst ergänzen, wenn diese Grundrichtung bewertet ist.

Referenz: [Apple Human Interface Guidelines — Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility). Simulatoransichten sind in `Previews/` abgelegt; sie sind Entwicklungsnachweise und keine fertigen Store-Screenshots.
