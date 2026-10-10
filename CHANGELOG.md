# Versionshinweise

## 1.4 · Build 13 — App-Store- und TestFlight-Distribution (10.10.2026)

- Distributionsbuild für den bereits vorbereiteten Funktionsumfang von 1.4.
  Produktcode, Engine und Abhängigkeiten entsprechen dem Quellrelease Build 12.
- Buildnummer auf **13** angehoben; neuer Quelltag **v1.4-build.13**.
  Der bestehende Tag **v1.4** bleibt unverändert.
- Versionshinweise und TestFlight-Testhinweise in acht Sprachen gespeichert
  und bei Apple abgeglichen. 80 aktuelle Store-Aufnahmen vollständig verarbeitet.
- Am 10.10.2026 für App Store und TestFlight eingereicht; beide Apple-Prüfungen
  stehen noch aus. Store-Veröffentlichung und Testerbenachrichtigung erfolgen
  automatisch nach der jeweiligen Freigabe. 44 Release-Prüfungen sowie beide
  Screenshotdurchläufe bestanden.
- [Aktueller Prüf- und Distributionsstand](Store/RELEASE-1.4-13.md).

## 1.4 · Build 12 — Rückblick und Spielrückmeldungen (10.10.2026)

Quellrelease **v1.4**. Noch kein Upload oder Review-Antrag bei Apple für diesen
Build. [Releaseprotokoll](Store/RELEASE-1.4-12.md).

- Jeder angezeigte Tipp und jede ausgeführte Rücknahme werden dauerhaft im Verlauf festgehalten. Rücknahmen löschen diese Hinweise nicht; zurückgenommene Züge bleiben durchgestrichen sichtbar. Die Spieldetails zeigen beide Anzahlen.
- Ein abgebrochener Tipp und das Ausblenden eines bereits sichtbaren Tipps zählen nicht erneut. Eine neue Partie beginnt mit eigenen Zählern. Ältere Spielstände bleiben lesbar und kennzeichnen ihre frühere, noch nicht aufgezeichnete Nutzung.
- Sieg und Remis erscheinen in einer eigenen Abschlusskarte mit Lorbeerzeichen, Spielstein, App-Farben und Serifenschrift. Sie enthält nur „Partie beendet“ und das Ergebnis. „Brett ansehen“ schließt sie; eine Zielflagge bleibt am Ergebnis sichtbar. Die Bestätigung bleibt beim erneuten Öffnen gespeichert.
- Jeder Verlaufseintrag lässt sich auf einem eigenen Brett ansehen. Pfeile und Schieberegler führen durch Züge, Tipps und Rücknahmen einschließlich verworfener Zugfolgen. „Partie ansehen“ beginnt bei der Ausgangsstellung. Die Rückschau verändert weder Spielstand noch Hilfen-Zähler.
- Bei aktivierten Zugzielen erhalten erlaubte Schlagziele einen ruhigen leuchtenden Rand. Geschützte Steine und Computerzüge erhalten keine Markierung.
- Texte und Erläuterungen in allen acht App-Sprachen, mit je 230 Textschlüsseln.

## 1.3.1 · Build 11 — Anfängermodus und ruhige Einrichtung (08.10.2026)

- Stufe 1 spielt ohne Vorausberechnung, übersieht Chancen und Drohungen und wählt Abnahmen nicht mehr gezielt nach Stärke. Stufen 2–5 bleiben unverändert; Tipps bleiben eine gesonderte berechnete Hilfe.
- Spielstärke steht unter der Spielvariante. Zu zweit und WLAN deaktivieren Computeroptionen, ohne deren Platz oder die Höhe der Einrichtung zu verändern.
- Erläuterungen in allen acht App-Sprachen aktualisiert. Vergleichspartien und Prüfstand stehen in `Docs/AI_OPTIONS.md` und `Docs/VALIDATION.md`.
- Distributionsbuild **1.3.1 (11)**; Quelltag **v1.3.1**. Seit 08.10.2026 im App Store veröffentlicht. Der bestehenden TestFlight-Gruppe zugeordnet; Apples separate Beta-Freigabe steht noch aus (geprüft am 08.10.2026, 20:55 Uhr Europe/Berlin). [Releaseprotokoll](Store/RELEASE-1.3.1-11.md).

## 1.3 — Lokale Netzwerkpartien (08.10.2026)

App-Version **1.3**, Build **9**, Quelltag **v1.3**. Am 08.10.2026 zur
App-Store-Prüfung eingereicht (`WAITING_FOR_REVIEW`); automatische
Veröffentlichung nach Freigabe. [Releaseprotokoll](Store/RELEASE-1.3-9.md).

- Auf zwei Geräten im selben WLAN spielen; die eröffnende Person nimmt die Einladung an, ohne Kopplungscode.
- Alle vier Spielvarianten mit synchronisierten, beidseitig geprüften Zügen und gespeicherter Wiederverbindung.
- Unterbrochene Verbindungen pausieren das Brett. Kein einseitiges Zurücknehmen und keine Computertipps im Netzwerkmodus.
- Verbindungsauswahl, Datenschutzhinweise und Netzwerkberechtigung in allen acht App-Sprachen.
- Store-Texte in allen acht Sprachen und zusätzliche Originalaufnahmen der WLAN-Einrichtung.

## 1.2 — 06.10.2026

App-Version **1.2**, Build **8**, Quelltag **v1.2**. Dieser Quellrelease bündelt
die neuen Sprachfassungen und die gemerkte Spielstärke. Build 8 ist bei Apple
hochgeladen und zur App-Store- sowie TestFlight-Beta-Prüfung eingereicht.
Automatische Store-Veröffentlichung nach Apple-Freigabe. Store-Texte und
aktuelle Aufnahmen decken alle acht Sprachfassungen ab.
[Distributionsnachweis](Store/RELEASE-1.2-8.md); bestehende Tags bleiben unverändert.

- Fünf zusätzliche native Sprachen: Japanisch, Koreanisch, Chinesisch,
  Französisch und Spanisch. Chinesisch ist in vereinfachter und traditioneller
  Schrift enthalten; damit acht vollständige Offline-Sprachfassungen mit je
  181 Texten. Auswahl durch iOS; Regeln, KI-Erklärungen, Hinweise, Datenschutz
  und Impressum eingeschlossen. Original-Lizenztexte bleiben erhalten.
- Übersetzungsprüfung und Xcode-Sprachressourcen-Synchronisierung ergänzen
  die Pflegewerkzeuge. [Auswahl und Pflege](Docs/LOCALIZATION.md).
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
- Diese Version folgt dem eingereichten Build 6. Am 02.10.2026 für TestFlight
  hochgeladen und der bestehenden externen Testergruppe zugeordnet; der damals
  bestätigte Status war ausstehende Beta-Prüfung. [TestFlight-Protokoll](Store/TESTFLIGHT-1.1-7.md).

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
