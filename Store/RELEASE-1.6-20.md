# Mühlenstein 1.6 · Build 20

Apple hat die iOS-Version am 28.11.2026 um 11:07 Uhr (Berlin) zur Prüfung angenommen. Beim Abgleich meldeten die Version `WAITING_FOR_REVIEW` und die Übermittlung `WAITING_FOR_REVIEW`. Als Veröffentlichungsmodus ist `AFTER_APPROVAL` gespeichert. [App Store Connect](https://appstoreconnect.apple.com/apps/6818139673/distribution)

## Änderungen

- Eigene Steine können auf ein legales Zielfeld gezogen werden. Die bisherige Eingabe per Antippen ist ebenfalls möglich.
- Nach Spielende zeigt der Verlauf die gespielte Stellung und den begründeten Vorschlag der KI für einen eigenen Zug.
- Die optionale automatische Spielstärke berücksichtigt abgeschlossene Computerpartien. Die letzte feste Stufe wird separat gespeichert.

## Build und Prüfungen

| Nachweis | Wert |
|---|---|
| Quelltag | [v1.6](https://github.com/MrFam0s/Muehlenstein/tree/v1.6) |
| Release-Commit | `8dfeef250e7f35c7d32c7c5c211a23c03f6fbbc6` |
| Signierte IPA (SHA-256) | `5c0986d9a40242d9aad5decc1498c5e43224ecd10f82f0f1da265dac2eb7ad3f` |
| Bundle-ID | `org.amosystems.Muehlenstein` |
| Apple-Versions-ID | `1f80daf2-e9fe-4d31-90bc-29a2229bccf8` |
| Apple-Build-ID | `7a9f87c9-01a4-41cc-8c38-7d4bbfeae854` |
| Review-Übermittlung | `feedacb9-891e-4b3c-ae7c-4be4e1673247` |

Aus einem sauberen Checkout des Release-Commits bestanden 52 Release-App- und UI-Tests auf dem Projektsimulator, 319 Rust-Tests und sechs Python-Tests. Die fertige IPA enthält alle acht Sprachpakete, das Datenschutzmanifest und die Lizenzhinweise. Signatur, Entitlements, Version und Buildnummer wurden am exportierten Paket geprüft. Apple meldete den zugeordneten Build als `VALID`.

Die acht vollständigen Versionstexte wurden nach dem Speichern mit dem Tag verglichen. Der Entwurf enthält die übernommenen 64 Screenshots. Die abschließende Blitz-Prüfung meldete null Blocker, Warnungen oder offene Prüfpunkte.

## Vertrieb

Alle 175 aktuellen App-Store-Gebiete und künftige Gebiete sind ausgewählt. Beim Abgleich vor diesem Update meldete Apple die Vorgängerversion in 174 Gebieten als verfügbar. Für Festlandchina meldete Apple `MISSING_GRN`. Für das Spiel liegt laut Anbieter keine chinesische Spielgenehmigung vor.
