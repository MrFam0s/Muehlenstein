# Native Sprachfassungen

Stand: 06.10.2026. Version 1.2 (Build 8) ergänzt fünf Sprachen neben Deutsch
und Englisch. Chinesisch wird in zwei Schriftfassungen angeboten; dadurch
enthält das App-Bundle insgesamt acht Lokalisierungen.

| Sprache | iOS-Kennung | Schwerpunkt |
| --- | --- | --- |
| Deutsch | `de` | Bestehend |
| Englisch | `en` | Bestehend und Rückfallsprache |
| Japanisch | `ja` | Japan |
| Koreanisch | `ko` | Südkorea |
| Chinesisch, vereinfacht | `zh-Hans` | Festlandchina und entsprechende Sprachpräferenzen |
| Chinesisch, traditionell | `zh-Hant` | Taiwan, Hongkong und entsprechende Sprachpräferenzen |
| Französisch | `fr` | Frankreich und französischsprachige Nutzer weiterer Märkte |
| Spanisch | `es` | Spanien und spanischsprachige Nutzer weiterer Märkte |

## Auswahl nach Marktpotenzial

Die Auswahl ist eine Produktentscheidung anhand von Umsatzpotenzial und
Sprachabdeckung, keine behauptete Rangliste der fünf umsatzstärksten Sprachen.
Eine belastbare öffentliche Rangliste speziell für kostenpflichtige
0,99-Euro-Brettspiele nach Sprache lag nicht vor.

AppMagics [Mobile Market Landscape 2026](https://appmagic.rocks/files/view/upload/Reports/EN_MobileMarkeLandscape2026.pdf),
Seiten 7, 13, 14 und 19, nennt China, Japan, Südkorea, Frankreich und Taiwan
unter den zehn umsatzstärksten mobilen Märkten 2025. Die Daten umfassen
App Store und Google Play; China umfasst nur den App Store. Insbesondere die
Spieleauswertung betrachtet In-App-Umsätze, nicht ausschließlich Kauf-Apps.
Diese Zahlen dienen daher als Näherung für das Marktpotenzial.

Japanisch, Koreanisch, Chinesisch und Französisch erschließen wichtige,
bislang nicht nativ bediente Märkte. Die traditionelle chinesische Fassung
berücksichtigt Taiwan und Hongkong. Als fünfte zusätzliche Sprache wird
Spanisch wegen seiner marktübergreifenden Reichweite aufgenommen; AppMagic
berichtet zudem starkes Umsatzwachstum in Spanien. Eine höhere erwartete
Kaufquote als etwa bei Italienisch oder Portugiesisch ist damit nicht belegt.

## Umfang und Sprachwahl

Alle acht Fassungen enthalten dieselben 181 Texte: Startseite, Spiel,
Konfiguration, erweiterte KI-Optionen, Hilfen, Regeln, Zugerklärungen,
Fehlermeldungen, barrierefreie Beschriftungen und Informationsseiten.
Der internationale Produktname bleibt **Muehlenstein**; auf Deutsch
heißt die App **Mühlenstein**.

Die Sprache wird über die native Bundle-Lokalisierung anhand der iOS-
Sprachpräferenz gewählt. Es gibt keinen zusätzlichen Sprachschalter in der
Spielfläche. Chinesische Fassungen besitzen neben der Schrift auch passende
Begriffe, etwa „源代码“ beziehungsweise „原始碼“. Alle Texte sind offline verfügbar.

Die eigentlichen Lizenz- und Drittanbietertexte bleiben unveränderte
Originaldokumente. Übersetzt sind die Navigation und die erläuternden
Herkunftsangaben. Diese Änderung ergänzt keine neuen Bibliotheken, Dienste
oder Netzwerkzugriffe. Adresse, Anbieteridentität, Links und Spielregeln
bleiben inhaltlich erhalten.

App-Store-Beschreibungen, Keywords und Store-Screenshots sind ein eigener
Bestand unter `Store/`. Die neuen Sprachen betreffen zunächst die native App;
Store-Metadaten und Länderverfügbarkeit werden dadurch nicht bearbeitet.

## Pflege und Prüfung

Deutsch und Englisch werden in `Scripts/generate-resources.py` gepflegt;
die zusätzlichen Fassungen in `Localization/<Sprache>.json`. Nach einer
Textänderung müssen alle Fassungen aktualisiert werden:

```sh
python3 Scripts/generate-resources.py
python3 Scripts/generate-project.py
python3 Scripts/generate-resources.py --check-localizations
python3 -m unittest discover -s Tests -p 'test_project_sync.py'
```

Der Generator prüft fehlende, zusätzliche und doppelte Schlüssel, leere
Texte und die Reihenfolge/Typen der Formatargumente vor dem Schreiben.
Der Prüfmodus erkennt außerdem veraltete erzeugte Dateien, ohne etwas zu
ändern. Die Projektsynchronisierung ergänzt Sprachdateien in den bestehenden
Xcode-Ressourcengruppen und bewahrt Signierung und Build-Einstellungen.

Der Bundle-Test prüft die tatsächlich eingebauten Sprachen, vollständige
Schlüssel, Formatargumente und die Absatzstruktur der Informationsseiten.
Der UI-Test `testNewNativeLanguagesAcrossHomeSetupGameAndReading` öffnet jede
neue Fassung mit ihrer iOS-Sprachpräferenz und prüft Startseite, Regeln,
Datenschutz, Partieeinrichtung, erweiterte Optionen, Spiel, Hinweis und
Darstellung. Er zeichnet Screenshots für eine Sichtprüfung auf.

Beispielaufnahmen der iPhone-Einrichtung:
[Französisch](Previews/Localization-fr-iPhone-Setup.png) und
[Japanisch](Previews/Localization-ja-iPhone-Setup.png).

Die Übersetzungen wurden im Rahmen der Entwicklung erstellt. Eine externe
muttersprachliche Redaktion ist damit nicht nachgewiesen. Testergebnisse
und Geräteumfang sind im [Validierungsprotokoll](VALIDATION.md) dokumentiert.

## Lokale Netzwerkpartien · 07.10.2026

Der Entwicklungsstand enthält jetzt 212 gemeinsame Textschlüssel in acht Sprachen. Einladungen, Suche, Verbindung, Fehler- und Wiederaufnahmehinweise sind vollständig lokalisiert. `InfoPlist.strings` enthält zusätzlich zur App-Benennung die jeweilige Begründung für den lokalen Netzwerkzugriff. Die Datenschutzhinweise erläutern die direkte verschlüsselte Geräteverbindung. Die Sprachwahl selbst löst weiterhin keine Netzwerkzugriffe aus.
