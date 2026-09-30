# Spielhilfen, Suchverfahren und Spielstärke

Stand: 30.09.2026. Produktentscheidung für den lokalen Prototyp.

## Aktuell umgesetzt

Die einfache Einrichtung bietet fünf Stufen: 1 Sehr leicht, 2 Leicht, 3 Mittel, 4 Schwer, 5 Sehr schwer. Voreinstellung ist Stufe 3 mit MTD(f) und normaler Rechenzeit. Die Stufe bezeichnet ein Suchprofil innerhalb dieser App, keine menschlich kalibrierte Wertung. Neben dem Computervorrat steht optional „Stufe n/5“; die Partiedetails nennen Stufe und Bezeichnung. Technische Suchangaben stehen ausschließlich im erweiterten Bereich.

Die geräteweit gespeicherten Spielhilfen schalten Zugziele, letzten Zug und Stufenanzeige unabhängig. Ohne Zielmarkierungen bleiben Regeln und Touchbedienung unverändert. Die Auswahl eines eigenen Steins bleibt als Bedienrückmeldung sichtbar. Ein angeforderter Tipp sowie die separate Zugliste und der Verlauf bleiben verfügbar. Dies ist kein gewerteter Wettbewerbsmodus.

„Neue Partie“ enthält die direkte Computer-/Zwei-Spieler-Auswahl, den Regler mit fünf Rastpunkten und ein 2×2-Raster der vier Varianten. „Erweitert“ klappt MTD(f)/PVS und Normal/Länger direkt darunter auf. Ein separates Einstellungsfenster über der Einrichtung entfällt. Info-Schaltflächen neben Stufe, Variante, Suche und Rechenzeit öffnen nur bei Bedarf die Erklärung. Während einer Partie verwendet „Computer einstellen“ dieselben kompakten Bedienelemente; dort übernimmt „Fertig“ den gemeinsamen Entwurf. Eine neue Partie übernimmt die Auswahl mit „Partie beginnen“. Auch während einer Partie kann sie geändert werden, ohne den Spielverlauf zu verlieren. Laufende alte Berechnungen werden abgebrochen und verworfen.

| Stufe | Normal: Tiefe / Budget | Länger: Tiefe / Budget |
| --- | --- | --- |
| 1 | 2 / 150 ms | 4 / 600 ms |
| 2 | 4 / 250 ms | 6 / 1000 ms |
| 3 | 5 / 450 ms | 8 / 1800 ms |
| 4 | 8 / 800 ms | 12 / 2600 ms |
| 5 | 12 / 1200 ms | 16 / 3600 ms |

Tiefe und Zeit sind Suchgrenzen. Der Suchlauf kann früher enden; kooperative Zeitprüfung, Replay und Darstellung ergeben keine garantierte Gesamtantwortzeit. Beide Verfahren verwenden denselben Sanmill-Evaluator und reservieren jeweils 16 MiB Transpositionstabelle. Daraus folgt keine Gleichheit des gesamten Speicherverbrauchs oder der Laufzeit. Ein Vergleich auf echten iOS-Geräten bleibt offen. Die längere Suche erhöht die möglichen Rechenkosten; konkrete Energie- und Stärkegewinne sind noch zu messen.

Die Entwicklung verwendet jetzt Spielstand-Schema 2 ohne Migration früherer Entwicklungsstände. Auf Wunsch werden keine Kompatibilitätspfade für alte Spielstände gepflegt. Die getrennte Engine-Schnittstelle kennzeichnet das Suchprofil mit `level_scale: "five"`; ihre alte Dreierskala bleibt ausschließlich zur eindeutigen Wiederholung archivierter Vergleichspläne verfügbar.

## Begründung der Auswahl

MTD(f) bleibt die bewährte Voreinstellung dieser App. Der bisherige Vergleich mit PVS begründet keinen Wechsel und keine Aussage, dass beide Verfahren immer gleich effizient seien. Fünf Stufen füllen die großen Lücken zwischen den bisherigen Tiefengrenzen 2, 5 und 12. Die beiden Zwischenstufen verändern tatsächlich Suchverhalten und Ergebnisse. Die Vergleiche sind in `Benchmarks/SPIELSTUFEN-2026-09-30.md` dokumentiert. Die Namen sind vorläufige relative Schwierigkeitsangaben; Tests mit Menschen und auf Geräten folgen vor Veröffentlichung.

## Erklärung in der App

Die Hilfe nennt zuerst die Empfehlung: MTD(f) beibehalten, wenn man einfach spielen möchte; für die Schwierigkeit zunächst die Stufe verändern. Anschließend erläutert sie beide Verfahren in Alltagssprache, jeweils mit Stärke, Schwäche und dem möglichen Effekt auf die Zugwahl. PVS wird als alternative Suche desselben Spielkerns beschrieben, nicht als anders trainierte KI oder als eigener Spielcharakter.

