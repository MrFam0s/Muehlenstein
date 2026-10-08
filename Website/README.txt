MÜHLENSTEIN · PAKET FÜR AMOSYSTEMS
Stand: 8. Oktober 2026 · App 1.3.1 (11)

Dieses Paket enthält die Inhalte für eine Ergänzung von amosystems.org.
Die Website wurde nicht verändert. Neue Routen sind Vorschläge, noch keine
veröffentlichten Adressen. Die Texte passen zur vorhandenen deutschen und
englischen Produktkarte mit Detailbereich und fünf Kernfunktionen.

SCHNELLSTART
1. index.html öffnen: lokale Übersicht mit Texten, Bildauswahl und Downloads.
2. content/de/product.json bzw. content/en/product.json ins CMS übernehmen.
   Texte sind zusätzlich als HTML-Fragmente und UTF-8-Text enthalten.
3. Für die bestehende Dreiergalerie empfehlen wir Spiel, Neue Partie und WLAN.
   Tipp und Startseite sowie iPad-Aufnahmen sind weitere Optionen.
4. Bilder aus screenshots/web verwenden; PNG ist der Fallback zu WebP.
   Originale in screenshots/original sind pixelidentische App-Aufnahmen.
5. Datenschutz- und Supportseiten anlegen und aus Produktkarte, Detailbereich,
   Datenschutzübersicht und Supportübersicht verlinken.

INHALT
- content/de, content/en: Produktkarte, Langbeschreibung, fünf Funktionen,
  SEO-Texte, FAQ/Support, App-Datenschutz und Herkunft/Lizenzhinweise;
  jeweils JSON, HTML-Fragment und Klartext. JSON enthält Bildunterschriften
  und Alternativtexte, damit diese beim Website-Einbau erhalten bleiben.
- screenshots/original: 80 PNGs, fünf Motive je Sprache und Gerätetyp;
  Deutsch, Englisch, Französisch, Spanisch, Japanisch, Koreanisch sowie
  vereinfachtes und traditionelles Chinesisch. iPhone: 1320 × 2868;
  iPad: 2064 × 2752. Keine nachgestellten Oberflächen oder Retuschen.
- screenshots/web: 20 DE/EN-Aufnahmen in verkleinerter, unbeschnittener Form,
  jeweils PNG und verlustfreies WebP. iPhone-Breite 660, iPad-Breite 1032.
- brand: originales App-Icon in Standard-, dunkler und getönter Variante;
  semantische Farbwerte. Standard ist Schieferblau #4A6074 auf Beige #EDE8DD.
  Für Produktkarten das Standard-Icon verwenden. Das getönte Icon ist eine
  iOS-Systemvorlage und nicht die Standardmarke der Website.
- legal: unveränderte AGPL-Lizenz, zusätzliche App-Store-Genehmigung,
  vollständige gebündelte Lizenzhinweise und Rust-Lizenzanhang.
- sources: öffentliche Produktdaten und Quellenbelege, keine Zugangsdaten.
- asset-manifest.json: Abmessungen, Sprache, Motiv, SHA-256, Bildtexte.
- checksums.sha256: Prüfsummen aller Paketdateien außer dieser Liste selbst.

EINBAU IN DIE BESTEHENDE WEBSITE
Deutsch: Produktkarte und Detailbereich /#muehlenstein;
  App-Datenschutz /datenschutz/muehlenstein;
  Hilfe /app-support/muehlenstein.
Englisch: /en/#muehlenstein;
  App-Datenschutz /en/privacy/muehlenstein;
  Hilfe /en/support/muehlenstein.
Diese Pfade sind im CMS anzulegen; das Paket veröffentlicht sie nicht.
Die neuen produktspezifischen Seiten ergänzen das bestehende Impressum und
die allgemeinen Datenschutzhinweise. Sie ersetzen diese nicht.

