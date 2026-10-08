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
- IPA-SHA-256 `c9759a16954831627d9f3ed39e975ce28c5530462d014a60fd1b6c2b15774a20`.
- Signatur, Distributionsentitlements, Identität, acht Sprachressourcen und
  Netzwerk-/Verschlüsselungsangaben erneut am exportierten IPA bestätigt.

## Validierung

Der Produktcode entspricht dem geprüften Build 10; nur Versions- und
Buildnummer in `Configuration/App.xcconfig` wurden geändert. Alle 191
Produktdateien wurden per SHA-256 abgeglichen. Build 10 bestand 41 Tests
auf iPhone und einen Screenshotablauf auf iPad sowie 27 Rust-Adaptertests
und 288 Tests der zugrunde liegenden Sanmill-Engine. Acht Sprachfassungen,
212 Textschlüssel und das vollständige Lizenzinventar sind geprüft.
Zwei zusätzliche Prüfungen der Versions- und Lizenzanzeige für Build 11
sind bestanden. Insgesamt 44 Release-Prüfungen ohne Fehler oder
übersprungene Tests.

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
Die Gruppenzuordnung wurde bei Apple erneut bestätigt.

## Bestätigte Einreichungen

- Build-ID **`9ca58604-4ffb-4b8e-8a11-c8402a52512a`**, Verarbeitung **`VALID`**.
- App Store: **`WAITING_FOR_REVIEW`**, eingereicht am **08.10.2026,
  09:25:09 Uhr (Europe/Berlin)**, entsprechend `2026-10-08T07:25:09.26Z`.
- Einreichungs-ID **`dad57a98-9f8d-4ca7-8629-e2fe2ec3b78e`**; genau eine
  App-Version, verifizierte Zuordnung zu Build 11.
- Veröffentlichungsmodus **`AFTER_APPROVAL`**: automatisch nach Apple-Freigabe.
- TestFlight: **`WAITING_FOR_BETA_REVIEW`**, eingereicht am **08.10.2026,
  09:24:05 Uhr (Europe/Berlin)**. Beta-Einreichungs-ID entspricht der Build-ID.
- Gruppe **Externe Tests**, drei Tester, **`autoNotifyEnabled = true`**.
  Der Build ist vor Apples Beta-Freigabe noch nicht extern installierbar.
- Strikte Einreichungsprüfungen für App Store und TestFlight: **0 Fehler,
  0 Warnungen, 0 Blocker**. Der informative App-Privacy-Hinweis wurde anhand
  der veröffentlichten Apple-Store-Seite (Keine Daten erfasst) geprüft.
- Alle 16 kanonischen Metadatendateien und acht Testhinweise erneut mit
  Apple abgeglichen. Alle 80 Screenshots sind **`COMPLETE`**; Reihenfolge,
  Abmessungen und MD5-Prüfsummen stimmen mit den Originaldateien überein.
- Preise, Länderverfügbarkeit und Testerkreis unverändert.
- Quelltag `v1.3.1` zeigt auf `36d3f27d7e0acb60ec0f11c35ac34d3bdaf54d94`;
  alle 191 Produktdateien stimmen mit dem archivierten Quellmanifest überein.

## Status prüfen

```sh
asc review status --app 6818139673 --version 1.3.1 --platform IOS
asc review submissions-get --id dad57a98-9f8d-4ca7-8629-e2fe2ec3b78e
asc testflight distribution view --build-id 9ca58604-4ffb-4b8e-8a11-c8402a52512a
asc testflight review submissions list --build-id 9ca58604-4ffb-4b8e-8a11-c8402a52512a
```

Die physische Netzwerk-Testabdeckung aus [Build 9](RELEASE-1.3-9.md)
gilt weiter. Es wurde kein zusätzlicher Zwei-iPhone-Spieltest durchgeführt.
Lokale Nachweise: `.build/Release-1.3.1-11/` und `.build/Release-1.3-10/`.
