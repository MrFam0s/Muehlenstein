# MTD(f) gegen PVS: erster Vergleich

**Ergebnis:** Für Stufe 2 mit normaler Rechenzeit zeigt der abgeschlossene Bestätigungslauf keinen belastbaren Spielstärkevorsprung eines Verfahrens. Die Empfehlung bleibt MTD(f) als Voreinstellung; PVS ist eine alternative Suche. Es wird keine numerische Elo-Wertung und keine Rangfolge über alle Stufen daraus abgeleitet.

## Bestätigungslauf: 2.048 regulär beendete Partien

Je Variante wurden 256 unterschiedliche Ausgangsstellungen mit Farbtausch gespielt, also 512 Partien. Der vor Beginn gespeicherte Plan verwendet Seed 2026093003, identische Stufe 2, Rechenzeit Normal, Tiefe höchstens 5, Suchbudget 450 ms und 16 MiB Suchspeicher pro Berechnung. Die Spiele liefen seriell als optimierter Mac-Build durch die Produktionsschnittstelle der App. Keine natürliche Darstellungspause, keine Spiele auf echter iPhone-Hardware.

| Variante | Siege MTD(f) | Remis | Siege PVS | Punkte MTD(f) | Punkte PVS |
| --- | ---: | ---: | ---: | ---: | ---: |
| Klassische Mühle | 174 | 164 | 174 | 50,0 % | 50,0 % |
| Zwölfstein-Mühle | 244 | 21 | 247 | 49,7 % | 50,3 % |
| Morabaraba | 251 | 10 | 251 | 50,0 % | 50,0 % |
| Lasker-Mühle | 212 | 85 | 215 | 49,7 % | 50,3 % |

Punkteanteil: `(Siege + 0,5 × Remis) / Partien`, keine reine Siegquote. Insgesamt 881 Siege für MTD(f), 887 für PVS, 280 Remis. Keine ungültigen Züge, Engine-Fehler oder wegen Aktions-/Zeitgrenze ausgeschlossenen Partien. Alle 1.024 Farbpaare sind vollständig. Der Lauf dauerte auf diesem Mac rund 100 Sekunden; daraus folgt keine Aussage zum Stromverbrauch oder zur Antwortzeit auf einem iPhone.

In 935 von 1.024 Paaren (91,3 %) war sogar die gesamte Zugfolge nach dem Farbtausch identisch. Beide Verfahren teilen sich Regeln und Stellungsbewertung; ihre unterschiedliche Organisation der Suche verändert auf dieser Konfiguration nur selten den Verlauf.

## Was lässt sich daraus schließen?

Die beobachteten Unterschiede sind sehr klein. Die konservativen, über alle vier Vergleiche simultanen 95%-Grenzen für den Punkteanteil von MTD(f) liegen bei rund 40,0–60,0 % (klassisch/Morabaraba) bzw. 39,8–59,7 % (Zwölfstein/Lasker). Alle schließen 50 % ein. Die Daten liefern somit keinen Nachweis eines Vorteils; sie beweisen keine universelle Gleichwertigkeit.

Das Ergebnis gilt für diese Engine-Version, die gewählten Suchgrenzen und die synthetischen Eröffnungen. Vorgegeben sind vier, sechs oder acht legale Setzaktionen ohne Mühle, mit gleich vielen Steinen beider Seiten. Es sind keine repräsentativen menschlichen Partien. Paarwerte werden zusammen ausgewertet, entsprechend dem Grundprinzip der [Fishtest-Paarbetrachtung](https://official-stockfish.github.io/docs/fishtest-wiki/Fishtest-Mathematics.html). Die konservativen Unsicherheitsgrenzen basieren auf [Hoeffdings Schranke für beschränkte Zufallsvariablen](https://www.tandfonline.com/doi/abs/10.1080/01621459.1963.10500830); Annahmen und Formel stehen im Methodenprotokoll.

Die gemessenen Zeiten einzelner Berechnungen stammen aus unterschiedlichen tatsächlich erreichten Stellungen. Sie sind deshalb kein fairer Stellung-für-Stellung-Geschwindigkeitsvergleich. Für die App bleiben Geschwindigkeit, Energiebedarf und höchste Stufe offene Prüfaufgaben.

## Vorläufe und höchste Stufe

Ein Funktionstest mit acht Partien und ein erster abgeschlossener Lauf mit 256 Partien gingen voraus. Letzterer ergab MTD(f)-Punkteanteile von 50,0 / 50,0 / 50,0 / 48,4 %. Der Bestätigungslauf verwendet einen neuen Seed; keine seiner Ausgangsstellungen stimmt nach Drehung/Spiegelung mit einer des 256-Partien-Laufs überein. Die Vorläufe sind nicht in der Tabelle enthalten.

Ein gesonderter Pilot auf Stufe 3 beendete innerhalb des damaligen Zeitlimits vier von acht geplanten Partien, zwei in klassischer und zwei in Zwölfstein-Mühle. Er endete nach rund 183 Sekunden am Paarende. Diese Stichprobe ist unvollständig und viel zu klein für eine Einstufung. Sie wird nicht mit Stufe 2 vermischt. Das Werkzeug prüft sein Gesamtzeitlimit inzwischen zwischen Einzelberechnungen und führt begrenzte Partien ohne Wertung auf.

## Reproduzierbarkeit und Folgeschritte

Das Verzeichnis `2026-09-30-stufe2/` enthält den Plan einschließlich aller Ausgangsstellungen, die maschinenlesbare Auswertung, Plattform- und Quellprüfsummen, archivierte Runner-/Analysequellen sowie alle 2.048 vollständigen Spielverläufe als `games.jsonl.gz`. Die komprimierte Datei wurde verlustfrei gegen die Originaldaten geprüft. Alle 85 importierten Sanmill-Dateien stimmen mit dem Importmanifest überein.

Fünf Rust-Tests prüfen Eröffnungserzeugung, Farbpaar-Kontrolle mit identischen Engines, ungültige Pläne und Grenzen ohne fiktive Remiswertung. Drei Python-Tests prüfen die Auswertung vollständiger/fehlender Paare und die Zurückweisung doppelter Partien. Der aktualisierte Erläuterungsdialog wurde im iPhone-Simulator geprüft.

Als Nächstes: eine längere, getrennte Serie auf Stufe 3; danach Rechenzeitmodi und benachbarte Stufen vergleichen. Für eine Benutzereinstufung und eventuell später ein Rating folgen Tests mit Menschen und auf echten Geräten. Bis dahin bleibt die Formulierung in der App auf den beobachteten Stufe-2-Vergleich begrenzt.
