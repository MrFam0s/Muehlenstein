# Lokale Netzwerkpartien

Implementierungsstand: 07.10.2026, nach dem Quellrelease 1.2 (8). Noch kein neuer Store-Upload oder Versions-Tag.

## Bedienung

1. Auf beiden Geräten dasselbe WLAN verwenden und Mühlenstein Zugriff auf das lokale Netzwerk erlauben.
2. **Neue Partie → WLAN** wählen. Die eröffnende Person wählt die Spielvariante und anschließend **Über WLAN spielen → Partie anbieten**.
3. Die zweite Person wählt **Partie suchen** und die angebotene Partie. Die eröffnende Person bestätigt die Einladung mit **Annehmen**. Es gibt keinen einzugebenden Code.
4. Die Partie öffnet sich auf beiden Geräten. Die eröffnende Person spielt Weiß, die beitretende Person Schwarz. Alle vier Varianten funktionieren mit denselben Regeln wie im Offline-Modus.

Die vorhandene Rückfrage zum Ersetzen einer laufenden Partie bleibt direkt im Startknopf. Ein abgebrochener oder abgelehnter Verbindungsversuch ersetzt keinen Spielstand. Die Auswahl einer Spielvariante auf dem beitretenden Gerät wird nicht verwendet; die angebotene Partie bestimmt die Regeln.

**Verbindung** steht in der unteren Leiste und im Mehr-Menü. Bei einer Unterbrechung bleibt das Brett stehen und nimmt keine Züge an. Zum Fortsetzen dieselbe gespeicherte Partie auf beiden Geräten öffnen; falls nötig **Verbindung → Erneut verbinden** wählen. Der ursprüngliche Partner wird anhand der gespeicherten Partiekennung und eines geheimen Wiederverbindungsschlüssels erkannt. Er benötigt keine erneute Einladung. Nach App-Neustart wird erst beim Öffnen der Partie gesucht, nicht auf der Startseite.

Wer eine neue Partie startet, ersetzt damit den bisherigen lokalen Spielstand. Wird die gemeinsame Partie auf einem Gerät ersetzt oder die App gelöscht, ist eine Wiederaufnahme mit diesem Gerät nicht mehr möglich. Nach Spielende lässt sich wieder eine neue Netzwerkpartie anbieten; ein gemeinsamer automatischer Rückkampf ist nicht Teil dieses Standes.

Computertipps und einseitiges Zurücknehmen sind im Netzwerkmodus deaktiviert. Die persönlichen Darstellungsoptionen, Zugzielmarkierungen, Zugliste und Regeln bleiben verfügbar. Die Partie und die Startseite bleiben ohne Scrollen. Nur die Geräteliste und die Verbindungshilfe bei sehr wenig Platz dürfen scrollen.

## Technik und Verantwortung

