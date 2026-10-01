# App-Store-Vorbereitung

Stand: 01.10.2026. **Vorbereitung abgeschlossen, noch nicht bei Apple eingereicht.**
App-Version **1.0**, Build **3**, Quellstand
[`v1.0`](https://github.com/MrFam0s/Muehlenstein/tree/v1.0).
Der Nutzer hat ausdrücklich auf Vorbereitung begrenzt. Kein App-Store-Connect-
Datensatz, Upload, TestFlight-Release, Vertrag oder Preis wurde verändert.
Das Repository bleibt öffentlich. Die bestehende Sanmill-Engine bleibt erhalten;
die Rechteketten-Restfrage steht unverändert in der [Lizenzprüfung](../Docs/LICENSE_REVIEW.md).

## Vorbereitete Unterlagen

- [Produktdaten DE/EN](metadata.json): Name, Untertitel, Kurztext, Beschreibung,
  Suchwörter, Support-/Datenschutz-URLs und englische Review Notes. Längenlimits
  geprüft. Zielpreis Deutschland: 0,99 € einmalig, ohne In-App-Käufe oder Abo.
- [Datenschutz DE/EN](../Docs/PRIVACY.md) und [Support DE/EN](../Docs/SUPPORT.md):
  öffentlich über das bestehende Repository erreichbar; keine zusätzliche
  Domain oder Hostingvereinbarung erforderlich. Vor Einreichung die URLs
  unangemeldet prüfen und in die entsprechenden Store-Felder übernehmen.
- [16 Original-Screenshots](Screenshots/manifest.json): vier Motive je Sprache
  und Gerätegröße. Reihenfolge: Spiel, Tipp, Neue Partie, Startseite. iPhone
  6,9 Zoll: 1320 × 2868; iPad 13 Zoll: 2064 × 2752. PNG/RGB ohne Alphakanal,
  keine Retusche, keine erfundenen Produktfunktionen oder Werbeüberlagerungen.
  Die Aufnahmen zeigen echte App-Oberflächen mit einer reproduzierbaren
  Beispielpartie; sie sind nicht aus einem simulierten Designmodell gerendert.
  Der iPad-Systembereich folgt der deutschen Sprache des Simulators, auch
  wenn die App-Oberfläche für den englischen Screenshot Englisch verwendet.
- App-Icon: bereits im Asset-Katalog; vollständige Lizenzhinweise und
  Anbieterangaben sind in der App enthalten.

## Lokales Archiv und Nachweise

`../.build/Archives/Muehlenstein-1.0-3.xcarchive`

- Release-Archiv erfolgreich gebaut, Signaturprüfung erfolgreich.
- Bundle-ID `org.amosystems.Muehlenstein`, Version **1.0 (3)**,
  Mindestversion iOS/iPadOS 18.0.
- Mit dem vorhandenen **Entwicklungsprofil** signiert (`get-task-allow = true`).
  Das ist ein lokales Vorbereitungsarchiv. Für die spätere Einreichung sind
  App-Store-Export/Distributionssignierung und Apples Validierung noch nötig.
- PrivacyInfo.xcprivacy liegt nachweislich im Wurzelverzeichnis des App-Pakets,
  die vollständigen Lizenzressourcen unter `Legal/`.
- SHA-256 des archivierten Executables:
  `0f45980e5b36dc79846493fb67efdb69457f0bed0f5396f704bf7a2e01b60bd0`.
  App-Verzeichnis lokal: 4.982.446 Byte; dies ist **keine** garantierte
  Download-/Installationsgröße nach Apples Verarbeitung.
- Der vorhandene Test für Bundlewerte/Lizenzressourcen und der Bedienungstest
  von „Über Mühlenstein“ bestehen für **Version 1.0 · Build 3** im Release-Modus
  (`.build/Version-1.0-Checks.xcresult`, Testbarkeit nur für diesen Testlauf).
- Screenshot-Abläufe auf iPhone 18 Pro Max und iPad Pro 13 Zoll (M5) bestanden
  im Release-Modus mit `ENABLE_TESTABILITY=YES` ausschließlich für den Testlauf.
  Ergebnis: `.build/Store-Screenshots-Final.xcresult`. Das Gerätearchiv wurde
  ohne diesen Test-Override gebaut.
- Die 16 Store-Aufnahmen entstanden mit Version 0.1.0 (2) und bleiben für
  1.0 (3) gültig: Die abgebildeten Spielansichten sind unverändert und zeigen
  keine Versionsnummer. Die historische Aufnahmeprüfung wird nicht als
  erneuter Screenshotlauf der Version 1.0 ausgegeben.
- Vier vorhandene Python-Tests, Vendor-/Lizenzprüfung und Eröffnungsbuchprüfung
  bestehen auch nach der Versionsanhebung. Regeln, Suchverfahren und
  Spieloberfläche sind unverändert; die Versionsanzeige zeigt den neuen Stand.
- Der erste Screenshotlauf scheiterte an fehlender Swift-Testbarkeit im
  Release-Testhost. Der korrigierte Nachlauf besteht. Die ursprünglichen
  Protokolle bleiben unter `.build/Store-Screenshots.log` erhalten.

## Datenschutz- und Exportangaben

Vorbereitete App-Privacy-Antwort: **Keine Daten durch die App erfasst**, kein
Tracking, keine Werbe-ID, keine Konten. Spielstände bleiben lokal. Freiwillige
E-Mails werden vom Benutzer im externen Mailprogramm verfasst; die App hängt
keine Diagnose- oder Spieldateien automatisch an. Apples eigene Store- und
Systemdienste sind davon zu unterscheiden. Die Datenschutzerklärung erläutert
Supportkontakte und Gerätesicherungen gesondert.

Manifestgründe:

| Kategorie | Grund | Verwendung |
| --- | --- | --- |
| UserDefaults | CA92.1 | Eigene Anzeigeeinstellungen in `AppPreferences`. |
| SystemBootTime | 35F9.1 | Verstrichene Zeit für Suchbudgets und Timer; keine Übertragung. Rust `Instant` ist im Archiv über `_clock_gettime` sichtbar; die Deklaration deckt die entsprechende Zeitmessung ab. |
| FileTimestamp | C617.1 | Eigene Spielstands-/Ressourcendateien im App-Bereich; Datei-/Metadatenzugriffe der nativen Laufzeiten. `_fstat` ist in Rust `std::fs::read` und der Backtrace-Symbolisierung verknüpft. |

Der Symbolscan ergänzt die Quellprüfung; ein verknüpftes Symbol beweist nicht,
dass jeder entsprechende Bibliothekszweig im normalen Spiel durchlaufen wird.
Es werden keine Disk-Space-, Keyboard- oder App-Group-Gründe vorsorglich
deklariert. Kein Netzwerk-/Analyse-SDK wurde hinzugefügt.

`ITSAppUsesNonExemptEncryption = false` ist in Info.plist und im erzeugenden
Skript gesetzt: Die App implementiert keine eigene oder nicht ausgenommene
Verschlüsselung. Externe HTTPS-Links öffnet das System. Die spätere
Export-Compliance-Abfrage muss weiterhin für den tatsächlich eingereichten
Build beantwortet werden; dies ist keine behördliche Exportgenehmigung.

## Für die spätere Einreichung noch nötig

1. In App Store Connect anmelden und den App-Datensatz mit passender Bundle-ID
   und Namensverfügbarkeit anlegen bzw. auswählen. Version **1.0** mit Build
   **3** verwenden. Spätere Versions-/Buildänderungen erfolgen dauerhaft in
   `Configuration/App.xcconfig`; der Versionsanzeige-Test ist dann mitzuführen.
2. Gebührenpflichtige Verträge, Steuer-/Bankdaten und EU-Händlerstatus im
   Inhaberkonto prüfen. Den deutschen Preis 0,99 € und die gewünschten
   Verkaufsgebiete festlegen; internationale Preise sind noch nicht gewählt.
3. Produktdaten, Screenshots, URLs, App Privacy und Altersfreigabe-Fragebogen
   eintragen. Keine Gewalt, Glücksspiele, Werbung, Chats, freien Webzugriffe
   oder nutzergenerierten Online-Inhalte in der App. Die verbindliche
   Alterskennzeichnung ergibt sich aus Apples aktuellem Fragebogen.
4. Review-Kontakt einschließlich einer erreichbaren Telefonnummer ergänzen.
   Eine Telefonnummer liegt für dieses Projekt noch nicht vor. Keine
   Demo-Zugangsdaten nötig, da die App kein Konto voraussetzt.
5. Archiv exportieren und bei Apple validieren. Der Quellstand für Version
   1.0 (3) ist mit `v1.0` markiert. Diesen Tag beibehalten; bei weiteren
   Binary-Änderungen einen neuen Build samt passendem Quelltag erstellen.
   Erst danach den tatsächlichen Upload und die Einreichung durchführen.
6. Die dokumentierten offenen Geräte-/Barrierefreiheitsprüfungen berücksichtigen.
   Vollständige VoiceOver- und Akkutests bleiben auf Nutzerwunsch zurückgestellt;
   entsprechende Zertifizierungs-/Unterstützungsversprechen werden nicht abgegeben.

Die öffentliche Herkunftsprüfung belegt die ausdrückliche App-Store-Ausnahme,
aber keine vollständige historische Rechtekette. Eine Rückfrage an Upstream
bleibt vorbereitet und unversandt. Apple Review ersetzt keine Rechteklärung.

## Wiederholbare Aufnahmen

Test `MuehlensteinUITests/testStoreScreenshots` auf beiden oben genannten
Simulatorgrößen laufen lassen; für Release-Tests `ENABLE_TESTABILITY=YES`
setzen. Den Statusbalken über `simctl status_bar` auf 9:41 und volle Batterie
setzen. Danach:

```sh
xcrun xcresulttool export attachments \
  --path .build/Store-Screenshots-Final.xcresult \
  --output-path .build/StoreScreenshotAttachments
python3 Scripts/export-store-screenshots.py
```

Das Exportscript kopiert die Originaldateien unverändert, prüft Anzahl,
Dimensionen und Alphakanal und schreibt SHA-256-Werte. Andere Geräteformate
müssen ausdrücklich ergänzt werden. Alte Entwicklungsaufnahmen unter
`Docs/Previews` werden nicht als aktuelle Store-Bilder ausgegeben.

## Apple-Quellen, geprüft am 01.10.2026

- [Screenshot-Spezifikationen](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications)
- [App Privacy](https://developer.apple.com/app-store/app-privacy-details/)
- [Required-Reason-API-Kategorien und Gründe](https://developer.apple.com/documentation/bundleresources/app-privacy-configuration/nsprivacyaccessedapitypes/nsprivacyaccessedapitype)
- [Export Compliance](https://developer.apple.com/documentation/security/complying-with-encryption-export-regulations)
- [App Review Guidelines](https://developer.apple.com/app-store/review/guidelines/)
