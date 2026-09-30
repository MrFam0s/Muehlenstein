# Ausgewogener und blockierender Spielstil

Stand: 01.10.2026. Prüfung der originalen Sanmill-Option `focus_on_blocking_paths` über Mühlensteins produktiven C-/JSON-Einstieg. MTD(f), normale Rechenzeit, unveränderte Regeln und importierte Engine-Dateien. Spieler A verwendet Blockierend, Spieler B Ausgewogen. Beide behalten die Beweglichkeitsbewertung.

## Entscheidung

Ausgewogen bleibt auf allen fünf Stufen die Voreinstellung. Blockierend ist eine bewusst wählbare Alternative unter Erweitert, keine Verbesserung höherer Stufen. Im Quellcode wird dabei unter bestimmten Bedingungen der Materialanteil der Bewertung unterdrückt. Eine stärkere Fokussierung auf freie Wege kann daher Materialgewinne zugunsten anderer Ziele aufgeben.

## Serien und Ergebnisse

Der vorab festgelegte Vorlauf umfasst acht Farbpaare je Variante auf Stufe 2, Seed `2026100101`. Nach dessen Abschluss wurde ein separater größerer Vergleich auf der mittleren Standardstufe 3 festgelegt: 64 Farbpaare je Variante, Seed `2026100102`. Alle Ausgangsstellungen werden vor der jeweiligen Serie erzeugt und mit vertauschten Farben gespielt. Die Ergebnisse der beiden Serien werden nicht zusammengerechnet.

Die Prozentwerte sind der **Punkteanteil des blockierenden Stils**, einschließlich halber Punkte für Remis. S/R/N bedeutet Siege, Remis, Niederlagen des blockierenden Stils.

| Variante | Vorlauf Stufe 2: Punkte aus 16 Partien | Stufe 3: S/R/N aus 128 Partien | Stufe 3: Punkte | Simultanes 95%-Intervall Stufe 3 |
| --- | ---: | ---: | ---: | ---: |
| Klassisch | 9,4 % | 37 / 40 / 51 | 44,5 % | 24,6–64,4 % |
| Zwölfstein | 25,0 % | 38 / 3 / 87 | 30,9 % | 10,9–50,8 % |
| Morabaraba | 18,8 % | 41 / 0 / 87 | 32,0 % | 12,1–51,9 % |
| Lasker | 9,4 % | 38 / 23 / 67 | 38,7 % | 18,8–58,6 % |

In beiden Serien liegt Blockierend beobachtet unter 50 %. Die konservativen, über vier Varianten korrigierten Intervalle der größeren Serie schließen 50 % jeweils ein. Eine allgemein gesicherte Unterlegenheit in jeder Variante wird deshalb nicht behauptet. Einen Grund, den Stil automatisch als Verbesserung zu aktivieren, liefert die Untersuchung jedenfalls nicht. Die Unterschiede zwischen Stufe 2 und 3 zeigen zusätzlich, dass die Wirkung vom Suchprofil abhängt.

Alle **576 Partien** aus beiden Serien endeten regulär, ohne Engine-Fehler oder Aktionslimit-Abbruch. Der Vorlauf dauerte etwa drei, die größere Serie etwa 25 Sekunden auf dem Mac. Das sind Laufzeiten dieser Partien auf dem Entwicklungsrechner, keine iPhone-, Energie- oder kontrollierten Geschwindigkeitsmessungen. Teilweise liefen nebenher Entwicklungsprüfungen.

## Grenzen und Wiederholung

Es gelten die in `README.md` beschriebenen Grenzen: synthetische materialgleiche Setzstellungen, keine repräsentative Sammlung menschlicher Mittel-/Endspiele; Farbpaare als Beobachtungseinheit; konservative Hoeffding-Grenzen mit Unabhängigkeitsannahme. Die Serien prüfen Stufe 2 bzw. 3, MTD(f) und Normal. Sie kalibrieren weder alle Stil-/Stufen-Kombinationen noch eine Elo-Zahl. Ein alternativer Stil darf daher nicht als eigene, gesicherte Schwierigkeitsstufe bezeichnet werden.

Die Pläne liegen unter `style-comparison-plan.json` und `style-confirmation-plan.json`. `2026-10-01-spielstile/` enthält pro Serie Manifest, alle Partien als komprimiertes JSONL, Zusammenfassung, Abschlussstatus und Herkunftsprüfung. `sources/` enthält die beim Versuch verwendete Brücke, den Läufer, das Auswertungsskript und die zugehörigen Prüfsummen/Abhängigkeiten. Alle 85 importierten Sanmill-Dateien wurden gegen das Importmanifest geprüft. `SHA256.json` deckt die archivierten Dateien ab.

Wiederholung mit einem neuen Zielordner:

```sh
bash Scripts/compare-search.sh Docs/Benchmarks/style-confirmation-plan.json .build/neuer-stilvergleich
```

Ein fehlendes `style` in alten Vergleichsplänen bedeutet ausdrücklich `balanced`; historische Drei-/Fünferskalen behalten ihre bisherigen Budgets. Unbekannte Stilwerte werden abgelehnt.
