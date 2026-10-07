# Mühlenstein 1.2 · Build 8

Aktualisierung 07.10.2026: **Version 1.2 (8) ist veröffentlicht.**
Apple bestätigt `READY_FOR_DISTRIBUTION` / `READY_FOR_SALE`.
Die folgenden Abschnitte bewahren den Einreichungsnachweis vom 06.10.2026.

Stand der ursprünglichen Einreichung: 06.10.2026. Veröffentlichung und Bereitstellung für die bestehenden
Tester wurden vom Nutzer beauftragt. Build 8 ist hochgeladen und von Apple
als `VALID` verarbeitet. **App-Store- und TestFlight-Beta-Prüfung sind
eingereicht. Beide warten noch auf Apples Freigabe.**

## Apple-Ziele

- App: `6818139673`; Bundle-ID: `org.amosystems.Muehlenstein`; Plattform: iOS.
- Version: **1.2**; Versions-ID: `78ec4878-594b-4774-9fb7-a79eb9a2b640`.
- Build: **8**; Build-/Beta-Review-ID: `38cb613d-db9e-4687-ace0-fcf0b97aeaa2`.
- App-Info für die neue Version: `67174397-be05-4bb3-8456-783c7fbad88a`.
- Veröffentlichung: **automatisch nach Apple-Freigabe** (`AFTER_APPROVAL`).
- Die bisherige Store-Version **1.0.2 (6)** ist `READY_FOR_DISTRIBUTION`.

## App Store

Am **06.10.2026, 19:16:42 Uhr (Europe/Berlin)** eingereicht,
entsprechend `2026-10-06T17:16:42.447Z`.

- Einreichungs-ID: `5dfe3873-caa3-4ec0-975a-dea68ee21561`.
- Version und Einreichung erneut abgefragt: **`WAITING_FOR_REVIEW`**.
- Build 8 ist angehängt; genau ein Review-Element für die neue App-Version.
- Automatische Veröffentlichung nach Freigabe (`AFTER_APPROVAL`).
- Abschließende strikte Validierung: **0 Fehler, 0 Warnungen, 0 Blocker**.
  Der allgemeine API-Hinweis zu App Privacy ist durch die öffentlich sichtbare
  Angabe „Keine Daten erfasst“ geprüft.

## TestFlight

- Gruppe **Externe Tests**, `d6665987-bb28-44ae-9306-0125eda4801e`.
- Zwei bestehende Tester; Buildzuordnung erneut über Apples API bestätigt.
- Beta-Prüfung am **06.10.2026, 19:03:13 Uhr (Europe/Berlin)** eingereicht,
  entsprechend `2026-10-06T17:03:13Z`.
- Bestätigter Zustand: `WAITING_FOR_BETA_REVIEW`; Beta-Review `WAITING_FOR_REVIEW`.
- Automatische Testerbenachrichtigung aktiv (`autoNotifyEnabled: true`).
- Beschreibungen und Testhinweise in acht Sprachfassungen gespeichert und
  erneut ausgelesen. Externe Installation wartet auf Apples Freigabe.

## Sprachfassungen und Screenshots

Name, Untertitel, Beschreibung, Keywords, Werbetext, Versionshinweise,
Support- und Datenschutz-URL sind für `de-DE`, `en-US`, `fr-FR`, `es-ES`,
`ja`, `ko`, `zh-Hans` und `zh-Hant` gespeichert. Alle 16 kanonischen
Metadatendateien stimmen feldgenau mit Apple überein. Die englischen Keywords
enthalten jetzt ausdrücklich **`nine men's morris`**. Zuvor stand der
Spielname bereits im Untertitel, jedoch nicht im Keyword-Feld.
[Sprachprüfung mit Keyword-Übersicht](METADATA-1.2-AUDIT.md).

64 neue Original-Screenshots aus Version 1.2 (8): vier Motive je Sprache
und Gerät (iPhone 6,9 Zoll sowie iPad 13 Zoll). Kein Retuschieren oder Framing.
Abmessungen: 1320 × 2868 beziehungsweise 2064 × 2752, RGB ohne Alphakanal.
Alle acht Kontaktbögen wurden gesichtet. Alle 64 Bilder sind bei Apple
`COMPLETE`; Reihenfolge, Dateinamen, Abmessungen und MD5-Prüfsummen
stimmen mit den lokalen Originalen überein. Der iPad-Systemstatusbereich folgt
weiterhin der deutschen Simulatorsprache; die App selbst ist lokalisiert.
Die alten Screenshots der veröffentlichten Version 1.0.2 bleiben bei Apple
unverändert; die neuen Sets gehören zur Version 1.2.

## Artefakte und Prüfungen

- Quelltag **v1.2**, Commit `9833b220399d8e8b580844ae6f60eac2077d3035`;
  lokaler Stand und öffentlicher Git-Tag abgeglichen. App, Engine, Ressourcen,
  Konfiguration und Projekt für das Gerätearchiv entsprechen diesem Tag.
- Archiv `.build/Archives/Muehlenstein-1.2-8.xcarchive` und IPA
  `.build/Release-1.2-8/Muehlenstein-1.2-8.ipa` erfolgreich erstellt.
- Exportierte App: strikte Codesign-Prüfung bestanden; Team `4WHV5UZ8E5`,
  `get-task-allow = false`, `beta-reports-active = true`.
- Version, Build, Bundle-ID, Datenschutzmanifest, Lizenzressourcen und alle
  acht eingebauten Lokalisierungen am tatsächlichen IPA geprüft.
  `ITSAppUsesNonExemptEncryption = false`.
- IPA-SHA-256:
  `ef5c49e5a34eb9a30f3877758cb961ad9d47a08869cc7f50f0df4f727012c3bf`.
- Die drei vorhandenen Release-Prüfungen in `.build/Version-1.2-Checks.xcresult`
  bestanden. Neue Screenshot-Läufe auf iPhone und iPad ebenfalls bestanden,
  mit vollständiger Abdeckung aller 64 Motive. Test-/Exportscript auf acht
  Sprachfassungen erweitert; keine Änderung der Produktlogik.
- `asc metadata validate`: keine Fehler oder Warnungen. Support und Datenschutz
  öffentlich ohne Anmeldung mit HTTP 200 erreichbar.
- Öffentliche App-Store-Seite bestätigt **Keine Daten erfasst**. Preis und
  Länderverfügbarkeit wurden nicht geändert.

## Lokale Nachweise und Statusabfrage

Alle Upload-, Metadaten-, TestFlight-, Screenshot- und Review-Nachweise liegen
unter `.build/Release-1.2-8/`. Kurzzeitig meldete Apple beim Staging einen
Serverfehler beim Lesen von Abogruppen; der Build war bereits korrekt angehängt.
Die abschließende Validierung bestand; erst danach wurde eingereicht.
Der erste Metadatenlauf erzeugte App-Info-Sprachen und damit leere
Versionslokalisierungen; die verbleibenden Felder wurden über explizite
Versions-Updates vervollständigt und anschließend erneut abgeglichen.

```sh
asc versions view --version-id 78ec4878-594b-4774-9fb7-a79eb9a2b640 --include-build --include-submission
asc review submissions-get --id 5dfe3873-caa3-4ec0-975a-dea68ee21561
asc testflight distribution view --build-id 38cb613d-db9e-4687-ace0-fcf0b97aeaa2
asc testflight review submissions list --build-id 38cb613d-db9e-4687-ace0-fcf0b97aeaa2
```