Die HTML-Fragmente enthalten keine fremden Schriftarten, Skripte oder Tracker.
Sie verwenden semantische Überschriften, Absätze und Listen. Beim Import die
Überschriftenebenen an das bestehende Seitentemplate anpassen. Beispielbilder
im HTML verwenden Pfade relativ zum Paket; im CMS auf die Zielpfade abbilden.
Explizite Bildbreite und -höhe übernehmen, proportional darstellen und nicht
beschneiden. Für kleine Screenshots object-fit: contain verwenden. Unterhalb
des ersten sichtbaren Bereichs loading="lazy" setzen; Alt-Texte mitliefern.

Es ist kein nachgezeichnetes Apple-Badge enthalten. Der Textlink zum App Store
ist sofort verwendbar; für ein Badge Apples offizielles Marketingmaterial
in der passenden Sprache und unter dessen Nutzungsbedingungen verwenden.

VERÖFFENTLICHUNGSSTAND UND QUELLEN
Apples öffentliche Lookup-API bestätigt am 08.10.2026 Version 1.3.1,
0,99 EUR im deutschen Store, iOS 18 und Altersfreigabe 4+.
Veröffentlichungszeitpunkt laut Apple: 2026-10-08T08:53:55Z.
Die zunächst über die Websuche gelesene Store-Seite zeigte noch 1.2;
die direkt geladene Apple-API ist der neuere Nachweis. Produktdaten und
Funktionsaussagen wurden mit Quelltag v1.3.1 und den Release-Unterlagen
abgeglichen. Screenshot-Prüfsummen entsprechen Store/Screenshots/manifest.json.
Die Abbildungen zeigen Beispielpartien und die Netzwerkeinrichtung; das
Netzwerkbild ist keine Aufnahme einer laufenden Partie auf zwei Geräten.

https://apps.apple.com/de/app/m%C3%BChlenstein/id6818139673
https://itunes.apple.com/lookup?id=6818139673&country=de
https://github.com/MrFam0s/Muehlenstein/tree/v1.3.1
https://amosystems.org
https://amosystems.org/en
https://amosystems.org/datenschutz
https://amosystems.org/impressum

App-Datenschutz: aus dem tatsächlichen Verhalten von 1.3.1 und den bisherigen
Docs/PRIVACY.md abgeleitet, mit Website-Verweisen statt GitHub-Hostingtext.
Name, Kontakt und Support-Aufbewahrung entsprechen den am 08.10.2026 gelesenen
AmoSystems-Seiten. Hosting und Server-Protokolle werden über die bestehende
allgemeine Datenschutzerklärung abgedeckt. Der lokale Netzwerkmodus überträgt
Daten an den Mitspieler; deshalb nicht pauschal „keine Datenübertragung“ schreiben.
Rechtsgrundlagen und Rechte: DSGVO, insbesondere Art. 6, 13 und 15–21;
https://eur-lex.europa.eu/eli/reg/2016/679/oj
Die bestehende Lizenzprüfung einschließlich ihrer Restfragen bleibt unter
https://github.com/MrFam0s/Muehlenstein/blob/main/Docs/LICENSE_REVIEW.md erhalten.
Das Paket trifft keine neue Aussage zur historischen Rechtekette.

NICHT ALS FUNKTION VERSPRECHEN
Kein Internet-Matchmaking, kein Game Center, kein Elo-Rating, keine perfekte
Endspieldatenbank, keine Sprachmodell-KI, keine Cloud-Synchronisierung.
Tipps und Rücknahme gibt es nicht in WLAN-Partien. Eine vollständige
VoiceOver-Zertifizierung oder barrierefreie Bedienbarkeit wurde nicht geprüft.
Der Preis kann sich ändern und variiert zwischen Ländern; Apple ist maßgeblich.

PFLEGE UND ERZEUGUNG
Quelltexte: Website/de.json, Website/en.json.
Paket erzeugen: python3 Scripts/package-website.py --output /absoluter/Zielordner
Benötigt Python 3 und Pillow. Zielordner und danebenliegende ZIP-Datei dürfen
noch nicht existieren. Das Skript verändert weder die App noch die Website.
Die Fakten in Website/release-facts.json vor einem neuen Release erneut
abgleichen; sie werden nicht durch bloßes erneutes Verpacken aktualisiert.
