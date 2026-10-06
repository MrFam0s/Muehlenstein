# Versionshinweise

## Noch nicht als Release markiert — 06.10.2026

- Neue Partien beginnen zunächst mit Stufe 1 · Sehr leicht. Danach wird die
  zuletzt bestätigte Spielstärke für weitere Partien und App-Neustarts gemerkt.
  Dies gilt beim Partiestart und bei Änderungen unter Spielstärke. Abbrechen
  und eine zwischendurch gespielte lokale Partie ändern die gemerkte Stufe nicht.

## 1.1 — 02.10.2026

App-Version **1.1**, Build **7**, Quelltag **v1.1**.

- Schieferblau als Standard für Spiel und App-Icon sowie als erste Farboption.
- Rosé ergänzt die Auswahl, angelehnt an die Wildrose-Palette aus „Besser Lesen“
  und im Hellmodus für gut lesbare Beschriftungen angepasst.
- Bestehende gespeicherte Farbentscheidungen bleiben erhalten.
- Diese Quellversion folgt dem eingereichten Build 6. Für 1.1 wurden noch
  kein Gerätearchiv, App-Store-Upload oder Review-Antrag erstellt.

## 1.0.2 · Build 6 — 01.10.2026

Neuer Distributionsbuild für die erste App-Store-Einreichung. Quelltag:
**v1.0.2-build.6**; der ursprüngliche Tag **v1.0.2** bleibt unverändert.