MTD(f) profitiert von einer brauchbaren Anfangsschätzung und wiederverwendbaren Suchergebnissen; zusätzliche Durchläufe können bei einer schlechten Schätzung Aufwand verursachen. PVS profitiert von guter Zugreihenfolge; unerwartet bessere Alternativen benötigen erneute Untersuchung. Daraus folgt keine pauschale Rangfolge der praktischen Spielstärke. Die App verspricht weder einen Geschwindigkeits- noch einen Energiegewinn durch den Wechsel.

Andere vorhandene Verfahren, insbesondere MCTS, bleiben zunächst außerhalb der Oberfläche. Vor einer Freigabe sind die eigene Anbindung, Abbruchfähigkeit, Laufzeitgrenzen, Gerätebelastung und Qualität über alle sichtbaren Varianten zu prüfen. Mehr Auswahl allein ist kein Produktvorteil.

## Erster gemessener Vergleich

Am 30.09.2026 wurden nach Vorläufen 2.048 weitere Partien mit Farbtausch auf der damaligen Stufe 2 / Normal (heute Stufe 3 mit denselben Budgets) abgeschlossen. In klassischer Mühle und Morabaraba stehen beide Verfahren bei 50 % der Punkte; in Zwölfstein- und Lasker-Mühle erreicht PVS 50,3 %. Daraus folgt kein belastbarer Spielstärkevorsprung. Die Hilfe nennt nun diesen begrenzten Befund. Messungen auf der höchsten Stufe, Vergleiche des Geräteverbrauchs und eine menschliche Kalibrierung bleiben offen. Ergebnisse, Annahmen und archivierte Rohdaten sind unter `Benchmarks/ERGEBNISSE-2026-09-30.md` dokumentiert.

## Eine belastbare Mühle-Wertung vorbereiten

Eine Elo-artige Zahl beschreibt Ergebnisse relativ zu einer definierten Gegnergruppe. Eine Schach-Elo lässt sich nicht als Mühle-Stärke übernehmen. Die jetzigen fünf Stufen sind dafür noch nicht kalibriert. Auch eine dynamische Anpassung der Schwierigkeit und ein Ratingsystem sind unterschiedliche Funktionen.

1. Das jetzt vorhandene reproduzierbare Prüfprogramm erweitern: feste Engine-Version, Konfigurationen und Suchgrenzen sind dokumentiert. Weitere Mittel-/Endspielstellungen sowie echte Geräte und Energiemessungen ergänzen. Deterministische Wiederholung derselben Startpartie liefert keine unabhängigen Vergleichsdaten.
2. Paarungen mit Farbtausch und identischen Ausgangsstellungen durchführen. Pro Variante getrennt auswerten; Sieg/Remis/Niederlage, Unsicherheit und Abbruchfälle berichten. Stufen nur nach gemessener Reihenfolge neu benennen; ein höheres Rechenbudget garantiert keinen Sieg in jeder einzelnen Partie.
3. Anschließend mit menschlichen Testspielern kalibrieren. Eine nur aus Engine-Partien abgeleitete Skala ausdrücklich als interne Skala kennzeichnen. Keine frei erfundenen „800/1400/2000 Elo“ an die Menüstufen schreiben.
4. Für ein späteres persönliches Rating Glicko-2 prüfen. Es modelliert neben der Wertung auch Unsicherheit und Schwankungen. Neue oder wenig aktive Profile als vorläufig kennzeichnen, statt sofort eine präzise Zahl zu suggerieren. Spielmodi mit Tipps, Rücknahmen oder geänderter Stärke benötigen eine getrennte Wertungsregel.
5. Einen optionalen Trainingsmodus danach ergänzen: Ergebnisse auswerten und zwischen Partien eine passende Stufe vorschlagen. Den Wechsel anzeigen und manuell übersteuerbar halten. Während einer Partie keine versteckte Schwierigkeitsanpassung.
6. Für öffentliche Netzwerk-Wertungen erst nachvollziehbare Spielidentität, validierte Ergebnisse, Verbindungsabbruchregeln und Manipulationsschutz festlegen. Die Offline-App benötigt dafür jetzt weder Konto noch Server.

## Primärquellen

- [Sanmill, verwendeter Quellstand](https://github.com/calcitem/Sanmill/tree/8901a06f088bf49a1602fee8686ed25ac5a33925): insbesondere `crates/tgf-search/src/searcher/mod.rs` (`search_pvs`) und `searcher/iterative_mtdf.rs` (`search_mtdf_with_guess`); lokal unverändert importiert.
- [Aske Plaat: MTD(f)](https://askeplaat.wordpress.com/534-2/mtdf-algorithm/): Beschreibung durch den Autor, Voraussetzungen und Implementierungshinweise. Historische Vergleichsergebnisse dieser Quelle sind kein Benchmark der iOS-App.
- [Mark E. Glickman: Example of the Glicko-2 system](https://www.glicko.net/glicko/glicko2.pdf): Grundlage für eine mögliche spätere Wertung einschließlich Unsicherheit; noch nicht in Mühlenstein implementiert.
