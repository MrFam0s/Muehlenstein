# Mühlenstein — Designsprache 0.1

Stand: 01.10.2026. Beschlossene Namen: **Mühlenstein** auf Deutsch, **Muehlenstein** international und technisch. Die Gestaltung ist ein erster umgesetzter Vorschlag zur Beurteilung in der laufenden App.

## Ruhig, präzise, greifbar

Ein klassisches Brettspiel mit Raum zum Nachdenken. Warme Kalktöne, Graphit, dezent modellierte Spielsteine und Waldgrün als sparsamer Standardakzent. Das Brett trägt die Identität. Die Offline-Version benötigt weder Werbung noch ein Benutzerkonto.

| Farbe | Hell | Dunkel | Verwendung |
| --- | --- | --- | --- |
| Kalk | #F6F3EB | #171D20 | Hintergrund |
| Brett | #EDE8DD | #222C30 | Spielfläche, Bedienleiste |
| Graphit | #263337 | #EFECE4 | Haupttext |
| Nebenfarbe | #596460 | #ADB7B4 | Ergänzende Angaben |
| Waldgrün | #4F624A | #ADBF9F | Standard für Auswahl und Aktionen |
| Schieferblau | #4A6074 | #A8BED1 | Wählbarer Akzent |
| Aubergine | #72556C | #CFB0C7 | Wählbarer Akzent |
| Terrakotta | #8F533C | #DEB098 | Wählbarer Akzent |
| Petrol | #17695F | #8AD0BD | Wählbarer Akzent |
| Brettlinien | #727E77 | #81938C | Geometrie |
| Steinrand | #6D7772 | #9BAAA4 | Kontur beider Steinfarben |

