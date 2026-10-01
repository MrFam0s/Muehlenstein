# Mühlenstein 1.0.2 · Build 6

Stand: 01.10.2026. Die Fortsetzung der Einreichung ist vom Nutzer beauftragt.
Build 6 übernimmt das zuletzt bestätigte App-Icon mit beigem Hintergrund und
waldgrünem Motiv. Build 5 wird nicht für die Einreichung verwendet.

## Apple-Ziel

- App: `6818139673`; Bundle-ID: `org.amosystems.Muehlenstein`; Plattform: iOS.
- Version: `1.0.2`; Versions-ID: `3e275fea-964a-47db-8a26-ebfe5b0b78fc`.
- Build: `6`; Build-ID: `557f1a60-ab60-4005-a3c3-aea9e1efa528`; Verarbeitung: `VALID`.
- Quelltag: `v1.0.2-build.6`; bestehende Tags bleiben unverändert.
- Review: noch nicht eingereicht. Für den vollständigen Review-Kontakt fehlt
  die Telefonnummer des Nutzers; Name und E-Mail sind bekannt. Apple verlangt
  bei der ersten Anlage alle vier Kontaktfelder gemeinsam.

## Verifiziert

- Release-Archiv und App-Store-Export erfolgreich; Codesign-Prüfung erfolgreich.
- Bundlewerte im Archiv: Version `1.0.2`, Build `6`, korrekte Bundle-ID,
  `ITSAppUsesNonExemptEncryption = false`.
- Das aus dem Archiv extrahierte App-Icon zeigt die aktuelle beige/grüne Variante.
- PrivacyInfo.xcprivacy und Legal/notices.json sind im App-Paket vorhanden.
- Bestehende Release-Tests für Versionsanzeige, Anbieter-/Quellangaben und
  gebündelte Lizenztexte: 2 Tests erfolgreich.
- 16 Screenshots (vier je Sprache und Gerätegröße): alle bei Apple `COMPLETE`;
  Abmessungen und MD5-Prüfsummen stimmen mit den lokalen Originaldateien überein.
- Deutsch und Englisch: Metadaten mit dem kanonischen Ordner `metadata/` synchron.
- App Privacy: `DATA_NOT_COLLECTED`, veröffentlicht und erneut abgefragt.
- Deutschland: einmalig `0.99 EUR`; Support- und Datenschutz-URLs liefern ohne
  Anmeldung HTTP 200. Bestehende Verkaufsgebiete und automatische Freigabe nach
  Apples Genehmigung bleiben erhalten.

## Lokale Nachweise

- Archiv: `.build/Archives/Muehlenstein-1.0.2-6.xcarchive`.
- IPA: `.build/Release-1.0.2-6/Muehlenstein-1.0.2-6.ipa`.
- Tests: `.build/Release-1.0.2-6/Version-Checks.xcresult`.
- Upload, Datenschutz und Screenshot-Abgleich: `.build/Release-1.0.2-6/`.

Der erste Blitz-Screenshot-Upload ordnete wegen gleicher Dateinamen iPad-Bilder
auch den iPhone-Plätzen zu. Ausschließlich diese fehlerhaften Uploads wurden
über die CLI durch die korrekten Originaldateien ersetzt und danach geprüft.

Nach Ergänzung des Review-Kontakts erneut `asc validate` ausführen, bestehende
Review-Einreichungen prüfen und die vorbereitete Version zur Prüfung absenden.
Die CLI-Warnungen zu fehlendem „What's New“ betreffen die erste Veröffentlichung;
dieses Feld bleibt bei einer Erstveröffentlichung leer.

Statusabfrage:

```sh
asc review status --app 6818139673 --version 1.0.2 --platform IOS --output table
```
