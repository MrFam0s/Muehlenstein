# Spielhilfen, Suchverfahren und Spielstärke

Stand: 01.10.2026. Produktentscheidung für den lokalen Prototyp, einschließlich Abgleich mit der Original-App.

**Ergänzung nach der unten dokumentierten ersten Optionsprüfung:** Das kleine klassische Eröffnungsorakel ist inzwischen integriert: automatisch auf Stufe 4/5, unter Erweitert → Eröffnung abschaltbar, mit legalitätsgeprüften Symmetrien und Such-Fallback. Die vollständige Perfect DB und ihre Teilpakete bleiben nach konkreter Aufwand-/Nutzenprüfung zurückgestellt. Die bisherige Bezeichnung „separater C++-Wrapper“ ist zu präzisieren: Upstream besitzt bereits einen Rust-nativen Leser mit optionalem C++-Vergleich. Entscheidung, Größen, Grenzen und Prüfungen stehen in `OPENING_AND_DATABASE.md`; die Tabelle unten berücksichtigt diese Ergänzung. Die Suchbudgets bleiben gleich, Buchtreffer ändern auf Stufe 4/5 jedoch die Zugwahl.

## Aktuell umgesetzt

Die einfache Einrichtung bietet fünf Stufen: 1 Sehr leicht, 2 Leicht, 3 Mittel, 4 Schwer, 5 Sehr schwer. Voreinstellung ist Stufe 3 mit MTD(f) und normaler Rechenzeit. Die Stufe bezeichnet ein Suchprofil innerhalb dieser App, keine menschlich kalibrierte Wertung. Neben dem Computervorrat steht optional „Stufe n/5“; die Partiedetails nennen Stufe und Bezeichnung. Technische Suchangaben stehen ausschließlich im erweiterten Bereich.

Die geräteweit gespeicherten Spielhilfen schalten Zugziele, letzten Zug und Steinanimationen unabhängig. Spielstufe und Computer-Konfiguration stehen im Verlauf unter „Spieldetails“. Ohne Zielmarkierungen bleiben Regeln und Touchbedienung unverändert. Die Auswahl eines eigenen Steins bleibt als Bedienrückmeldung sichtbar. Ein angeforderter Tipp sowie die separate Zugauswahl und der Verlauf bleiben verfügbar. Dies ist kein gewerteter Wettbewerbsmodus.

„Neue Partie“ enthält die direkte Computer-/Zwei-Spieler-Auswahl, den Regler mit fünf Rastpunkten und ein 2×2-Raster der vier Varianten. „Erweitert“ klappt MTD(f)/PVS, Normal/Länger, den Spielstil Ausgewogen/Blockierend und Eröffnung Automatisch/Aus direkt darunter auf. Ein separates Einstellungsfenster über der Einrichtung entfällt. Info-Schaltflächen neben den Einstellungen öffnen nur bei Bedarf die Erklärung. Bei großer Schrift und wenig Höhe erhält der Stil einen eigenen Abschnitt innerhalb desselben Blatts, damit die Einrichtung weiterhin ohne Scrollen bedienbar bleibt. Während einer Partie verwendet „Computer einstellen“ dieselben kompakten Bedienelemente; dort übernimmt „Fertig“ den gemeinsamen Entwurf. Eine neue Partie übernimmt die Auswahl mit „Partie beginnen“. Auch während einer Partie kann sie geändert werden, ohne den Spielverlauf zu verlieren. Laufende alte Berechnungen werden abgebrochen und verworfen.

| Stufe | Normal: Tiefe / Budget | Länger: Tiefe / Budget |
| --- | --- | --- |
| 1 | 2 / 150 ms | 4 / 600 ms |
| 2 | 4 / 250 ms | 6 / 1000 ms |
| 3 | 5 / 450 ms | 8 / 1800 ms |
| 4 | 8 / 800 ms | 12 / 2600 ms |
| 5 | 12 / 1200 ms | 16 / 3600 ms |

Tiefe und Zeit sind Suchgrenzen. Der Suchlauf kann früher enden; kooperative Zeitprüfung, Replay und Darstellung ergeben keine garantierte Gesamtantwortzeit. Beide Verfahren verwenden denselben Sanmill-Evaluator und reservieren jeweils 16 MiB Transpositionstabelle. Daraus folgt keine Gleichheit des gesamten Speicherverbrauchs oder der Laufzeit. Ein Vergleich auf echten iOS-Geräten bleibt offen. Die längere Suche erhöht die möglichen Rechenkosten; konkrete Energie- und Stärkegewinne sind noch zu messen.

