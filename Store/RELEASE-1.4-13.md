# Mühlenstein 1.4 · Build 13

Stand: 10.10.2026. Distribution auf Nutzerauftrag für App Store und die
bestehende TestFlight-Gruppe. Version 1.3.1 (11) war bei der Ausgangsprüfung
bereits im App Store veröffentlicht und extern in TestFlight verfügbar.
Für den Quellrelease 1.4 (12) existierte noch kein Apple-Build.

## Identität und Quellstand

- App `6818139673`; Bundle-ID `org.amosystems.Muehlenstein`; iOS.
- Version **1.4**, neuer Build **13**, neuer Quelltag **v1.4-build.13**.
- Der ursprüngliche Tag **v1.4** bleibt unverändert bei Build 12.
- Produktcode, Engine und Abhängigkeiten entsprechen Build 12. Lediglich
  Buildnummer und Erwartung des bestehenden Versionsanzeige-Tests ändern sich.
- Archiv `.build/Archives/Muehlenstein-1.4-13.xcarchive`.
- IPA `.build/Release-1.4-13/Muehlenstein-1.4-13.ipa`.
- IPA-SHA-256 `31705f761c06038a7d14af212b4621b7988ff957f0c4dd54d2c10c2a432fc8d8`.

## Umfang

Grafische Rückschau mit Pfeilen und Schieberegler, dauerhaft protokollierte
Tipps und Rücknahmen, Spieldetails mit Hilfen-Zählern, eine gestaltete
Abschlusskarte und zuschaltbare Markierungen erlaubter Abnahmen. Bestehende
Spielstände bleiben lesbar. [Versionshinweise](../CHANGELOG.md).

## Prüfung

**44 Release-Prüfungen bestanden:** 41 funktionale Modell-/Pakettests und
drei UI-Abläufe für Versionsanzeige/Lizenzen, grafische Rückschau und
gespeicherte Spielhilfen. Keine Fehler. Projekt-iPhone:
`4B91CD4C-CBD0-4993-85D7-2FA995662B84`, iOS 27.

Das exportierte IPA bestätigt Version 1.4, Build 13, die Bundle-ID,
Distributionssignatur ohne Debugging-Berechtigung, acht Sprachressourcen,
Privacy Manifest, Bonjour-/Netzwerkdeklaration und systembasierte Verschlüsselung.
Die Sprachprüfung bestätigt 230 Schlüssel in acht Sprachen; das vollständige
Lizenzinventar besteht. Die kanonischen Metadaten haben keine Fehler oder
Warnungen. Keine Änderungen am Spielcode, keine erneute physische
Zwei-Geräte-WLAN-, VoiceOver- oder Akkuprüfung.

## Vorbereitung und Status

Archiv, Export, Upload und Verarbeitung bei Apple sind erfolgreich (`VALID`).
Build-ID: `03388cfe-cbdd-4860-8336-26662a843e04`; der Build ist mit
App-Store-Version `fb6a5be1-03a5-48c1-8d96-b5d486cbd729` verknüpft.
Acht lokalisierte Versionshinweise liegen unter `metadata/version/1.4/`,
acht Testanleitungen unter `Store/TestFlight-1.4.json`; beide sind bei Apple
gespeichert und erneut vollständig abgeglichen. Die bestehende Gruppe
**Externe Tests** (`d6665987-bb28-44ae-9306-0125eda4801e`) enthält drei Tester.
Aktuelle iPhone-/iPad-Store-Aufnahmen werden vor der Einreichung geprüft.
Preise, Länderverfügbarkeit und Testerkreis bleiben unverändert.

Die strikten App-Store- und TestFlight-Prüfungen melden keine Fehler,
Warnungen oder Blocker. Der informative App-Privacy-Hinweis wurde anhand der
öffentlichen Apple-Seite geprüft: **Keine Daten erfasst** ist veröffentlicht.
Die automatische App-Store-Veröffentlichung nach Freigabe ist vorgesehen;
automatische Testerbenachrichtigung ist am Build aktiviert.

Lokale Nachweise: `.build/Release-1.4-13/` und
`.build/Release-Status-2026-10-10/`.
