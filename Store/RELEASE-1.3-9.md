# Mühlenstein 1.3 · Build 9

Stand: 08.10.2026. Der Nutzer hat die Veröffentlichung des neuesten Standes
beauftragt. Version 1.2 (8) ist bereits veröffentlicht; Version 1.3 (9)
enthält zusätzlich den lokalen WLAN-Spielmodus.

## Apple-Ziel und aktueller Stand

- App: `6818139673`; Bundle-ID `org.amosystems.Muehlenstein`; iOS.
- Version: **1.3**; ID `00c0176b-7d42-4a48-914d-9ae5f26f93cf`.
- Buildnummer: **9**.
- Upload: `607206c3-1ad1-4462-8e28-3db95811afe8`, bei Apple bestätigt;
  Verarbeitung noch ausstehend.
- Version angelegt mit **automatischer Veröffentlichung nach Freigabe**
  (`AFTER_APPROVAL`). Noch nicht zur Prüfung eingereicht.
- Alle acht Store-Texte und App-Info-Sprachfassungen mit Apple abgeglichen.
  Beschreibung, Werbetext und Versionshinweise erklären den WLAN-Modus.
- Review-Kontakt übernommen, Review Notes um die genaue Einrichtung auf
  zwei Geräten, lokale Netzwerkberechtigung und Wiederverbindung ergänzt.

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

Der erneute Test auf zwei physischen iPhones wurde gestartet, wartet aber
auf das Entsperren von FA-iPhone und LA-iPhone. Keine erfolgreiche
Zwei-iPhone-Prüfung behauptet. Rollentausch, längere Funkunterbrechungen,
Gastnetze und widerrufene Netzwerkberechtigungen bleiben zusätzliche
Geräteabdeckung. Lokale Nachweise liegen unter `.build/Release-1.3-9/`.

Neue Release-Prüfungen bestanden: 41 Tests auf iPhone (39 GameStore-Tests,
Versions-/Anbieter-/Lizenznavigation und Screenshotablauf) sowie der vollständige
Screenshotablauf auf iPad. Keine Fehler und keine übersprungenen Tests.
80 neue Original-Screenshots: je fünf Motive in acht Sprachen und zwei
Geräteklassen. Alle 16 Kontaktbögen wurden gesichtet; RGB ohne Alpha,
1320 × 2868 bzw. 2064 × 2752, Dateiabdeckung und Prüfsummen geprüft.
Der Upload der neuen Sets für Version 1.3 läuft.

Die Metadatenvalidierung besteht ohne Fehler oder Warnungen; alle 212
Textschlüssel in acht Sprachen und die vollständigen Lizenzhinweise sind geprüft.

## Status prüfen

```sh
asc versions view --version-id 00c0176b-7d42-4a48-914d-9ae5f26f93cf --include-build --include-submission
asc review status --app 6818139673 --version 1.3 --platform IOS
asc builds list --app 6818139673 --version 1.3 --build-number 9
```