Die Entwicklung verwendet Spielstand-Schema 2 ohne Migration früherer Schemata. Der zusätzliche Stil wird mit der Partie gespeichert; fehlt das Feld, gilt die bisherige ausgewogene Bewertung. Die getrennte Engine-Schnittstelle kennzeichnet das Suchprofil mit `level_scale: "five"`; ihre alte Dreierskala bleibt ausschließlich zur eindeutigen Wiederholung archivierter Vergleichspläne verfügbar. Auch Vergleichspläne ohne Stil behalten ausdrücklich die bisherige ausgewogene Bewertung.

## Begründung der Auswahl

MTD(f) bleibt die bewährte Voreinstellung dieser App. Der bisherige Vergleich mit PVS begründet keinen Wechsel und keine Aussage, dass beide Verfahren immer gleich effizient seien. Fünf Stufen füllen die großen Lücken zwischen den bisherigen Tiefengrenzen 2, 5 und 12. Die beiden Zwischenstufen verändern tatsächlich Suchverhalten und Ergebnisse. Die Vergleiche sind in `Benchmarks/SPIELSTUFEN-2026-09-30.md` dokumentiert. Die Namen sind vorläufige relative Schwierigkeitsangaben; Tests mit Menschen und auf Geräten folgen vor Veröffentlichung.

## Abgleich der Original-App — 01.10.2026

Der am 01.10.2026 mit `git ls-remote` überprüfte öffentliche HEAD ist weiterhin `8901a06f088bf49a1602fee8686ed25ac5a33925`, also unser importierter Quellstand. Geprüft wurden die Flutter-Einstellungsseiten, englische/deutsche Hilfetexte, die Suche und die tatsächlichen Datenquellen. Die Prüfung erfolgte im Quellcode; eine separat installierte Sanmill-App wurde nicht bedient.

**Entscheidung: fünf Suchprofile beibehalten, Spielstil davon trennen.** Die bisher gemessenen fünf Profile haben zunehmende Tiefen- und Zeitbudgets. Zehn oder dreißig Beschriftungen würden ohne zusätzliche Kalibrierung keine entsprechend vielen nachvollziehbaren Schwierigkeitsgrade schaffen. Sanmill warnt selbst, dass wenig Rechenzeit die Wirkung hoher Stufen begrenzt. Eine spätere Zehnerskala wäre vertretbar, wenn benachbarte Profile über alle vier Varianten und auf Geräten ausreichend unterscheidbar sind. Sie würde Suchbudgets abstufen, nicht nach und nach beliebige Schalter aktivieren.

