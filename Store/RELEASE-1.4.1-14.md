# Mühlenstein 1.4.1 · Build 14

Stand: 11.10.2026. Auf Nutzerauftrag vorbereiteter Release für App Store und
die bestehende externe TestFlight-Gruppe. Die Ausgangsprüfung bestätigt
Version **1.3.1 (11)** als veröffentlicht. **1.4 (13)** ist `IN_REVIEW` und
wartet in TestFlight auf Beta-Freigabe. Der lokale Quellstand `1ac4ccc`
mit abwechslungsreicheren Computerzügen war noch nicht hochgeladen.

## Identität und Umfang

- App `6818139673`, Bundle-ID `org.amosystems.Muehlenstein`, iOS.
- Neue Version **1.4.1**, Build **14**, vorgesehener annotierter Tag **v1.4.1**.
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

Die Veröffentlichung und TestFlight-Verteilung sind in Vorbereitung.
Dieses Protokoll wird nach Prüfung und Apple-Einreichung mit den tatsächlich
bestätigten Zuständen und Kennungen ergänzt.
