# Mühlenstein 1.3 · Build 9

**Nachtrag vom 08.10.2026:** Diese App-Store-Einreichung wurde zugunsten
von [1.3.1 (Build 11)](RELEASE-1.3.1-11.md) zurückgezogen. Eine inzwischen
separat angelegte TestFlight-Beta-Prüfung für Build 9 bleibt davon unabhängig.
Die folgenden Statuswerte dokumentieren die ursprüngliche Einreichung.

Stand: 08.10.2026. Der Nutzer hat die Veröffentlichung des neuesten Standes
beauftragt. Version 1.2 (8) ist bereits veröffentlicht; Version 1.3 (9)
enthält zusätzlich den lokalen WLAN-Spielmodus. **Am 08.10.2026 um
00:16:57 Uhr (Europe/Berlin) zur App-Store-Prüfung eingereicht; bestätigter
Status: `WAITING_FOR_REVIEW`.**

## Apple-Ziel und aktueller Stand

- App: `6818139673`; Bundle-ID `org.amosystems.Muehlenstein`; iOS.
- Version: **1.3**; ID `00c0176b-7d42-4a48-914d-9ae5f26f93cf`.
- Buildnummer: **9**; Build-ID `607206c3-1ad1-4462-8e28-3db95811afe8`.
- Upload: `607206c3-1ad1-4462-8e28-3db95811afe8`, bei Apple bestätigt;
  erfolgreich als **`VALID`** verarbeitet.
- Version angelegt mit **automatischer Veröffentlichung nach Freigabe**
  (`AFTER_APPROVAL`). Version und Einreichung sind **`WAITING_FOR_REVIEW`**.
- Einreichungs-ID: `8044e4a0-0a93-4ca4-bc1c-eac57e6b57ad`; Zeitstempel
  `2026-10-07T22:16:57.321Z`. Genau eine neue App-Version in der Einreichung.
- Bestehende Preise und Länderverfügbarkeit wurden nicht geändert.
- Abschlussprüfung mit `asc validate --strict`: **0 Fehler, 0 Warnungen,
  0 Blocker**. Der allgemeine Privacy-Hinweis ist über die öffentliche
  Store-Seite bestätigt.
- Alle acht Store-Texte und App-Info-Sprachfassungen mit Apple abgeglichen.
  Beschreibung, Werbetext und Versionshinweise erklären den WLAN-Modus.
- Review-Kontakt übernommen, Review Notes um die genaue Einrichtung auf
  zwei Geräten, lokale Netzwerkberechtigung und Wiederverbindung ergänzt.

## Vollständiger Quellstand

