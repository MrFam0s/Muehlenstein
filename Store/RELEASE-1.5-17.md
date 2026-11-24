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

## Veröffentlichung

Vorbereitung für App Store Connect unter App `6818139673`, iOS-Version
`d81ac7b2-13a1-44d7-8b0b-72f11172f3ff`. Vorgesehen ist die automatische
Veröffentlichung nach Freigabe durch Apple. Am 24.11.2026 bestätigte Apple
1.4.1 (14) als veröffentlichte Vorgängerversion.
