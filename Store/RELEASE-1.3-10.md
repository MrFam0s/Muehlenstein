# Mühlenstein 1.3 · Build 10

Stand: 08.10.2026. Der Nutzer hat die Veröffentlichung des neuesten
Quellstands und die Bereitstellung für die vorhandenen Tester beauftragt.
Dieser Build enthält zusätzlich zu Build 9 den Anfängermodus und die
Einrichtung mit gleichbleibender Höhe aus Commit `14168d3`.

## Ziel und Artefakt

- App: `6818139673`; Bundle-ID `org.amosystems.Muehlenstein`; iOS.
- Version: **1.3**; ID `00c0176b-7d42-4a48-914d-9ae5f26f93cf`.
- Build: **10**; neuer Quelltag **v1.3-build.10**. `v1.3` bleibt Build 9 zugeordnet.
- Archiv: `.build/Archives/Muehlenstein-1.3-10.xcarchive`.
- IPA: `.build/Release-1.3-10/Muehlenstein-1.3-10.ipa`.
- SHA-256: `da4e57014f06f9bd8f17bd2d940a91f5fd225ba7d9419d6d9dec508572d040e6`.
- Version, Build, Bundle-ID, Team, acht Sprachressourcen, Netzwerkberechtigung,
  Bonjour-Dienst und Distributionsentitlements geprüft. Strikte Signaturprüfung
  bestanden; keine nicht ausgenommene Verschlüsselung.
- Bestehende Gruppe **Externe Tests**, ID `d6665987-bb28-44ae-9306-0125eda4801e`,
  mit drei Testern. Keine Erweiterung des Testerkreises.

## Prüfstand und Ausführung

Archiv und Export sind erfolgreich. Alle 212 Textschlüssel in acht Sprachen
und das Lizenzinventar sind geprüft. Die neuen Versionshinweise bestehen die
Metadatenvalidierung ohne Fehler oder Warnungen.
41 iPhone-Tests und ein iPad-Screenshotablauf bestanden, ohne Fehler oder
übersprungene Tests. 80 Original-Screenshots sind erfasst, exportiert und
visuell geprüft. Die Engine-Prüfungen umfassen 27 Adaptertests und 288
Sanmill-Tests, alle bestanden.

Apple hat Build 10 als `VALID` verarbeitet: Build-ID
`123aa3bf-b264-44cd-9ca3-7261bd78c207`. Die TestFlight-Gruppe wurde zugeordnet,
aber Apple lehnte die Beta-Einreichung ab: Build 9 derselben Version 1.3
wartet bereits auf Beta Review. Die App-Store-Einreichung von Build 9 wurde
zurückgezogen und der neue Stand zunächst vorbereitet; Build 10 wurde nicht
zur App-Store-Prüfung eingereicht.

Der endgültige Release verwendet deshalb **1.3.1 (Build 11)** mit derselben
Produktlogik und einem separaten TestFlight-Versionszweig. Kein älterer
TestFlight-Build wurde ablaufen gelassen. Siehe
[abschließenden Release- und Distributionsnachweis](RELEASE-1.3.1-11.md).

Die vorhandene funktionale Geräteabdeckung und ihre Grenzen aus
[Build 9](RELEASE-1.3-9.md) und der [Validierung](../Docs/VALIDATION.md)
gelten weiter. Dieser Release behauptet keinen neuen Zwei-iPhone-Test.
Maschinenlesbare Nachweise liegen in `.build/Release-1.3-10/`.
