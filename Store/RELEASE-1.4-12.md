# Quellrelease 1.4 (12) — 10.10.2026

| Angabe | Stand |
| --- | --- |
| App-Version | 1.4 |
| Buildnummer | 12 |
| Quelltag | [v1.4](https://github.com/MrFam0s/Muehlenstein/tree/v1.4), annotiert |
| Bundle-ID | `org.amosystems.Muehlenstein` |
| Umfang | Versionierter Quellstand im Repository; kein Apple-Upload |

## Änderungen

- Jeder Verlaufseintrag öffnet eine grafische Rückschau mit Vor-/Zurück-Pfeilen,
  Anfang/Ende und Schieberegler. Tipps und zurückgenommene Zugfolgen bleiben
  nachvollziehbar. Das Ansehen verändert die laufende Partie nicht.
- Angezeigte Tipps und ausgeführte Rücknahmen werden dauerhaft protokolliert
  und in den Spieldetails zusammengefasst. Bestehende Spielstände bleiben lesbar;
  zuvor nicht erfasste Spielhilfen werden als unbekannt gekennzeichnet.
- Eine Abschlusskarte mit Lorbeerzeichen und Spielstein zeigt ausschließlich
  „Partie beendet“ und das Ergebnis. Ihre Bestätigung bleibt gespeichert.
- Bei aktivierten Zugzielen erhalten erlaubte Abnahmen einen leuchtenden Rand.
- Alle acht nativen Sprachfassungen enthalten 230 vollständige Textschlüssel.

Der Produktcode entspricht Commit
`431a992c1e3639beac16ca301202a07cb6baabdf`. Der Release-Commit ergänzt ausschließlich
Versionskonfiguration, die erwartete Versionsanzeige im bestehenden UI-Test
und Dokumentation. Engine, Regeln und Abhängigkeiten bleiben unverändert.

## Prüfung

Release-Konfiguration auf dem vorhandenen Projekt-iPhone-Simulator
(iPhone 17e, iOS 27): **drei gezielte Prüfungen bestanden**, keine Fehler.

- Versionsanzeige **Version 1.4 · Build 12**, Impressum, Datenschutz, Herkunft
  und offline lesbare Lizenzhinweise im UI.
- Tatsächlich gebündelte Versionswerte und 20 Lizenzgruppen einschließlich
  vollständiger Rust-Dritthinweise.
- Acht gebündelte Sprachen, vollständige Schlüssel und gültige Formatargumente.

Das erzeugte App-Bundle bestätigt `CFBundleShortVersionString = 1.4`,
`CFBundleVersion = 12` und die unveränderte Bundle-ID. Die separaten Prüfmodi
für Sprachressourcen und Lizenzinventar bestehen ebenfalls.

Lokale Nachweise: `.build/Version-1.4-Checks.xcresult` und
`.build/Version-1.4-Checks.log`. Die vorherigen 41 Funktionsprüfungen und sechs
UI-Abläufe zum unveränderten Produktcode sind im
[Validierungsprotokoll](../Docs/VALIDATION.md) dokumentiert. Kein erneuter
physischer Geräte- oder Zwei-Geräte-WLAN-Test für diesen Versionsschritt;
VoiceOver und Akkutests bleiben wie vereinbart zurückgestellt.

## Abgrenzung zum App-Store-Stand

Kein signiertes Gerätearchiv, IPA-Export, Apple-Upload, Review-Antrag oder
erneuter Apple-Statusabruf für 1.4. Der zuletzt dokumentierte App-Store-Stand
bleibt **1.3.1 (11)**, am 08.10.2026 als veröffentlicht bestätigt; TestFlight
wartete bei dieser Prüfung separat auf Beta-Freigabe.
[Datiertes Distributionsprotokoll](RELEASE-1.3.1-11.md).

`Store/metadata.json` führt Version, Build und Quelltag von 1.4 getrennt von
den datierten Apple-/TestFlight-Feldern. Store-Texte, Review-Hinweise,
Screenshots und das Website-Paket bewahren den Stand von 1.3.1.
Für eine spätere Einreichung sind das passende signierte Archiv sowie
aktualisierte Store-Versionshinweise und Aufnahmen erforderlich.
Bestehende Quelltags bleiben unverändert.
