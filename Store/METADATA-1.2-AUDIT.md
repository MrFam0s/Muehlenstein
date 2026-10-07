# Store-Sprachprüfung für 1.2 (8)

Am 06.10.2026 live aus App Store Connect gelesen. Die zuvor veröffentlichte
Version 1.0.2 enthielt nur Deutsch und Englisch. Die Beschreibungen nannten
nur diese zwei Oberflächensprachen. Der englische Untertitel enthielt bereits
„Nine Men’s Morris, your pace“; im Keyword-Feld fehlte der Spielname.

Version 1.2 enthält jetzt acht vollständig befüllte Store-Lokalisierungen.
Alle 16 kanonischen JSON-Dateien (App-Info und Version) stimmen nach erneutem
Abruf feldgenau mit Apple überein. `asc metadata validate` meldet keine Fehler
oder Warnungen. Geprüft: Produktname, Untertitel, Beschreibung, Keywords,
Werbetext, Versionshinweise und Support-/Datenschutz-URLs. Alle Sprachen
beschreiben dieselben vier Spielvarianten, fünf Schwierigkeitsstufen,
Offline-Partien und die tatsächliche Sprachabdeckung. Die Versionshinweise
enthalten auch die seit der letzten Store-Version hinzugekommenen Farben.

| Sprache | Untertitel | Keyword-Zeichen | Keywords |
| --- | --- | --- | --- |
| `de-DE` | Mühle in deinem Tempo | 85/100 | mühle,muehle,Brettspiel,Strategie,Morris,Morabaraba,Lasker,offline,Denksport,zu zweit |
| `en-US` | Nine Men’s Morris, your pace | 88/100 | nine men's morris,board,strategy,mill,merels,morabaraba,lasker,offline,two players,brain |
| `es-ES` | El molino a su ritmo | 87/100 | molino,nueve fichas,morris,estrategia,mesa,morabaraba,lasker,sin conexión,dos jugadores |
| `fr-FR` | Jeu du moulin à votre rythme | 90/100 | moulin,mérelles,marelle,stratégie,plateau,morris,morabaraba,lasker,hors ligne,deux joueurs |
| `ja` | 自分のペースでナイン・メンズ・モリス | 47/100 | ナインメンズモリス,ミル,ボードゲーム,戦略,オフライン,二人対戦,思考,モラバラバ,ラスカー |
| `ko` | 내 속도로 즐기는 나인 멘스 모리스 | 41/100 | 나인멘스모리스,밀,보드게임,전략,오프라인,2인용,두뇌게임,모라바라바,라스커 |
| `zh-Hans` | 按自己的节奏，享受九子棋 | 58/100 | 九子棋,磨坊棋,直棋,棋类,策略,桌游,离线,双人,十二子棋,益智,Morris,Morabaraba,Lasker |
| `zh-Hant` | 依自己的步調，享受九子棋 | 58/100 | 九子棋,磨坊棋,直棋,棋類,策略,桌遊,離線,雙人,十二子棋,益智,Morris,Morabaraba,Lasker |

Die englischen Keywords enthalten nun ausdrücklich `nine men's morris`.
Die Beschreibungen von TestFlight und die Testhinweise wurden ebenfalls in
allen acht Sprachfassungen gespeichert und erneut ausgelesen. Die Hinweise
fordern Sprach-, Speicher-, Schwierigkeits- und Ausrichtungstests an.

Die Begriffe wurden an den nativen Spielbezeichnungen und der lokalen
Terminologie ausgerichtet. Vergleichsquellen: [französischer Store-Eintrag](https://apps.apple.com/fr/app/jeu-du-moulin-strat%C3%A9gie/id6758569479),
[spanischer Store-Eintrag](https://apps.apple.com/es/app/juego-del-molino-estrategia/id6758569479),
[japanischer Store-Eintrag](https://apps.apple.com/jp/app/id1447724110),
[koreanischer Store-Eintrag](https://apps.apple.com/kr/app/morris-friend/id6452083786)
und [chinesischer Store-Eintrag](https://apps.apple.com/cn/app/id1393443791).
Apples [Produktseiten-Dokumentation](https://developer.apple.com/app-store/product-page/)
definiert die 100-Zeichen-Grenze für Keywords. Diese Prüfung bestätigt die
hinterlegten Inhalte und deren Grenzen; sie ist keine Messung von Suchvolumen
oder Suchplatzierung.

Lokale Nachweise: `.build/Release-1.2-8/metadata-before/`,
`metadata-verified/`, `version-metadata-applied.json`,
`beta-app-localizations-verified.json` und `test-notes-verified.json`.
Die neuen Store-Texte gehören zur eingereichten Version 1.2 und werden mit
deren Veröffentlichung öffentlich sichtbar.
