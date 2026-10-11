# Mühlenstein 1.4.1 · Build 14

Stand: 11.10.2026. Auf Nutzerauftrag eingereichter Release für App Store und
die bestehende externe TestFlight-Gruppe. Die Ausgangsprüfung bestätigt
Version **1.3.1 (11)** als veröffentlicht. **1.4 (13)** ist `IN_REVIEW` und
wartet in TestFlight auf Beta-Freigabe. Der lokale Quellstand `1ac4ccc`
mit abwechslungsreicheren Computerzügen war noch nicht hochgeladen.

## Identität und Umfang

- App `6818139673`, Bundle-ID `org.amosystems.Muehlenstein`, iOS.
- Neue Version **1.4.1**, Build **14**, annotierter Tag **v1.4.1**.
- Die Computerentscheidung variiert die Suchreihenfolge und die Auswahl
  empfohlener Buchzüge. Bewertung, Suchbudgets und Stufengrenzen bleiben
  erhalten; Tipps sind von der Variation ausgenommen.
- Enthält außerdem die noch nicht veröffentlichte grafische Rückschau,
  Hilfen-Protokollierung und Abschlusskarte aus 1.4.
- [Änderungen](../CHANGELOG.md), [Vergleich und Grenzen](../Docs/Benchmarks/ZUGVARIATION-2026-10-11.md).

## Vorbereitung

Version und Build werden in `Configuration/App.xcconfig` gepflegt. Der
bestehende Versionsanzeige-Test erwartet 1.4.1 (14). Acht kanonische
Versionshinweise liegen unter `metadata/version/1.4.1/`, die acht
Testanleitungen unter `Store/TestFlight-1.4.1.json`.

Archiv: `.build/Archives/Muehlenstein-1.4.1-14.xcarchive`.
IPA und lokale Nachweise: `.build/Release-1.4.1-14/`.

Die vorhandene lokale Umsortierung in `project.pbxproj` ist strukturell
identisch mit dem eingecheckten Projekt. Sie bleibt ebenso wie persönliche
Werkzeugkonfigurationen außerhalb dieses Release-Commits.

## Bestätigte Prüfungen

- **319 Rust-Prüfungen bestanden:** 31 Schnittstellen-/Variationsprüfungen
  und 288 unveränderte Upstream-Bibliothekstests.
- **46 Release-App-Prüfungen bestanden:** 42 funktionale Modelltests sowie
  vier UI-Abläufe für Version/Lizenzen, Computerantwort/Rücknahme,
  grafische Rückschau und gespeicherte Spielhilfen. Projekt-iPhone
  `4B91CD4C-CBD0-4993-85D7-2FA995662B84`, iOS 27.
- Signiertes Gerätearchiv und App-Store-IPA erfolgreich. Bundle-ID,
  Version/Build, Distributionssignatur ohne Debugging-Berechtigung,
  acht Sprachressourcen, Privacy Manifest, Bonjour und systembasierte
  Verschlüsselung sind im exportierten IPA geprüft.
- IPA-SHA-256: `297e970c60a37f6165524dbee2c0ee9a717cca2f2d6c0330f5afa8c50d9ff259`.
- 230 Textschlüssel in acht Sprachen, vollständiges Lizenzinventar und
  kanonische Metadaten geprüft; keine Metadatenfehler oder Warnungen.
- Alle 80 vorhandenen Original-Screenshots bei Apple sind `COMPLETE`;
  Dateireihenfolge, Abmessungen und Prüfsummen stimmen überein. Die
  unveränderte Oberfläche benötigt für diesen Release keine neuen Motive.

Keine erneute physische Zwei-Geräte-WLAN-, VoiceOver- oder Akkuprüfung.
Die Such-/Partieprüfungen belegen keine exakt gleiche menschliche Spielstärke.

## Distribution

| Kanal | Von Apple bestätigter Stand am 11.10.2026 |
| --- | --- |
| App Store | **WAITING_FOR_REVIEW**, eingereicht um **18:40:52 Uhr (Europe/Berlin)** |
| Veröffentlichung | **AFTER_APPROVAL**, automatisch nach Freigabe |
| TestFlight extern | **WAITING_FOR_BETA_REVIEW**, eingereicht um **18:41:09 Uhr (Europe/Berlin)** |
| Tester | **Externe Tests**, drei Tester, Build-Zuordnung bestätigt, `autoNotifyEnabled = true` |
| Bereits veröffentlicht | **1.3.1 (11)** bleibt im App Store verfügbar |

Build 14 ist als `VALID` verarbeitet. App-Store- und TestFlight-Validierung
melden jeweils **0 Fehler, 0 Warnungen, 0 Blocker**. Den informativen
App-Privacy-Hinweis deckt die öffentliche Apple-Seite mit **Keine Daten
erfasst** ab; die Datenverarbeitung hat sich nicht geändert. Alle acht
Versionslokalisierungen und Testanleitungen sind bei Apple gespeichert und
erneut mit den kanonischen Dateien abgeglichen.

- Build-ID und Beta-Einreichung: `45c1b8fb-6f0b-40d7-b8a8-3fb8b2639c63`.
- App-Store-Version: `fb6a5be1-03a5-48c1-8d96-b5d486cbd729`, mit Build 14 verknüpft.
- App-Store-Einreichung: `8de01bf4-8894-445b-b50c-58fc48878ca7`, genau eine App-Version.
- Apple-Einreichungszeit: `2026-10-11T16:40:52.39Z`.
- Beta-Einreichungszeit: `2026-10-11T09:41:09-07:00`.
- Gruppe: `d6665987-bb28-44ae-9306-0125eda4801e`.

Die bisherige App-Store-Einreichung von 1.4 (13) wurde für diesen neueren
Quellstand zurückgezogen. Nach Bestätigung durch Apple wurde der vorhandene
Versionsdatensatz auf 1.4.1 umgestellt und Build 14 angehängt. Dadurch bleiben
die 80 geprüften Screenshots erhalten. Die frühere Einreichung ist beendet;
es besteht genau eine aktive App-Store-Einreichung. Ältere TestFlight-Builds
wurden nicht beendet. Preise, Länderverfügbarkeit und Testerkreis bleiben
unverändert.

**Build 14 ist noch nicht öffentlich oder extern installierbar.** Beide
Apple-Freigaben stehen aus. Store-Veröffentlichung und Testerbenachrichtigung
erfolgen nach der jeweiligen Freigabe automatisch.

Quellcommit **e2ea4616a012f5c3bdf0d2a1b8c6bc98f8492e51** und Tag **v1.4.1**
sind auf `origin` verifiziert. Alle **196 erfassten Quelldateien** stimmen
mit dem Archivierungsstand überein; das Xcode-Projekt wurde dabei zusätzlich
strukturell verglichen. Keine temporären Simulatoren angelegt.

## Status erneut prüfen

```sh
asc review status --app 6818139673 --version 1.4.1 --platform IOS
asc review submissions-get --id 8de01bf4-8894-445b-b50c-58fc48878ca7
asc testflight distribution view --build-id 45c1b8fb-6f0b-40d7-b8a8-3fb8b2639c63
asc testflight review submissions view --id 45c1b8fb-6f0b-40d7-b8a8-3fb8b2639c63
```

Letzte API-Bestätigung: `2026-10-11T16:42:55+00:00`.
