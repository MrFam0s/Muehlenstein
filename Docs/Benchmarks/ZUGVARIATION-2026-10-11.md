# Zugvariation — Vergleich vom 11.10.2026

Die neue Computerzugwahl verwendet die vorhandene Sanmill-Suche mit
veränderlicher Zugreihenfolge und wechselnden legalen Orakelempfehlungen.
Bewertung, Stufenbudgets und Suchspeicher bleiben gleich. Die Prüfung soll
unerwünschte Abschwächung und erneut festgelegte Zugfolgen erkennen; sie
liefert keine menschliche Spielstärkewertung.

## Gleiche Suchtiefe

`Engine/src/variation_tests.rs` wählt 68 unterschiedliche Stellungen aus den
18 bestehenden Referenzpartien. Die Auswahl umfasst frühe und spätere
Setzstellungen, Ziehen/Springen und Abnahmen in allen vier Varianten.
Eine Suche mit vollständigem Wurzelfenster liefert die Referenzwerte der Züge.
MTD(f) und PVS werden jeweils mit acht verschiedenen Seeds bis Tiefe 3 gerechnet,
für Ausgewogen und Blockierend. Es gibt bei diesem Vergleich keine Zeitgrenze.

**2.176 Vergleiche bestanden:** Der beste Wert stimmt überein und der gewählte
Zug gehört zur Menge der besten Referenzzüge. 65 Kombinationen aus Stellung und
Spielstil haben nur einen besten Zug; dieser wird bei jedem Seed beibehalten.
Die Prüfung ist auf diese Stellungen und Tiefe begrenzt, kein Beweis für alle
Suchbäume oder zeitbegrenzten Antworten.

Die Bridge-Prüfungen zeigen zusätzlich mehrere Eröffnungszüge auf Stufe 2/3
in allen Varianten und für beide Suchverfahren. Nach dem identischen ersten
Menschenzug `a7` ergeben 16 Seeds ebenfalls unterschiedliche Antworten.
Auf Stufe 4/5 variiert die Buchantwort nach `b4`; Hinweise bleiben gleich.
Alle 437 Buchkandidaten bleiben unter allen 16 Symmetrien legal. Die tatsächlich
ausgewählten Buchzüge sind bei jeder der 1.744 Stellungen für 16 Seeds in der
originalen Empfehlungsliste enthalten (27.904 Auswahlen).

## Vergleichspartien

Vorab festgelegter [Plan](varied-play-plan.json): 16 zufällig erzeugte
Eröffnungspaare je Variante mit Farbtausch, insgesamt **128 Partien**.
Spieler A verwendet variierte Suchreihenfolge mit festem Audit-Seed, B die
bisherige feste Reihenfolge. Beide spielen MTD(f), Stufe 3, Normal, Ausgewogen.
Das Eröffnungsbuch ist in dieser Suchprofilserie nicht aktiv. Sämtliche
Antworten durchlaufen die produktive JSON-/C-Schnittstelle und Legalitätsprüfung.

| Variante | A gewinnt | Remis | B gewinnt | A-Punkteanteil |
| --- | ---: | ---: | ---: | ---: |
| Klassisch | 9 | 13 | 10 | 48,4 % |
| Zwölfstein | 14 | 1 | 17 | 45,3 % |
| Morabaraba | 13 | 1 | 18 | 42,2 % |
| Lasker | 12 | 9 | 11 | 51,6 % |

Alle 128 Partien enden regulär, ohne Fehler oder Abbruch an der Aktionsgrenze.
Keines der 64 Farbwechselpaare hat identische komplette Zugfolgen. Alle
Suchentscheidungen beider Spieler schließen Tiefe 5 ab. Die Streuung dieser
kleinen Serie lässt weder eine klare Stärkeänderung noch Gleichwertigkeit
belegen; die paarweise berechneten konservativen Unsicherheitsintervalle sind
in `summary.json` enthalten. Die verschiedenen Spielverläufe sind zudem keine
passende Grundlage für einen direkten Geschwindigkeits- oder Energietest.

## Nachweise und Wiederholung

Rohpartien, Eröffnungen, Ergebnisse und Prüfsummen:
[`2026-10-11-zugvariation/`](2026-10-11-zugvariation/).
`games.jsonl.gz` enthält vollständige Züge und Suchmesswerte. `provenance.json`
enthält Prüfsummen von Adapter, Datenherkunft, Vergleichswerkzeugen und Binary;
sämtliche importierten Sanmill-Dateien wurden gegen ihr Manifest geprüft.

```sh
bash Scripts/compare-search.sh Docs/Benchmarks/varied-play-plan.json .build/Variation-Recheck
CARGO_HOME="$PWD/.build/cargo" RUSTC="$PWD/.build/rust-sysroot/bin/rustc" CARGO_PROFILE_RELEASE_STRIP=none /opt/homebrew/bin/cargo test --manifest-path Engine/Cargo.toml -p muehlenstein-engine --offline --release variation_tests -- --nocapture
```

Die Partieauswahl und Seeds sind reproduzierbar; Laufzeiten hängen vom Rechner
ab. Hostprüfung auf dem Mac, keine neue iPhone-Energie- oder Elo-Messung.
Die App-Anbindung ist zusätzlich mit 44 Release-Funktionstests im iPhone-Simulator
geprüft. [Vollständiger Validierungsstand](../VALIDATION.md).