Terrakotta ist gegenüber der Farbstudie im Hellmodus leicht abgedunkelt, damit auch beschriftete Auswahlflächen genügend Kontrast behalten. Primäre Schaltflächen verwenden im Hellmodus Weiß und im Dunkelmodus Graphit (#171D20) als Schriftfarbe. Das installierte App-Icon bleibt ein statisches Asset; die Farbauswahl betrifft die App-Oberfläche.

Systemschrift mit Serifen für Produkt- und Zugüberschriften; serifenlose Systemschrift für Bedienung und Erläuterungen. Die Schrift folgt Dynamic Type. Native Navigation, Menüs und Dialoge greifen die aktuelle iOS-Darstellung auf. Das Brett selbst erhält eine ruhige, stabile Fläche.

## Bildschirmaufbau

1. **Start:** Name/Marke in der bestätigten Position zwischen Werkzeugleiste und Brettillustration, ohne Unterzeile, sowie Fortsetzen und neue Partie. Oben links öffnet das Buchsymbol die Spielregeln; rechts steht „Über Mühlenstein“. Es gibt weder ein allgemeines Einstellungszahnrad noch einen zweiten Regeln-Einstieg unter den Partietasten.
2. **Neue Partie:** Kompakte Auswahl von Gegenspieler, Spielstärke und Variante, mit fest erreichbarer Startaktion. Nur das Ersetzen einer noch laufenden Partie wird bestätigt: Der erste Tipp auf „Partie beginnen“ ändert denselben Knopf zu „Laufende Partie ersetzen“; erst der zweite Tipp startet die neue Partie. Der Knopf reserviert Platz für beide Beschriftungen, damit die Anordnung stabil bleibt. Eine Änderung der Spieloptionen setzt die Bestätigung zurück. Abbrechen bewahrt den bisherigen Spielstand. Es erscheint kein zusätzlicher Bestätigungsdialog. Nach Sieg, Niederlage oder Remis startet die gewählte neue Partie ohne weitere Rückfrage.
3. **Partie:** Zugstatus, kompakter Vorrat beider Seiten, festes Brett, Rücknahme/Tipp/Verlauf. Die Kopfzeile ist zentriert und ohne Info-Taste oder Stufenplakette. Variante, Steinzahlen und Spielstufe stehen im Verlauf unter „Spieldetails“. Unten steht „Züge“ bzw. „1 Zug“. Bei einer Mühle wechselt der Hinweis zur Steinabnahme. Formmarkierungen ergänzen die Farbe.
4. **Verlauf und Zugauswahl:** Der Verlauf zeigt nummerierte Züge von links nach rechts in zwei oder drei Spalten; bei sehr großer Schrift bei Bedarf in einer Spalte. Ein Reiter wechselt zu den Spieldetails. Mögliche Züge erscheinen in einem kompakten Auswahlblatt als direkt antippbares Raster. Spalten- und Zeilenzahl richten sich nach Platz und Schriftgröße; weitere Einträge sind über Vor-/Zurück-Tasten erreichbar.
5. **Informationen und Regeln:** „Über Mühlenstein“, Impressum, Datenschutz, Herkunft und vollständige Lizenztexte sind scrollbar. Zwischenüberschriften, getrennte Kontaktblöcke und eine begrenzte Lesebreite strukturieren die Inhalte. Fließtext nutzt Silbentrennung und auf ausreichend breiten Zeilen Blocksatz; auf schmalen Zeilen oder bei großer Schrift bleibt er linksbündig. Technische Angaben sind aufklappbar. Regeln behalten ihren expliziten Seitenwechsel. Lizenztexte werden weder gekürzt noch zusammengefasst. Ihre festen Quelldatei-Zeilen werden ausschließlich für die Darstellung zu Absätzen zusammengeführt; Überschriften, Aufzählungen und wörtliche Beispiele behalten ihre Struktur. Die eingebundenen Originaldateien bleiben unverändert.
6. **Darstellung:** Ausschließlich im Mehr-Menü der Partie. Unter den Schaltern stehen fünf benannte Farbfelder: Waldgrün (Standard), Schieferblau, Aubergine, Terrakotta und Petrol. Ein Häkchen und eine Kontur kennzeichnen die Auswahl. Sie gilt unmittelbar für die gesamte Oberfläche einschließlich Logo, Aktionen, Links und Brettmarkierungen und bleibt nach einem Neustart erhalten. Sand-, Graphit- und Steinfarben bleiben gleich. Im normalen Hochformat passen alle Bedienelemente auf ein Blatt; bei großer Schrift oder geringer Höhe bleiben sie über die vorhandenen Seitentasten ohne Scrollen erreichbar. „Zugziele“, „Letzter Zug“ und „Steinanimationen deaktivieren“ sind anfangs aus: Das Brett bleibt ohne zusätzliche Zugmarkierungen, Steine bewegen sich weiterhin sanft. Die Auswahl wird auf dem Gerät gespeichert und gilt auch für folgende Partien. Bereits gespeicherte Entscheidungen bleiben erhalten. Ein angeforderter Tipp und die separate Zugauswahl bleiben unabhängig davon verfügbar.
7. **Partie-Einstellungen:** Gegenspieler direkt wählen, Spielstärke mit einem fünfstufigen Regler, Varianten als antippbares 2×2-Raster mit kleinen Brettsymbolen. Erweiterte Suchoptionen klappen auf derselben Seite auf; keine zusätzliche Einstellungsnavigation. Info-Schaltflächen neben den Einstellungen öffnen die Erläuterungen. Das Blatt passt seine Höhe an Gegnerwahl und aufgeklappte Optionen an. Bei sehr großer Schrift und geringer Höhe wechseln kompakte Symbolreiter mit zugänglichen Beschriftungen den sichtbaren Abschnitt innerhalb desselben Blatts. Während einer Computerpartie öffnet „Spielstärke“ im Mehr-Menü dieselben Computer-Bedienelemente als kompakten Dialog einschließlich ausklappbarer erweiterter Optionen. Bei lokalen Partien entfällt dieser Eintrag. Neue Partie und Spielstärke bilden eine Menügruppe; Darstellung, Zugauswahl und Regeln die zweite.

Start-, Spiel- und Konfigurationsansichten bleiben ohne Scrollbereich; die Informationsrubriken unter „Über Mühlenstein“ sind davon ausdrücklich ausgenommen. Im Hochformat steht das Brett zwischen Status und Bedienung; im Querformat daneben. Seine quadratische Größe richtet sich nach der tatsächlich verbleibenden Breite **und Höhe**, maximal 700 pt im Spiel. Status und Hinweise reservieren eine feste Zeilenzahl: Ein längerer Zughinweis verschiebt keine Brettkoordinate. 44-pt-Bretttasten bleiben erhalten. Bei sehr kleinen Flächen und großer Schrift ist zusätzlich die separate Zugauswahl verfügbar.

Bei großer Schrift entfällt die dekorative Brettillustration, wenn nicht genug Platz bleibt. Im Spiel werden umfangreiche Texte in die Spieldetails im Verlauf ausgelagert und die Aktionsleiste verwendet beschriftete Accessibility-Symbole. Dynamic Type bleibt aktiv; längere Dokumente erhalten entsprechend mehr Seiten. Bei großer Schrift stehen auch die Vorratszahlen und die Zugzahl in den Spieldetails, damit das Brett ausreichend Platz behält. VoiceOver erhält Koordinaten, Belegung, Auswahl und letzte Zugmarkierung. Ein vollständiger Test mit VoiceOver auf einem Gerät steht noch aus.

Unter Erweitert steht zusätzlich der Spielstil Ausgewogen/Blockierend mit einer eigenen Info-Taste. Ausgewogen bleibt auf jeder Stufe voreingestellt. Bei sehr großer Schrift steht der Stil in einem eigenen Abschnitt desselben Konfigurationsblatts; die Starttaste bleibt fest erreichbar. Die Partiedetails nennen den gewählten Stil.

## Spieltempo und letzter Zug

Computerzüge bleiben vor ihrer Ausführung ungefähr eine Sekunde sichtbar angekündigt: 850–1150 ms beim Setzen und 950–1250 ms beim Ziehen. Nach einer Mühle folgt die Steinabnahme mit einer eigenen Pause von 650–900 ms. Die tatsächliche Berechnung läuft innerhalb dieser Zeit; langsamere Antworten bekommen keine zusätzliche Wartezeit. Tipps erscheinen ohne künstliche Verzögerung. Erneutes Antippen von „Tipp“ entfernt Text, Info-Symbol und Tippmarkierung samt automatisch ausgewähltem Stein. Eine noch laufende Tippberechnung wird dabei abgebrochen. Nochmals antippen fordert einen neuen Tipp an. Erst nach zwei Sekunden tatsächlicher Berechnung erscheint eine Ladeanzeige; die anschließende Darstellungswartezeit erzeugt keine Ladeanzeige. Das Informationssymbol neben dem Zugvorschlag öffnet überprüfbare unmittelbare Folgen (beispielsweise Mühle oder blockierte Linie) und seine Quelle. Es behauptet keine vollständige Rekonstruktion der Suchbegründung. Der Wechsel zwischen Status und Tipp hält die Brettposition stabil.

Steine gleiten beim Ziehen und Springen in 320 ms mit sanftem Beschleunigen und Abbremsen zum Ziel. Der Auswahlring verschwindet beim Antippen des Ziels sofort, ohne Ausblenden oder Mitgleiten. Beim Setzen und Entfernen werden Steine in derselben Zeit ein- bzw. ausgeblendet, ohne Hüpfen oder Nachfedern. Die Darstellung folgt auch beim Zurücknehmen derselben Steinidentität. Eine neue Partie setzt die visuelle Identität zurück; beim Öffnen einer gespeicherten Partie erscheint unmittelbar der gespeicherte Stand.

Die Einstellung „Steinanimationen deaktivieren“ steht unter „Darstellung“, ist standardmäßig aus und bleibt auf dem Gerät gespeichert. Eingeschaltet oder bei aktiver iOS-Option „Bewegung reduzieren“ wechseln Steine sofort. Intern bleibt die gespeicherte Eigenschaft `animateStones` positiv formuliert; nur die Schalterbindung ist umgekehrt. Die Animation betrifft nur die Zeichenebene: Die 24 Bretttasten behalten ihre Koordinaten, Eingaben und Spielzustand werden nicht verzögert. Die Denkpause des Computers wird unabhängig davon gesteuert.

Währenddessen nennt die Ansicht den Computer ausdrücklich als aktiven Spieler. Anschließend zeigt sie seinen ausgeführten Zug als Text (in kompakten Ansichten über den Verlauf). Ein Ring markiert das Ziel, eine gestrichelte Linie mit Ursprungskreis den Zugweg und ein Kreuz den entfernten Stein. Die Markierungen bleiben bis zur nächsten gespielten Aktion erhalten; Mühle und zugehörige Abnahme bleiben zusammen nachvollziehbar. Die Bretttasten beschreiben diese Rollen auch in ihren VoiceOver-Werten. Farbe ist damit nicht das einzige Unterscheidungsmerkmal.

## Icon und Medien

Der überarbeitete Entwurf verwendet drei verbundene Quadrate, einen hellen und einen dunkel umrandeten Stein auf Petrol. Die größeren Steine und kräftigeren Linien bleiben auch bei 29–60 Punkten erkennbar. Die Dunkelvariante verwendet Graphit mit hellen Petrol-Linien; die Graustufenvorlage wird vom Betriebssystem eingefärbt. Alle drei Assets sind quadratische, deckende sRGB-PNGs mit 1024 × 1024 Pixeln. Die Systemmaske wird nicht in die Assets eingebrannt. `Scripts/generate-icon.swift` ist die editierbare Vektorquelle und erstellt außerdem `Previews/App-Icon-Appearances.png`. Die Vorschau zeigt nur eine angenäherte Eckenmaske; Tönung und weitere Systemeffekte hängen von iOS ab.

Ein Fehler des bisherigen AppKit-Bitmap-Exports hatte eine praktisch schwarze Icon-Datei erzeugt. Der neue Export benutzt einen expliziten Core-Graphics-RGB-Kontext und bricht bei leerer/einfarbiger Ausgabe ab. Die Geometrie und alle Assets sind eigenständig erstellt. Sanmills Logo, Sounds und Store-Grafiken wurden nicht übernommen. Ein mehrschichtiges Icon-Composer-Dokument ist in dieser Etappe nicht enthalten.

## Nächste Designprüfung

Unter Erweitert ergänzt eine Zeile „Eröffnung“ die Auswahl Automatisch/Aus samt Informationssymbol. Die Erklärung nennt klassische Mühle, Stufe 4/5, Offline-Verfügbarkeit, Grenzen und das Zusammenspiel mit dem Stil. Bei wenig Platz hat die Eröffnung einen eigenen Buch-Reiter innerhalb desselben Blatts; es entsteht keine zusätzliche Einstellungsseite und kein Scrollbereich. Neue-Partie-/Computer-Blätter erhalten beim Aufklappen Platz für die zusätzliche Zeile.

Die aktuellen Hell-/Dunkelansichten, die deutlicheren Steinränder und das Icon in der laufenden App beurteilen. Die Grundrichtung bleibt warme Steinfarben mit Waldgrün; vier weitere Akzentfarben sind wählbar. Vollständige VoiceOver- und Akkutests sind vorerst zurückgestellt.

## Kontrast

Textfarben werden mit mindestens 4,5:1, bedeutungstragende Brettgrafiken mit mindestens 3:1 geprüft. `Scripts/check-contrast.py` liest die tatsächlichen Farbassets und berücksichtigt die transparenten Auswahlflächen sowie beide Enden der Steinverläufe. Alle 170 Prüfungen über die fünf Paletten bestehen; das schwächste Textpaar erreicht 4,57:1, die schwächste Brettgrafik 3,46:1. Das ist eine Prüfung dieser Farbrollen, keine pauschale WCAG-Zertifizierung.

Brettlinien sind 2 pt stark. Zugwege und äußere Zielringe verwenden die volle Akzentfarbe. Innere Abnahmeringe nutzen auf hellen Steinen den dunkleren Akzentton und auf dunklen Steinen den helleren Akzentton der gewählten Palette, unabhängig vom Erscheinungsbild. So verliert eine helle Figur im Dunkelmodus ihre Markierung nicht. Ausgewählte kompakte Einstellungsreiter erhalten wie die anderen Auswahlen zusätzlich eine Kontur. Gedrückte primäre Schaltflächen verkleinern sich leicht, ohne den Textkontrast durch Ausblenden abzusenken.

Grundlage: [W3C Textkontrast](https://www.w3.org/WAI/WCAG21/Understanding/contrast-minimum), [W3C Nicht-Text-Kontrast](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html), [Apple App-Icons](https://developer.apple.com/design/human-interface-guidelines/app-icons). Native Glasflächen werden zusätzlich am gerenderten Bild geprüft; Inspector-Warnungen werden dokumentiert und nicht stillschweigend verworfen.

Referenz: [Apple Human Interface Guidelines — Accessibility](https://developer.apple.com/design/human-interface-guidelines/accessibility). Simulatoransichten sind in `Previews/` abgelegt; sie sind Entwicklungsnachweise und keine fertigen Store-Screenshots.
