# Mühlenstein 1.5 · Build 17

## iPhone Duo

In Buch- und Laptopstellung ordnet das Spiel Brett und Bedienelemente auf
den beiden Seiten der Falz an. In Buchstellung sitzt die Bediengruppe auf Höhe der Brettmitte.
Die Rückschau verwendet dieselbe Aufteilung.
Auf der Startseite erhalten Illustration und Aktionen jeweils einen eigenen
Bereich. Das Spiel zeigt die Ergebniskarte samt Schaltfläche auf einer Seite.
Die App nutzt die von SwiftUI für die aktuelle Ansicht gemeldete Falz und
unterstützt weiterhin iOS 18 und neuer.

Bei geschlossenem Gerät wandern die Spielaktionen in die rechte Systemleiste.
Dort lassen sich ein Zug zurücknehmen, ein Tipp abrufen und der Verlauf öffnen.
Die Rückschau bietet die vier Sprünge zum Anfang, zum vorherigen Zug,
zum nächsten Zug und zum Ende. Der Schieberegler bleibt beim Brett.

## Build und Store-Bilder

Das signierte App-Store-Archiv wurde mit dem iOS-27.2-SDK erstellt.
Das exportierte IPA enthält alle acht Sprachen und das Privacy Manifest.
Seine SHA-256-Prüfsumme lautet `304778c2800202877d895bd397e14ff2c19525196ebf7931633c0d38e04f0a19`.

Für jede der acht Store-Sprachen gibt es zwei neue Aufnahmen aus dem
iPhone-Duo-Simulator. Das Innendisplay zeigt eine Partie in Buchstellung
(2853 × 2007 Pixel), das Außendisplay die Partie mit den Aktionen in der
Systemleiste (1398 × 2034 Pixel).
Die 80 vorhandenen iPhone- und iPad-Bilder wurden übernommen.
[Dateien und Prüfsummen der Duo-Bilder](Screenshots/duo-manifest.json).

Apple hat alle 96 Screenshots verarbeitet. Reihenfolge und MD5-Prüfsummen
stimmen mit dem Repository überein. Der Quelltag `v1.5` verweist auf
`d37563abf836d85b34c40102090f4342a63925fa`. Die 196 archivierten Quell-
und Builddateien stimmen mit diesem Stand überein. [Validierung](../Docs/VALIDATION.md).

## TestFlight

Apple nahm Build `606b46d7-247f-4b2b-a0bb-28e8f64395be` am 24.11.2026
um 11:40:54 Uhr MEZ zur externen Beta-Prüfung an (`WAITING_FOR_BETA_REVIEW`).
Der Build ist der Gruppe „Externe Tests“ mit drei Mitgliedern zugewiesen.
Apple benachrichtigt sie nach der Beta-Freigabe automatisch.

## Veröffentlichung

Apple hat Version 1.5 (17) am 24.11.2026 um **11:49:24 Uhr MEZ** zur
App-Store-Prüfung angenommen. Version und Übermittlung melden
`WAITING_FOR_REVIEW`. Die Veröffentlichung erfolgt nach Apples Genehmigung
automatisch (`AFTER_APPROVAL`). Die vorherige Version **1.4.1 (14)** war
beim Abgleich im Store verfügbar.

| App-Store-Datensatz | Kennung |
| --- | --- |
| App | `6818139673` |
| iOS-Version | `d81ac7b2-13a1-44d7-8b0b-72f11172f3ff` |
| App-Review-Übermittlung | `13bf7834-65da-447b-8686-1b80e37451b1` |

Vier bereits im jeweiligen Untertitel enthaltene Suchbegriffe wurden aus
den Keyword-Feldern entfernt. Die abschließende Blitz-Prüfung meldete
0 Warnungen, 0 offene Prüfpunkte und 0 Blocker.