Quelltag [`v1.3`](https://github.com/MrFam0s/Muehlenstein/tree/v1.3),
Commit `6b9a60dfbed4a538a28c9f8ba317db398705d93c`, öffentlich veröffentlicht.
Alle 190 erfassten Dateien aus App, Konfiguration, Engine, Lokalisierung,
Buildskripten und Xcode-Projekt stimmen mit dem Release-Quellmanifest überein.
Öffentliche Support-, Datenschutz- und Konfigurationsdateien am Tag abgeglichen.
Die öffentliche App-Store-Seite bestätigt weiterhin **Keine Daten erfasst**.

## Binärartefakt

- Archiv: `.build/Archives/Muehlenstein-1.3-9.xcarchive`.
- IPA: `.build/Release-1.3-9/Muehlenstein-1.3-9.ipa`.
- SHA-256: `74fd51fafcb61e2681e53f0b94ecc0ce12ba9fbdff3207d54c4d9c1dd1219e77`.
- Exportierte App: Version 1.3, Build 9, erwartete Bundle-ID und Team
  `4WHV5UZ8E5`; strikte Codesign-Prüfung bestanden.
- Distribution mit `get-task-allow = false`, `beta-reports-active = true`.
- Acht Lokalisierungen, lokalisierte Netzwerkberechtigung, Bonjour-Dienst
  `_muehlenstein._tcp`, Datenschutzmanifest und Lizenzinventar geprüft.
- Ausschließlich Systemverschlüsselung: `ITSAppUsesNonExemptEncryption = false`.
- Produktlogik entspricht dem Netzwerk-Commit `3f3fde7`; für diesen Release
  werden Versions-/Buildnummer, Dokumentation und Screenshotablauf angepasst.

## Prüfungen und Geräteabdeckung

Die vorhandenen Netzwerk-Nachweise vom 07.10.2026 umfassen 37 funktionale
Tests und den erfolgreichen echten Datenaustausch zwischen FA-iPhone und
einem iPad-Simulator: Einladung, Zugwechsel, Mühle, Schlagen, Trennung und
Wiederverbindung nach App-Neustart. Siehe [Validierung](../Docs/VALIDATION.md).

Der zusätzliche Test auf zwei physischen iPhones konnte wegen gesperrter
Geräte (FA-iPhone und LA-iPhone) nicht starten; die wartenden Testprozesse
wurden beendet. Der Nutzer hat am 08.10.2026 ausdrücklich angewiesen,
trotz der jetzt nicht möglichen Geräteprüfung zu veröffentlichen.
Die Einreichung stützt sich auf den bestandenen realen
iPhone-/Simulator-Verbindungstest und die erneut bestandenen Release- und
Protokolltests. Keine erfolgreiche Zwei-iPhone-Prüfung behauptet. Rollentausch, längere Funkunterbrechungen,
Gastnetze und widerrufene Netzwerkberechtigungen bleiben zusätzliche
Geräteabdeckung. Lokale Nachweise liegen unter `.build/Release-1.3-9/`.

Neue Release-Prüfungen bestanden: 41 Tests auf iPhone (39 GameStore-Tests,
Versions-/Anbieter-/Lizenznavigation und Screenshotablauf) sowie der vollständige
Screenshotablauf auf iPad. Keine Fehler und keine übersprungenen Tests.
80 neue Original-Screenshots: je fünf Motive in acht Sprachen und zwei
Geräteklassen. Alle 16 Kontaktbögen wurden gesichtet; RGB ohne Alpha,
1320 × 2868 bzw. 2064 × 2752, Dateiabdeckung und Prüfsummen geprüft.
Alle 80 Bilder sind bei Apple **`COMPLETE`**. Dateinamen, Reihenfolge,
Abmessungen und MD5-Prüfsummen sind nach dem Upload erneut abgeglichen.
Die älteren Screenshots der veröffentlichten Version 1.2 bleiben unverändert.

Die Metadatenvalidierung besteht ohne Fehler oder Warnungen; alle 212
Textschlüssel in acht Sprachen und die vollständigen Lizenzhinweise sind geprüft.

## Ausführung und lokale Nachweise

Die Staging-Vorschau stimmte mit Version 1.3 und Build 9 überein. Der Build
wurde zugeordnet, die Metadaten waren bereits synchron. Während des laufenden
Screenshot-Uploads zeigte die strikte Zwischenprüfung noch ein Bild ohne
fertige Abmessungen. Nach Abschluss aller Uploads bestanden die vollständige
Prüfsummenprüfung und die strikte Einreichungsprüfung. Erst danach wurde die
neue Review-Einreichung erstellt, die einzige App-Version angehängt und unter
der ausdrücklichen Veröffentlichungsanweisung abgesendet.

Version, Build und Einreichung wurden anschließend getrennt zurückgelesen.
Alle maschinenlesbaren Nachweise liegen in `.build/Release-1.3-9/`, insbesondere
`readiness-final.json`, `screenshot-verification.json`, `source-verification.json`,
`ipa-verification.json`, `review-status-final.json` und `submission-verified.json`.
Es wurde keine zusätzliche externe TestFlight-Verteilung beauftragt oder erstellt.

## Status prüfen

```sh
asc versions view --version-id 00c0176b-7d42-4a48-914d-9ae5f26f93cf --include-build --include-submission
asc review status --app 6818139673 --version 1.3 --platform IOS
asc review submissions-get --id 8044e4a0-0a93-4ca4-bc1c-eac57e6b57ad
asc builds list --app 6818139673 --version 1.3 --build-number 9
```
