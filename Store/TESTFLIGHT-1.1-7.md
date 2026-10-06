# Mühlenstein 1.1 · Build 7 · TestFlight

Stand: 02.10.2026. Der Nutzer hat beauftragt, die neueste Version den Testern
bereitzustellen. Der Build ist hochgeladen und für die bestehende externe
Gruppe zur Beta-Prüfung eingereicht. **Die Installation für externe Tester
wartet noch auf Apples Freigabe.**

## Bestätigter Apple-Status

- App: `6818139673`; Bundle-ID: `org.amosystems.Muehlenstein`; Plattform: iOS.
- Version: **1.1**; Build: **7**; Verarbeitung: **`VALID`**.
- Build-/Beta-Review-ID: `18bcd44b-2552-4988-8cb2-5244793f0843`.
- Gruppe: **Externe Tests**, `d6665987-bb28-44ae-9306-0125eda4801e`;
  ein bestehender Tester. Die Buildzuordnung wurde erneut abgefragt.
- Beta-Prüfung eingereicht am **02.10.2026, 13:53:58 Uhr (Europe/Berlin)**,
  entsprechend `2026-10-02T11:53:58Z`.
- Review: **`WAITING_FOR_REVIEW`**; externe Verteilung:
  **`WAITING_FOR_BETA_REVIEW`**.
- Automatische Testerbenachrichtigung: **aktiviert** (`autoNotifyEnabled: true`).
- Deutsche und englische Testhinweise gespeichert und inhaltlich erneut geprüft:
  Schieferblau, Rosé, Erhalt gespeicherter Farben, Hell/Dunkel, Spielabläufe,
  Speicherung sowie iPhone-/iPad-Ausrichtungen.

Die bestehende App-Store-Einreichung von 1.0.2 (6) wurde nicht verändert.
Eine App-Store-Einreichung von 1.1 wurde nicht vorgenommen. Die bisherigen
Store-Screenshots gehören zu 1.0.2; ihre Aktualisierung ist für die spätere
Store-Einreichung von 1.1 vorgesehen.

## Quellstand und Prüfung

- Öffentlich vorhandener Quelltag: **v1.1**; Commit:
  `63856f4c222d476cf2e8a27a1c97383d0d2c4a22`.
- App, Konfiguration, Engine, Xcode-Projekt, Ressourcen und Skripte entsprechen
  dem Tag; keine Binäränderung für diese Verteilung.
- Release-Archiv und App-Store-Export erfolgreich. Archiv und exportiertes
  App-Paket bestehen die strikte Codesign-Prüfung.
- Archiv und IPA bestätigen Bundle-ID, Version **1.1**, Build **7** und
  `ITSAppUsesNonExemptEncryption = false`.
- Distributionssignatur bestätigt Team `4WHV5UZ8E5`, `get-task-allow = false`
  und `beta-reports-active = true`.
- Datenschutzmanifest und `Legal/notices.json` sind im Archiv und IPA enthalten.
- Die vorhandenen Release-Testnachweise des unveränderten Quellstands wurden
  geprüft: `.build/Version-1.1-Checks.xcresult`, **2 Tests bestanden**.
  Kein zusätzlicher Testlauf und keine neue physische Geräteprüfung.
- SHA-256 der IPA:
  `2a7000c9293d281826ce8d949476c5502a81c92e9029b9694c9cf0affa1f7028`.

## Lokale Nachweise

- Archiv: `.build/Archives/Muehlenstein-1.1-7.xcarchive`.
- IPA: `.build/TestFlight-1.1-7/Muehlenstein-1.1-7.ipa`.
- Build-, Upload-, Zuordnungs-, Review- und Testhinweisnachweise:
  `.build/TestFlight-1.1-7/`.

Status erneut abfragen:

```sh
asc testflight distribution view --build-id 18bcd44b-2552-4988-8cb2-5244793f0843 --output table
asc testflight review submissions list --build-id 18bcd44b-2552-4988-8cb2-5244793f0843 --output table
```