- Eigene Swift-Implementierung mit Apples **Multipeer Connectivity**, derselben Systemgrundlage wie in „Besser Lesen“. Keine zusätzliche Bibliothek, kein Benutzerkonto, kein Game Center und kein Spielserver.
- `NearbyMatchTransport` kapselt Bonjour-Suche, Einladungsverbindung und genau einen Gegenpart. `MCSession` verlangt Verschlüsselung und sendet zuverlässig. Eine zunächst aufgebaute Transportverbindung gibt noch keinen Spielstand frei; das geschieht erst nach der sichtbaren Zustimmung.
- `LocalMatchSession` besitzt die Netzwerkpartie. `GameStore` zeigt ihre geprüfte Projektion an und speichert sie atomar. Offline-Partien behalten ihren bisherigen Ablauf.
- Weiß ist die maßgebliche Quelle für die Zugfolge. Schwarz sendet einen Zugvorschlag mit erwartetem Aktionsindex und SHA-256 der bisherigen Zugfolge. Nur erlaubte Züge der richtigen Farbe werden übernommen. Auch Schlagen ist eine eigene Aktion, sodass dieselbe Farbe bei einer Mühle weiterhin am Zug bleibt.
- Beide Geräte spielen jeden übernommenen Stand mit dem vorhandenen Rust-Regelkern nach. Akteursfolge, Variante, vollständige bisherige Zugfolge und resultierende FEN müssen zusammenpassen. Protokollversion und festgehaltener Engine-Stand müssen übereinstimmen.
- Der Host wartet auf die Bestätigung des übertragenen Standes; der Gast verändert sein Brett erst bei Empfang des bestätigten Host-Standes. Wiederholte alte Zugvorschläge führen nur zum erneuten Versand des aktuellen Standes. Verspätete Bestätigungen schalten keinen neueren Stand frei.
- Bei Wiederaufnahme bleibt die gespeicherte Host-Zugfolge maßgeblich. Ein bereits vom Host gespeicherter, aber noch nicht zugestellter Zug wird nachgeliefert. Eine nie beim Host eingegangene Gästeingabe wird nicht als ausgeführter Zug behandelt. Der Gast akzeptiert kein Zurücksetzen oder Umschreiben seiner gespeicherten Zugfolge.
- Nachrichten sind auf 256 KiB begrenzt, Zugfolgen entsprechend der vorhandenen Engine auf 2.048 Aktionen, Notationen auf 16 UTF-8-Bytes. Verbindungs-/Bestätigungsversuche enden nach 20 Sekunden; eine offene Einladung nach 60 Sekunden. Warteaufgaben werden beim Abbruch abgeräumt. Rückrufe alter Transportinstanzen werden ignoriert.
- Beim Verlassen der Partie oder beim Wechsel in den Hintergrund pausiert Mühlenstein bewusst die Verbindung. Bloße Inaktivität durch einen iOS-Berechtigungsdialog beendet sie nicht.

## Datenschutz und Grenzen

Bonjour veröffentlicht nur eine zufällige Partiekennung, Variante und Protokollversion. Die App verwendet keine persönlichen Gerätenamen. Zugfolge und geheimer Wiederverbindungsschlüssel werden nur über die verschlüsselte Verbindung übertragen und innerhalb des lokalen Spielstands aufbewahrt. Keine Übertragung an AmoSystems oder einen anderen Spielserver. App-interne Datenschutzhinweise sowie die lokale Netzwerkberechtigung sind in allen acht App-Sprachen ergänzt.

Dies ist ein Modus für zwei zustimmende Personen im lokalen Netz. Er ist kein manipulationsgeschütztes Ranglistensystem: Der Host besitzt den maßgeblichen Spielstand; die Einladung authentifiziert keine bürgerliche Identität. Öffentliches Internetspiel, Vermittlungsserver, Turnierwertung, Schachuhren und Zuschauer sind nicht implementiert. Gast-WLANs mit Geräteisolierung, VPNs oder verweigerte Netzwerkfreigaben können die Suche verhindern. Dann erscheint die Verbindungshilfe mit einem Link zu den App-Einstellungen.

Apple-Grundlagen: [Multipeer Connectivity](https://developer.apple.com/documentation/multipeerconnectivity) und [TN3179: Local network privacy](https://developer.apple.com/documentation/technotes/tn3179-understanding-local-network-privacy). `NSBonjourServices` enthält `_muehlenstein._tcp`; `NSLocalNetworkUsageDescription` ist lokalisiert. Es wird ausschließlich die Systemverschlüsselung verwendet. Die Einladung bestätigt einen lokalen Mitspieler, keine geprüfte Identität.

## Prüfung

Siehe `VALIDATION.md` für ausgeführte Prüfungen und verbleibende Grenzen. Die beiden gezielten UI-Tests `testLocalNetworkHostOnSecondSimulator` und `testLocalNetworkGuestOnSecondSimulator` müssen zeitgleich auf zwei Testzielen laufen (Simulatoren oder physisches Gerät); `NETWORK_E2E=1` in der Umgebung des UI-Test-Runners schaltet sie ein. Im normalen Testlauf werden sie ausdrücklich übersprungen. Die Protokolltests benötigen keinen Netzwerkzugriff und laufen regulär.