| Original-Option | Tatsächliche Wirkung / Einschränkung | Entscheidung für Mühlenstein |
| --- | --- | --- |
| 30 Schwierigkeitsstufen | Technischer Suchparameter, abhängig von Zeitlimit, Phase und Suchverfahren; keine gemessene Elo-Skala. | Fünf bereits verglichene Stufen; Stufe 3 bleibt Standard. |
| Bedenkzeit | Obergrenze der Suche; beendet sich ggf. vorzeitig. Original bietet auch unbegrenzte Zeit. | Mit der Stufe automatisch wählen; Normal/Länger weiter manuell möglich. Kein unbegrenzter Lauf. Die sichtbare Denkpause ist davon getrennt. |
| Beweglichkeit | Bewertet verfügbare Wege beider Seiten zusätzlich zur Steinzahl. | Bereits auf allen Stufen aktiv, jetzt ausdrücklich im Adapter festgelegt. Kein zusätzlicher Schalter nötig. |
| „Menschliche Erfahrung“ | Der historische deutsche Text meint adaptive Setzphasen-Suchtiefe. Die aktuelle englische Beschriftung heißt „Use adaptive placement depth“. Kein trainiertes Modell und keine menschliche Partiedatenbank. Die Tabellen können Tiefe begrenzen. | Nicht als stärkesteigernden Zuschlag einschalten. Unsere festen Profile und Zeitgrenzen beibehalten; eine spätere Phasenoptimierung separat auf Qualität und Zeitersparnis prüfen. |
| Auf Wegblockierung fokussieren | Unter bestimmten Bedingungen unterdrückt die Bewertung den Materialterm zugunsten der Beweglichkeit. Das betrifft die Setzphase und bestimmte Stellungen vor dem gegnerischen Springen. Der englische Originaltext warnt ausdrücklich vor schwächeren Zügen. | Als optionaler **Blockierstil** implementiert. **Ausgewogen** bleibt auf jeder Stufe Standard. Kein automatisches Zuschalten auf Stufe 5. |
| Passiv | Begrenzt bei klarem Vorteil die weitere Suchtiefe; kann den schnellsten Gewinn verpassen. | Nicht übernehmen. Kein Stärkegewinn; eine versteckte Abschwächung innerhalb derselben Stufe wäre schwer verständlich. |
| Zufällige Züge | „Vary move selection“ verändert Reihenfolge/Auswahl vergleichbarer Züge. Das ist vom separaten Verfahren „Random“, das einen beliebigen legalen Zug wählt, zu unterscheiden. Zeitbegrenzte Suche kann durch andere Reihenfolge ebenfalls andere Ergebnisse liefern. | Kein automatischer Stärkehebel. Ein späterer Schalter „Abwechslung“ wäre möglich, müsste schwächere Zufallszüge zuverlässig begrenzen und mit Seed reproduzierbar geprüft werden. Derzeit nicht eingebaut. |
| Eröffnungsbuch | Liefert frühe Züge vor der normalen Suche; das aktuelle eingebaute Buch hat eigene Varianten- und Phasengrenzen (Nine Men's Morris / El Filja). Legalitätsprüfung und Rückfall auf Suche sind nötig. | Inzwischen umgesetzt: nur das verfasste klassische Orakel, automatisch auf Stufe 4/5, abschaltbar, mit Legalitätsprüfung und Such-Fallback. Details in `OPENING_AND_DATABASE.md`. |
| Perfekte Datenbank | Liefert bewiesen optimale Züge für abgedeckte Stellungen und exakt passende Regeln. Treffer umgehen weitgehend Stufe und Suchstil; fehlende Sektoren benötigen Such-Fallback. Separater Rust-nativer Leser mit optionalem C++-Vergleich und umfangreichen Datenpaketen, kein einzelnes Boolean in unserem Kern. | Nach konkreter Daten-/Aufwandsprüfung vorerst zurückgestellt, später für einen eigenen Analysemodus bewerten. Nicht als pauschales „Stufe 10 = perfekt“. Unsere Morabaraba-Variante erlaubt Mehrfachabnahme; der geprüfte Datenbank-Regelfilter verbietet sie. Ein passender Name allein genügt deshalb nicht. |
| Fallen-Erkennung | `trapAwareness` markiert Fallen in der datenbankgestützten Analyse. Das ist nicht dasselbe wie die normale Suche nach taktischen Antworten. | Keine versteckte Stärkeoption. Erst zusammen mit einer künftigen Analyse-/Datenbankansicht sinnvoll. |
| Bekannte Fallen vermeiden | Eigenständige Fehlerkorrektur aus einer begrenzten Fallenbibliothek; kann Züge aus Suche oder anderen Quellen ersetzen. Aktuelles Patchformat ist nur für Standard-Mühle vorgesehen; aktives Fallenstellen ist im Original ausgeblendet. | Später separat für exakt passende Regeln prüfen. Nicht variantenübergreifend übernehmen und nicht mit allgemeiner Fallerkennung verwechseln. |
| Menschliche Partiedatenbank | Separate gespeicherte Partien als Zugquelle nach dem Eröffnungsbuch und vor der Suche; zusätzlich zur historischen „Erfahrung“-Option. | Für späteres Eröffnungstraining interessant, aber nicht automatisch stärker. Datenqualität, Regelabdeckung und Verteilbarkeit vor Import prüfen. |
| Sprachmodelle | Optionaler Analysechat über lokalen Ollama-Dienst oder eigenen Proxy; produziert Text. Kein Teil der normalen lokalen Suchschleife. | Für den Offline-Gegner nicht nötig und nicht eingebaut. Eine spätere erklärende Trainerfunktion wäre ein eigenständiges Produktmerkmal. |
| Pondern / mehrere Suchthreads | Rechnet während der gegnerischen Zeit bzw. parallel weiter. Zusätzliche Rechenlast, keine garantierte Verbesserung pro Akkuverbrauch. | Vor den ausdrücklich zurückgestellten Energieprüfungen nicht zuschalten. |

**Was auf jeder Stufe automatisch arbeitet:** korrekte Variantenregeln, Steinzahl- und Beweglichkeitsbewertung, Zugordnung, iterative Vertiefung, Suchspeicher und die vorhandene Erweiterung erzwungener Einzelzüge. Stufe und Rechenzeit setzen den Aufwand. Zusätzliche experimentelle Suchabkürzungen werden nicht allein deshalb aktiviert, weil eine höhere Stufe gewählt wurde; etwa die vereinfachte Nullzug-Abkürzung ist upstream wegen möglicher Fehlentscheidungen standardmäßig deaktiviert.

**Neu eingebaut:** Der originale Blockierparameter wird ausschließlich bei bewusst gewähltem Stil an den unveränderten Sanmill-Kern übergeben. Beide Stile behalten Beweglichkeit. Stellung, erlaubte Züge, Abnahmen, Ergebnis und Wiederherstellung müssen identisch bleiben; nur die Wahl zukünftiger Computerzüge darf sich ändern. Wechsel während einer Suche bricht die alte Berechnung ab. Die Hilfe benennt Empfehlung, Stärke und Schwäche. Die fünf Standardprofile wurden nicht umkalibriert.

Der separate Vergleichsplan `Benchmarks/style-comparison-plan.json` erprobt beide Stile mit Farbtausch auf Stufe 2. Der anschließend festgelegte Plan `Benchmarks/style-confirmation-plan.json` verwendet einen anderen Seed und Stufe 3; die Serien werden nicht zusammengezählt. Die Ergebnisse stehen in `Benchmarks/SPIELSTILE-2026-10-01.md`. Daraus wird weder eine Elo-Zahl noch eine allgemeine Rangfolge über sämtliche Stufen und Stellungen abgeleitet.

### Quellbelege für die Optionen

- [Allgemeine Suchoptionen der Original-App](https://github.com/calcitem/Sanmill/blob/8901a06f088bf49a1602fee8686ed25ac5a33925/src/ui/flutter_app/lib/general_settings/widgets/pages/advanced_ai_search_page.dart) und [aktuelle englische Erläuterungen](https://github.com/calcitem/Sanmill/blob/8901a06f088bf49a1602fee8686ed25ac5a33925/src/ui/flutter_app/lib/l10n/intl_en.arb).
- [Suchstufenauswahl und Zeitwarnung](https://github.com/calcitem/Sanmill/blob/8901a06f088bf49a1602fee8686ed25ac5a33925/src/ui/flutter_app/lib/general_settings/widgets/pickers/skill_level_picker.dart), [adaptive Tiefentabellen](https://github.com/calcitem/Sanmill/blob/8901a06f088bf49a1602fee8686ed25ac5a33925/crates/tgf-mill/src/search_depth.rs), [Bewertung und Blockierbedingungen](https://github.com/calcitem/Sanmill/blob/8901a06f088bf49a1602fee8686ed25ac5a33925/crates/tgf-mill/src/rules/evaluation.rs).
- [Wissensquellen und getrennte Fallenfunktionen](https://github.com/calcitem/Sanmill/blob/8901a06f088bf49a1602fee8686ed25ac5a33925/src/ui/flutter_app/lib/general_settings/widgets/pages/ai_knowledge_sources_page.dart), [Datenbank-Regelfilter](https://github.com/calcitem/Sanmill/blob/8901a06f088bf49a1602fee8686ed25ac5a33925/src/ui/flutter_app/lib/games/mill/mill_perfect_database_support.dart), [Eröffnungsbuch-Anbindung](https://github.com/calcitem/Sanmill/blob/8901a06f088bf49a1602fee8686ed25ac5a33925/src/ui/flutter_app/lib/games/mill/mill_opening_book_provider.dart).
- [Sprachmodell-Analyse](https://github.com/calcitem/Sanmill/blob/8901a06f088bf49a1602fee8686ed25ac5a33925/src/ui/flutter_app/lib/shared/services/llm_service.dart), [Suchoptionen und sichere Voreinstellungen](https://github.com/calcitem/Sanmill/blob/8901a06f088bf49a1602fee8686ed25ac5a33925/crates/tgf-search/src/options.rs).

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
