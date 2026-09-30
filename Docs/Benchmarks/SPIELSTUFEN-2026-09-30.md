# Fünf Spielstufen: Entwicklungsvergleich

Stand: 30.09.2026. MTD(f), normale Rechenzeit, alle vier sichtbaren Varianten, produktive C-/JSON-Anbindung als optimiertes Mac-Programm. Keine Elo- oder Gerätemessung.

## Entscheidung

Fünf statt drei Stufen füllen die bisherigen großen Lücken zwischen den Suchtiefen. Stufe 3 bleibt die mittlere Voreinstellung; die früheren Suchprofile entsprechen technisch den neuen Stufen 1, 3 und 5. Die zusätzlichen Profile unterscheiden sich in den berechneten Zügen und Partieergebnissen. Die App verwendet einfache relative Bezeichnungen von „Sehr leicht“ bis „Sehr schwer“. Deren Eignung für menschliche Anfänger und erfahrene Spieler muss noch erprobt werden.

MTD(f) bleibt Standard. Der frühere Vergleich mit PVS begründet weder einen Wechsel noch die Behauptung gleicher Laufzeit oder gleichen Gesamtverbrauchs. Verfahrenswahl und Rechenzeit sind ausschließlich unter „Erweitert“ verfügbar.

## Ergebnisse

Angegeben ist der **Punkteanteil der jeweils höheren Stufe**, einschließlich halber Punkte für Remis. Jede Ausgangsstellung wird mit Farbtausch gespielt. Die Tabelle verwendet die größeren Folgeserien, wo vorhanden; Vorläufe werden nicht hinzugerechnet.

| Vergleich | Farbpaare je Variante | Klassisch | Zwölfstein | Morabaraba | Lasker |
| --- | ---: | ---: | ---: | ---: | ---: |
| 2 gegen 1 | 8 | 96,9 % | 93,8 % | 90,6 % | 84,4 % |
| 3 gegen 2 | 64 | 83,6 % | 65,6 % | 55,5 % | 78,9 % |
| 4 gegen 3 | 64 | 85,2 % | 61,7 % | 69,9 % | 86,3 % |
| 5 gegen 4 | 2 | 100 % | 75 % | 75 % | 75 % |

Die höhere Stufe erreicht in jeder Tabellenzelle mehr Punkte. Das ist **keine statistisch gesicherte Rangfolge für jede Variante**: insbesondere die 55,5 % bei Morabaraba und die winzige Stichprobe der höchsten Stufe sind unsicher. Auch die konservativen Intervalle der mittleren Vergleiche schließen 50 % teilweise ein. Ein höheres Budget garantiert nicht in jeder Stellung den besseren Zug.

## Umfang und Grenzen

- Drei Vorläufe mit jeweils 64 Partien und zwei Folgeserien mit jeweils 512 Partien wurden vollständig beendet. Ein eigener kleiner Lauf für Stufe 4 gegen 5 umfasst weitere 16 vollständige Partien. Zusammen sind das **1.232 Partien in abgeschlossenen Serien**, ohne Engine-Fehler oder Aktionslimit-Abbrüche.
- Ein zusätzlicher 180-Sekunden-Vorlauf für 4 gegen 5 wurde wie geplant am Zeitlimit beendet: 22 protokollierte Partien, davon 21 beendet und eine begrenzt. Das unvollständige Farbpaar wird vollständig aus der Punkteauswertung ausgeschlossen. Dieser Lauf ist explorativ und steht nicht in der Tabelle.
- Die Folgeserien verwenden den vor ihrem Beginn festgelegten neuen Seed `2026093005`; die Vorläufe `2026093004`. Ausgangsstellungen, Budgets und Zeitlimits stehen in `level-plans/` und den Manifesten. Die Stichprobenumfänge wurden vor jeder Serie festgelegt; der kleinere höchste Vergleich wurde nach dem teuren Vorlauf geplant.
- Die Ausgangsstellungen sind synthetische, materialgleiche Setzstellungen mit vier, sechs oder acht Aktionen. Ergebnisse gelten für diese Verteilung; weitere Mittel-/Endspiele und menschliche Partien fehlen.
- Die Auswertung behandelt ein Farbpaar als Beobachtung. `summary.json` enthält konservative Hoeffding-Intervalle und je Serie über vier Varianten korrigierte Grenzen. Diese sind keine gemeinsame Absicherung aller nachträglich ausgewählten Tabellenzellen; die Unabhängigkeitsannahme der Eröffnungspaare und endliche Stichprobe bleiben zu beachten.
- Während Teilen der Serien liefen weitere Entwicklungsprüfungen auf demselben Mac. Gemessene Zeiten sind reine Diagnosewerte verschiedener Spielstellungen, kein kontrollierter Geschwindigkeits-, Speicher- oder Energievergleich. Insbesondere die höchste Stufe kann durch das Zeitlimit und die Geräteauslastung beeinflusst werden.

## Nachvollziehbarkeit

`2026-09-30-fuenf-stufen/` enthält alle sieben Serien mit Manifest, komprimierten Partieprotokollen, Auswertung, Abschlussstatus und Herkunftsprüfungen. Die zum Versuch gehörenden Bridge-, Läufer-, Auswertungs- und Skriptquellen sind beigefügt. Alle 85 importierten Sanmill-Dateien stimmen mit dem Importmanifest überein. `SHA256.json` prüft das Archiv; die Auswertungen wurden aus den Rohdaten erneut berechnet und verglichen.

Die Entwicklungsspeicherung der App verwendet Schema 2 ohne Migration alter Spielstände. Davon unabhängig kennzeichnen Vergleichspläne ihre Drei- oder Fünferskala ausdrücklich, damit historische Messungen ihre Bedeutung behalten.

Vor Veröffentlichung: obere Stufen in größeren Serien, vielfältigere Ausgangsstellungen, feste echte Geräte und kontrollierte Ressourcenmessungen ergänzen; danach Schwierigkeitsbezeichnungen mit Menschen prüfen. Bis dahin keine Elo-Zahlen und keine feste Gewinnchance anzeigen.