- Das Standard-App-Icon übernimmt die bestätigte invertierte Farbvariante:
  beiger Hintergrund (#EDE8DD), waldgrünes Brettmotiv (#4F624A) und Graphitstein.
  Generator und Icon-Vorschau sind aktualisiert.
- Buildnummer und Versionsanzeige-Test auf **6** angehoben. Release-Archiv
  und App-Store-Export erfolgreich; das aktuelle Icon ist im Archiv geprüft.
- Die vorhandenen Release-Tests für Versionsanzeige, Anbieterangaben und
  gebündelte Lizenztexte bestehen. Die Store-Aufnahmen sind aktualisiert.

## 1.0.2 — 01.10.2026

App-Version **1.0.2**, Build **5**, Quelltag **v1.0.2**. Kein App-Store-Upload
oder Review-Antrag; die bisherigen Tags bleiben unverändert.

- Eigenständiges Mühle-Signet mit drei sanft gerundeten Quadraten in
  Rautenform und zwei gegenüberliegenden Spielsteinen. Logo und App-Icon
  entstehen aus derselben editierbaren Vektorgeometrie.
- Waldgrünes Standard-Icon, passende Dunkelvariante und Graustufenvorlage
  für iOS-Tönung. Das Logo in der App folgt weiterhin der gewählten Palette;
  die bestätigte Anordnung von Logo und Name bleibt erhalten.
- Versionsschema anhand von Apples Dokumentation geklärt: Auch Patchversionen
  wie 1.0.1 und 1.0.2 sind vorgesehen; 1.1 ist nicht erforderlich. Quellen und
  Abgrenzung zur Buildnummer stehen in [RELEASE.md](Docs/RELEASE.md).

## 1.0.1 — 01.10.2026

App-Version **1.0.1**, Build **4**, Quelltag **v1.0.1**. Diese Version bündelt
die seit `v1.0` umgesetzten Verbesserungen an Gestaltung und Bedienung.
Noch kein App-Store-Upload oder Review-Antrag.

- Beim Ersetzen einer laufenden Partie erfolgt die Bestätigung direkt im
  Startknopf. Die zusätzliche Einblendung entfällt; beendete Partien starten
  weiterhin ohne Bestätigung neu.

- Waldgrün ist der neue Standardakzent. Unter „Darstellung“ sind außerdem
  Schieferblau, Aubergine, Terrakotta und Petrol wählbar. Die Auswahl gilt sofort
  für die gesamte Oberfläche in Hell und Dunkel und wird dauerhaft gespeichert.
  Alle fünf Paletten sind auf Text- und Brettkontrast geprüft.

- Logo und Name auf der Startseite behalten ihre freigegebene Position zwischen
  Werkzeugleiste und Vorschaubrett. Die Unterzeile entfällt.
- Alle Lizenzansichten führen feste Textdatei-Zeilen zu lesbaren Absätzen zusammen.
  Überschriften und Listen bleiben gegliedert; Sanmills Markdown-Hervorhebungen
  und Verweise werden formatiert. Die Originaldateien bleiben unverändert.
- „Über Mühlenstein“, Impressum, Datenschutz, Herkunft und Lizenzinformationen
  sind durchgehend scrollbar. Klar gegliederte Abschnitte, lesbare Textbreiten
  und Blocksatz mit Silbentrennung bei ausreichend breiten Zeilen verbessern
  den Textfluss. Bei schmalen Zeilen und großer Schrift bleibt Text linksbündig.

- Impressum mit „Entwickelt mit ♥ in Berlin“ bzw. „Developed with ♥ in Berlin“.
- In der Partie sind Vorratsanzeige und Bedienleiste im Hochformat
  auf die Brettbreite abgestimmt; das Brett sitzt mit gleichen Abständen
  dazwischen. Im Querformat stehen Status und Bedienelemente mittig neben dem Brett.
- Klare Einstellungswege: Regelbuch statt Zahnrad auf der Startseite; Darstellung
  und Spielstärke im Mehr-Menü der Partie. Die Partiekonfiguration bleibt bei
  „Neue Partie“.
- Zugziele und letzter Zug sind anfangs aus. Der umgekehrte Schalter
  „Steinanimationen deaktivieren“ ist ebenfalls aus; sanfte Bewegungen bleiben
  dadurch aktiv. Gespeicherte Einstellungen bleiben erhalten.

- In der Übersicht „Über Mühlenstein“ stehen im Kopf nur noch App-Name und
  Version/Build. Die zusätzliche Anbieterzeile entfällt; das Impressum bleibt
  vollständig.

## 1.0 — 01.10.2026

Erste markierte Quellversion der nativen Offline-App. App-Version **1.0**,
Build **3**, Git-Tag **v1.0**. Noch nicht im App Store eingereicht oder
veröffentlicht.

- Vier Spielvarianten: klassische Mühle, Zwölfstein-Mühle, Morabaraba und Lasker-Mühle.
- Offline-Computer mit fünf Spielstufen, erweitertem Such-/Spielstilangebot
  und kleinem klassischem Eröffnungsbuch; alternativ zwei Personen an einem Gerät.
- Grafische, ausblendbare Zugtipps mit Erklärungen, Rücknahme, Zugverlauf und
  automatische lokale Speicherung.
- Native deutsche und englische Oberfläche für iPhone und iPad, Hell/Dunkel,
  Hoch-/Querformat und abschaltbare sanfte Steinanimationen.
- Anbieter-, Versions- und vollständige Lizenzinformationen in der App;
  Datenschutzmanifest, öffentliche Support-/Datenschutzseiten, Store-Texte
  und 16 Original-Screenshots vorbereitet.

Die Markierung 1.0 ändert gegenüber dem vorherigen Vorbereitungsstand nur die
App-Version, Buildnummer, den bestehenden Versionsanzeige-Test und die
Dokumentation. Regeln, KI, Datenformat und Spieloberfläche bleiben gleich.
Die interne Rust-Brücke behält ihre eigene Paketversion 0.1.0; übernommene
Abhängigkeiten und Lizenznachweise werden dadurch nicht umversioniert.

[Prüfprotokoll](Docs/VALIDATION.md), [Store-Vorbereitung](Store/README.md)
und [verbleibende Einreichungsschritte](Docs/RELEASE.md) dokumentieren den
Stand. Netzwerkspiel sowie vollständige VoiceOver- und Akkuprüfungen bleiben
zurückgestellt. Die bekannte Rechteketten-Restfrage bleibt in der
[Lizenzprüfung](Docs/LICENSE_REVIEW.md) erhalten.
