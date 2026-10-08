# Mühlenstein 1.3.1 · Build 11

Stand: 08.10.2026. Neuer Release auf Nutzerauftrag für App Store und die
bestehende TestFlight-Gruppe. Er enthält den lokalen WLAN-Modus, den
bewusst fehlbaren Anfängergegner und die Einrichtung mit gleichbleibender Höhe.

## Identität und Quellstand

- App `6818139673`; Bundle-ID `org.amosystems.Muehlenstein`; iOS.
- Version **1.3.1**, Build **11**, Quelltag **v1.3.1**.
- App-Store-Versions-ID `00c0176b-7d42-4a48-914d-9ae5f26f93cf`.
- Archiv `.build/Archives/Muehlenstein-1.3.1-11.xcarchive`.
- IPA `.build/Release-1.3.1-11/Muehlenstein-1.3.1-11.ipa`.

## Validierung

Der Produktcode entspricht dem geprüften Build 10; nur Versions- und
Buildnummer in `Configuration/App.xcconfig` wurden geändert. Alle 191
Produktdateien wurden per SHA-256 abgeglichen. Build 10 bestand 41 Tests
auf iPhone und einen Screenshotablauf auf iPad sowie 27 Rust-Adaptertests
und 288 Tests der zugrunde liegenden Sanmill-Engine. Acht Sprachfassungen,
212 Textschlüssel und das vollständige Lizenzinventar sind geprüft.
Die Versions- und Lizenzanzeige wird zusätzlich für Build 11 geprüft.

80 aktuelle Original-Screenshots zeigen je fünf Motive in acht Sprachen
und zwei Geräteklassen. Alle acht Kontaktbögen wurden gesichtet. Die
Versionsanzeige ist auf diesen Motiven nicht zu sehen; der gezeigte
Produktcode ist zwischen Build 10 und Build 11 identisch.

Der separate Versionszweig 1.3.1 vermeidet den Konflikt mit der laufenden
TestFlight-Prüfung von 1.3 (9). Apple erlaubt nur einen Build je Version
in Beta Review. Die vorherige App-Store-Einreichung von Build 9 ist
zurückgezogen. Kein älterer TestFlight-Build wurde ablaufen gelassen.
[Nachweise des Zwischenbuilds 10](RELEASE-1.3-10.md).

Die bestehende Gruppe **Externe Tests** enthält drei Tester; die
Gruppen-ID ist `d6665987-bb28-44ae-9306-0125eda4801e`.
Aktuelle Apple-Statuswerte werden nach der Einreichung ergänzt.

Die physische Netzwerk-Testabdeckung aus [Build 9](RELEASE-1.3-9.md)
gilt weiter. Es wurde kein zusätzlicher Zwei-iPhone-Spieltest durchgeführt.
Lokale Nachweise: `.build/Release-1.3.1-11/` und `.build/Release-1.3-10/`.
