#!/usr/bin/env python3
"""Authoritative bilingual copy and semantic design colors for the prototype."""
import json, plistlib
from pathlib import Path
root = Path(__file__).resolve().parent.parent
resources = root / 'App/Resources'
copy = {
'app_name': ('Mühlenstein', 'Muehlenstein'),
'game_details': ('Spieldetails', 'Game details'),
'history_moves': ('Züge', 'Moves'),
'hint_explanation': ('Zum Zugvorschlag', 'About this suggestion'),
'hint_fact_wins': ('Dieser Zug beendet die Partie mit einem Sieg für dich.', 'This move ends the game with a win for you.'),
'hint_fact_mill': ('Schließt eine Mühle. Danach darfst du einen gegnerischen Stein entfernen.', 'Completes a mill. You can then remove an opponent’s stone.'),
'hint_fact_multiple_mills': ('Schließt mehrere Mühlen zugleich. In dieser Variante darfst du deshalb mehrere gegnerische Steine entfernen.', 'Completes several mills at once. In this variant, you can therefore remove several opposing stones.'),
'hint_fact_capture': ('Entfernt diesen gegnerischen Stein. Das verringert die Zahl der gegnerischen Steine auf dem Brett.', 'Removes this opposing stone, reducing the opponent’s stones on the board.'),
'hint_fact_blocks_line': ('Besetzt den freien Punkt einer Linie mit zwei gegnerischen Steinen. Diese Linie ist damit vorerst blockiert.', 'Occupies the empty point on a line containing two opposing stones, blocking that line for now.'),
'hint_fact_builds_line': ('Bringt zwei deiner Steine in eine Mühllinie mit einem freien Punkt. Daraus kann später eine Mühle entstehen.', 'Brings two of your stones onto a mill line with one empty point, creating a possible future mill.'),
'hint_from_book': ('Die Empfehlung stammt aus dem Eröffnungsbuch für diese Stellung. Es enthält bekannte Eröffnungszüge, garantiert aber keinen Gewinn.', 'The recommendation comes from the opening book for this position. It contains known opening moves, but does not guarantee a win.'),
'hint_from_search': ('Die Empfehlung stammt aus der Vorausberechnung mit der gewählten Spielstufe.', 'This recommendation comes from looking ahead at the selected difficulty.'),
'reserve_count': ('%d im Vorrat', '%d in reserve'),
'side_counts': ('%@: %d auf dem Brett, %d im Vorrat', '%@: %d on board, %d in reserve'),
'previous_page': ('Vorherige Seite', 'Previous page'), 'next_page': ('Nächste Seite', 'Next page'),
'page_count': ('%d / %d', '%d / %d'),
'new_game': ('Neue Partie', 'New game'), 'continue_game': ('Partie fortsetzen', 'Continue game'),
'view_game': ('Partie ansehen', 'View game'), 'learn_rules': ('Mühle kennenlernen', 'Learn to play'),
'about': ('Über Mühlenstein', 'About Muehlenstein'), 'notice': ('Hinweis', 'Notice'), 'ok': ('OK', 'OK'),
'cancel': ('Abbrechen', 'Cancel'), 'done': ('Fertig', 'Done'), 'start_game': ('Partie beginnen', 'Start game'),
'opponent': ('Gegenspieler', 'Opponent'), 'computer': ('Computer', 'Computer'), 'local': ('Zu zweit', 'Two players'),
'difficulty': ('Spielstärke', 'Difficulty'), 'level_1': ('Sehr leicht', 'Very easy'), 'level_2': ('Leicht', 'Easy'), 'level_3': ('Mittel', 'Medium'), 'level_4': ('Schwer', 'Hard'), 'level_5': ('Sehr schwer', 'Very hard'),
'you_play_white': ('Du spielst mit den hellen Steinen und beginnst.', 'You play the light stones and move first.'),
'local_description': ('Spielt abwechselnd auf diesem Gerät.', 'Take turns on this device.'),
'variant': ('Spielvariante', 'Variant'),
'classic': ('Klassische Mühle', 'Nine Men’s Morris'), 'classic_detail': ('9 Steine', '9 stones'),
'classic_rules': ('Jede Seite beginnt mit neun Steinen. Die Ecken der Quadrate sind nicht diagonal verbunden.', 'Each side begins with nine stones. The corners of the squares have no diagonal connections.'),
' twelve': ('', ''),
'twelve': ('Zwölfstein-Mühle', 'Twelve Men’s Morris'), 'twelve_detail': ('12 Steine · zusätzliche Diagonalen', '12 stones · additional diagonals'),
'twelve_rules': ('Zwölf Steine pro Seite. Diagonale Linien verbinden zusätzlich die Ecken der Quadrate; auch dort können Mühlen entstehen.', 'Twelve stones per side. Diagonal lines also connect the corners of the squares and can form mills.'),
'morabaraba': ('Morabaraba', 'Morabaraba'), 'morabaraba_detail': ('12 Steine · doppelte Mühlen zählen', '12 stones · double mills count'),
'morabaraba_rules': ('Zwölf Steine und Diagonalen. Wenn ein Zug mehrere neue Mühlen schließt, darfst du entsprechend mehrere gegnerische Steine entfernen.', 'Twelve stones and diagonal lines. A move that forms multiple new mills allows multiple captures.'),
'lasker': ('Lasker-Mühle', 'Lasker Morris'), 'lasker_detail': ('10 Steine · früher in Bewegung', '10 stones · move during placement'),
'lasker_rules': ('Zehn Steine pro Seite. Schon während des Setzens kannst du stattdessen einen deiner Steine auf einen benachbarten freien Punkt ziehen.', 'Ten stones per side. During placement you may instead move one of your stones to an adjacent empty point.'),
'replace_ongoing_game': ('Laufende Partie ersetzen', 'Replace current game'),
'white': ('Weiß', 'White'), 'black': ('Schwarz', 'Black'), 'empty': ('frei', 'empty'), 'selected': ('ausgewählt', 'selected'), 'legal_target': ('mögliches Ziel', 'legal destination'),
'your_turn': ('Du bist am Zug.', 'Your move.'), 'side_to_move': ('%@ ist am Zug.', '%@ to move.'),
 'computer_turn': ('Computer ist am Zug.', 'Computer’s turn.'),
'computer_considers': ('Der Computer wählt seinen nächsten Zug.', 'The computer is choosing its next move.'),
'computer_capture': ('Eine Mühle. Der Computer wählt einen Stein zum Entfernen.', 'A mill. The computer is choosing a stone to remove.'),
'hint_thinking': ('Ein Tipp wird vorbereitet.', 'Preparing a hint.'),
'hint_considers': ('Der Zugvorschlag erscheint gleich auf dem Brett.', 'The suggested move will appear on the board.'),
'computer_did': ('Computer: %@', 'Computer: %@'),
'last_placed_at': ('gesetzt auf %@', 'placed at %@'),
'last_removed_at': ('Stein auf %@ entfernt', 'removed stone at %@'),
'last_captured': ('zuletzt entfernter Stein', 'last captured stone'),
'last_origin': ('Ausgangspunkt des letzten Zuges', 'last move origin'),
'last_destination': ('Ziel des letzten Zuges', 'last move destination'),
'resume_computer': ('Computerzug fortsetzen', 'Resume computer move'),
'mill_formed': ('Eine Mühle.', 'A mill.'), 'thinking': ('Ein guter Zug braucht Ruhe.', 'Thinking it through.'),
'place_instruction': ('Setze einen Stein auf einen freien Punkt.', 'Place a stone on an empty point.'),
'move_instruction': ('Wähle den Stein, den du bewegen möchtest.', 'Choose a stone to move.'),
'lasker_instruction': ('Setze einen Stein oder wähle einen eigenen zum Ziehen.', 'Place a stone or select one of your stones to move.'),
'capture_instruction': ('Entferne einen markierten gegnerischen Stein.', 'Remove one of the marked opposing stones.'),
'destination_instruction': ('Wähle einen markierten Zielpunkt.', 'Choose a marked destination.'),
'hint_move': ('Zugvorschlag: %@', 'Suggested move: %@'),
'draw': ('Unentschieden.', 'A draw.'), 'wins': ('%@ gewinnt.', '%@ wins.'), 'game_finished': ('Partie beendet.', 'Game finished.'),
'undo': ('Zurück', 'Undo'), 'hint': ('Tipp', 'Hint'), 'history': ('Verlauf', 'History'),
'placing_phase': ('Setzen', 'Placing'), 'moving_phase': ('Ziehen & Springen', 'Moving & flying'), 'capture_phase': ('Stein entfernen', 'Capture'),
'finished': ('Beendet', 'Finished'), 'move_count': ('%d Züge', '%d moves'), 'move_count_one': ('%d Zug', '%d move'),
'stone_counts': ('%d auf dem Brett · %d im Vorrat', '%d on board · %d in reserve'),
'play_again': ('Noch eine Partie', 'Play again'), 'rules': ('Spielregeln', 'Rules'), 'game_options': ('Partieoptionen', 'Game options'),
'legal_moves': ('Mögliche Züge', 'Legal moves'), 'no_moves': ('Noch keine Züge', 'No moves yet'),
'aim': ('Drei in einer Linie', 'Three in a row'),
'aim_body': ('Drei eigene Steine auf einer durchgehenden Brettlinie bilden eine Mühle. Jede neu gebildete Mühle erlaubt es, einen gegnerischen Stein zu entfernen.', 'Three of your stones on a continuous board line form a mill. Each newly formed mill lets you remove an opposing stone.'),
'placing_body': ('Weiß beginnt. Setzt abwechselnd einen Stein aus dem Vorrat auf einen freien Punkt.', 'White starts. Take turns placing a stone from your reserve on an empty point.'),
'moving_body': ('Ist dein Vorrat leer, ziehst du entlang einer Linie auf einen benachbarten freien Punkt. Mit nur noch drei Steinen darfst du auf jeden freien Punkt springen.', 'Once your reserve is empty, move along a line to an adjacent empty point. With only three stones left, you may fly to any empty point.'),
'capture_body': ('Steine in einer geschlossenen Mühle sind geschützt, solange andere gegnerische Steine verfügbar sind. Die möglichen Ziele werden auf dem Brett markiert.', 'Stones in a completed mill are protected while other opposing stones remain available. Legal targets are marked on the board.'),
'ending': ('Das Ende der Partie', 'End of the game'),
'ending_body': ('Wer keine legalen Züge mehr hat oder nach dem Setzen weniger als drei Steine besitzt, verliert. Stellungswiederholungen und längere Zugfolgen ohne Schlagen können zum Remis führen; der Spielkern entscheidet dies nach der gewählten Variante.', 'A player loses when no legal moves remain or when fewer than three stones remain after placement. Repeated positions and long sequences without capture can lead to a draw, according to the selected variant.'),
'about_body': ('Mühlenstein bringt klassische Mühle, Zwölfstein-Mühle, Morabaraba und Lasker-Mühle auf iPhone und iPad. Spiele gegen den Computer oder zu zweit auf einem Gerät. Alle Züge werden offline berechnet.', 'Muehlenstein brings Nine Men’s Morris, Twelve Men’s Morris, Morabaraba and Lasker Morris to iPhone and iPad. Play against the computer or with another player on one device. All moves are calculated offline.'),
'prototype': ('Entwicklungsstand', 'Development build'), 'privacy': ('Privatsphäre', 'Privacy'),
'privacy_body': ('Mühlenstein benötigt kein Benutzerkonto und verwendet keine Werbung, Analyse- oder Trackingdienste. Spielregeln, Computerzüge und Tipps werden auf deinem Gerät berechnet.\n\nDie aktuelle Partie und deine Einstellungen werden lokal gespeichert. Gerätesicherungen richten sich nach deinen iOS-Einstellungen.\n\nNur wenn du einen externen Link öffnest oder uns eine E-Mail schreibst, verwendest du einen externen Dienst. Dort gelten die Datenschutzbedingungen des jeweiligen Anbieters. Eine Kontaktaufnahme ist freiwillig. Anbieter und E-Mail-Adresse findest du im Impressum.', 'Muehlenstein requires no account and uses no advertising, analytics or tracking services. Game rules, computer moves and hints are calculated on your device.\n\nYour current game and preferences are stored locally. Device backups follow your iOS settings.\n\nExternal services are used only when you open an external link or write us an email. The respective provider’s privacy terms then apply. Contacting us is optional. Find the provider and email address under Legal notice.'),
'credits': ('Herkunft & Quellcode', 'Credits & source'),
'credits_body': ('Mühlenstein ist eine eigenständige App von AmoSystems und keine offizielle Sanmill-Veröffentlichung. Gestaltung, SwiftUI-Oberfläche und native Anbindung wurden für Mühlenstein entwickelt.\n\nRegeln, Suchalgorithmen und klassische Eröffnungsdaten stammen aus Sanmill von calcitem und den Sanmill-Mitwirkenden. Ihre ursprünglichen Hinweise und Autorenangaben bleiben erhalten.\n\nDie App steht unter GNU AGPL v3 oder neuer. Der vollständige Quellcode und die Bauanleitung sind über den Quellcode-Link zugänglich. Die Lizenztexte einschließlich der verwendeten Bibliotheken sind auch offline in dieser App enthalten.', 'Muehlenstein is an independent AmoSystems app, not an official Sanmill release. Its design, SwiftUI interface and native integration were developed for Muehlenstein.\n\nGame rules, search algorithms and classical opening data come from Sanmill by calcitem and the Sanmill contributors. Their original notices and author credits are preserved.\n\nThe app is licensed under GNU AGPL v3 or later. Its complete source and build instructions are available through the source link. License texts, including those for the libraries used, are also included offline in this app.'),
'engine_error': ('Die Spielberechnung konnte nicht abgeschlossen werden. Bitte versuche es erneut.', 'The game calculation could not be completed. Please try again.'),
'restore_error': ('Die gespeicherte Partie konnte nicht geladen werden. Die Datei wurde nicht verändert.', 'The saved game could not be loaded. Its file has not been changed.'),
'save_error': ('Die Partie konnte nicht gespeichert werden. Sie bleibt für diese Sitzung geöffnet.', 'The game could not be saved. It remains open for this session.'),
'license_error': ('Lizenzdatei nicht verfügbar.', 'License file unavailable.')
}
copy.update({
'imprint': ('Impressum & Kontakt', 'Legal notice & contact'),
'germany': ('Deutschland', 'Germany'), 'contact': ('Kontakt', 'Contact'),
'contact_email': ('E-Mail schreiben', 'Write an email'), 'website': ('Website öffnen', 'Open website'),
'vat_id': ('Umsatzsteuer-Identifikationsnummer', 'VAT identification number'),
'source_code': ('Quellcode öffnen', 'View source code'),
'version_build': ('Version %@ · Build %@', 'Version %@ · Build %@'),
'license': ('GNU AGPL v3', 'GNU AGPL v3'), 'third_party': ('Weitere Lizenzen', 'Third-party notices'),
'display_options': ('Darstellung', 'Appearance'),
'show_legal': ('Zugziele', 'Legal targets'),
'show_last': ('Letzter Zug', 'Last move'),
'disable_stone_animations': ('Steinanimationen deaktivieren', 'Disable stone animations'),
'display_help': ('Hinweise', 'About these options'),
'display_help_body': ('Zugziele\nMarkiert freie Setzpunkte, mögliche Ziele des ausgewählten Steins und erlaubte Schlagziele. Ausgeschaltet gelten dieselben Regeln; nur die Markierungen entfallen.\n\nLetzter Zug\nZeigt Ziel, Ausgangspunkt und entfernte Steine des letzten Zuges. Bei Computerzügen erscheint zusätzlich eine kurze Beschreibung. Der Verlauf bleibt unabhängig davon verfügbar.\n\nSpieldetails\nSpielstufe, Variante und weitere Angaben stehen im Verlauf unter Spieldetails. Die Stufe ist keine gemessene Elo-Wertung.\n\nDie Einstellungen werden auf diesem Gerät gespeichert. Ein ausdrücklich angeforderter Tipp und die Auswahl möglicher Züge bleiben auch bei ausgeschalteten Markierungen verfügbar.', 'Legal targets\nMarks empty placement points, legal destinations for the selected stone and available captures. Turning this off hides the markers; the rules stay the same.\n\nLast move\nShows the destination, origin and captured stones of the last turn. Computer moves also get a short description. The move history remains available independently.\n\nGame details\nFind difficulty, variant and further information under History → Game details. The level is not a measured Elo rating.\n\nThese preferences are saved on this device. Requested hints and the legal-move picker remain available when markers are off.'),
'computer_options': ('Spielstärke', 'Difficulty'),
'computer_style': ('Spielstil', 'Play style'),
'opening_book': ('Eröffnung', 'Opening'),
'book_automatic': ('Automatisch', 'Automatic'),
'book_off': ('Aus', 'Off'),
'book_help': ('Eröffnungsbuch', 'Opening book'),
'book_help_body': ('Automatisch · Voreinstellung\nBei klassischer Mühle auf Stufe 4 und 5 nutzt der Computer bekannte Eröffnungszüge aus Sanmill. Das Buch ist in der App enthalten und funktioniert offline. Auf Stufe 1 bis 3 und in den anderen Spielvarianten bleibt die normale Suche aktiv.\n\nStärke: Bekannte Stellungen der Setzphase benötigen keine erneute Suche. Das kann Rechenarbeit sparen und gibt der Eröffnung eine feste Orientierung. Die angenehme Denkpause bleibt erhalten.\n\nGrenze: Das Buch deckt nur ausgewählte Stellungen ab und garantiert keinen perfekten Zug oder Sieg. Sobald eine Stellung fehlt, sucht der Computer mit der gewählten Stufe, Rechenzeit und dem Spielstil weiter. Bei einem Buchtreffer bestimmen diese Sucheinstellungen den Zug nicht.\n\nAus\nDer Computer sucht auch in bekannten Eröffnungen selbst. So wirkt beispielsweise der Blockierstil bereits vom ersten Zug an.\n\nDie Auswahl wird mit der Partie gespeichert. Bei einer neuen Partie gilt sie mit Spielbeginn; während einer Partie übernimmt Fertig die Änderung.', 'Automatic · Default\nIn Nine Men’s Morris at levels 4 and 5, the computer uses known opening moves from Sanmill. The book is included in the app and works offline. Levels 1 to 3 and the other variants continue to use normal search.\n\nStrength: Known placement positions require no new search. This can save computation and gives the opening a consistent direction. The comfortable thinking pause is preserved.\n\nLimit: The book covers selected positions and does not guarantee a perfect move or a win. Whenever a position is missing, the computer resumes searching with your chosen level, thinking time and style. Search settings do not determine a move supplied by the book.\n\nOff\nThe computer searches even in known openings. For example, Blocking style then applies from the very first move.\n\nThis selection is saved with the game. Starting a new game applies it; during a game, Done applies changes.'),
'style_balanced': ('Ausgewogen', 'Balanced'),
'style_blocking': ('Blockierend', 'Blocking'),
'style_help': ('Spielstil erklärt', 'About play styles'),
'style_help_body': ('Ausgewogen · Voreinstellung\nBerücksichtigt sowohl die Anzahl der Steine als auch ihre Beweglichkeit. Das hilft dem Computer, Mühlen zu nutzen, freie Wege zu behalten und gegnerische Möglichkeiten einzuschränken. Für die normale Partie empfohlen.\n\nBlockierend · Zum Ausprobieren\nBevorzugt in der Setzphase und bestimmten Stellungen kurz vor dem gegnerischen Springen das Einschränken gegnerischer Wege. Dabei tritt die Anzahl der Steine in der Bewertung zurück.\n\nStärke: Erzeugt einen anderen Gegner mit stärkerem Schwerpunkt auf Einengen.\n\nSchwäche: Kann Materialgewinne übersehen oder aufgeben und dadurch schwächer spielen. Blockierend verhindert nicht automatisch jede gegnerische Mühle.\n\nDer Stil ist unabhängig von der Spielstufe. Stufe 5 schaltet deshalb nicht automatisch auf Blockierend um. Beide Stile berücksichtigen Beweglichkeit und verwenden dieselben Regeln sowie das gewählte Suchbudget.\n\nFertig übernimmt Änderungen für die nächsten Züge. Abbrechen verwirft sie. Die Auswahl bleibt mit der Partie gespeichert.', 'Balanced · Default\nConsiders both the number of stones and their mobility. This helps the computer use mills, keep routes open and restrict the opponent. Recommended for normal play.\n\nBlocking · An alternative to try\nPrioritizes restricting the opponent’s routes during placement and in certain positions just before the opponent can fly. In those situations, stone count takes a back seat in the evaluation.\n\nStrength: Offers a different opponent with a greater focus on restricting movement.\n\nWeakness: May miss or sacrifice material gains and therefore play worse. Blocking does not automatically prevent every opposing mill.\n\nStyle is independent of difficulty. Level 5 therefore does not automatically switch to Blocking. Both styles consider mobility and use the same rules and selected search budget.\n\nDone applies changes to future moves. Cancel discards them. The selection is saved with the game.'),
'search_algorithm': ('Suche', 'Search'),
'search_comparison': ('Suchverfahren erklärt', 'Compare search methods'),
'search_comparison_body': ('Welche Suche wählen?\nLass MTD(f) eingestellt, wenn du einfach spielen möchtest. PVS bietet eine alternative Berechnung zum Ausprobieren. Für einen leichteren oder schwierigeren Gegner ändere zuerst die Spielstufe.\n\nMTD(f) · Voreinstellung\nGrenzt die Bewertung einer Stellung mit mehreren kurzen Suchdurchläufen ein und verwendet gespeicherte Teilergebnisse erneut.\n\nStärke: Kann Rechenarbeit sparen, wenn die erste Einschätzung nahe am späteren Ergebnis liegt und gespeicherte Ergebnisse wiederverwendbar sind.\n\nSchwäche: Eine unpassende erste Einschätzung kann zusätzliche Durchläufe erfordern. Das Verfahren ist besonders auf den Suchspeicher angewiesen.\n\nPVS · Alternative\nUntersucht den zuerst betrachteten Zug genauer. Andere Züge werden zunächst darauf geprüft, ob sie besser sein könnten.\n\nStärke: Kann viele Alternativen mit wenig Rechenarbeit ausschließen, wenn ein guter Zug zuerst untersucht wird.\n\nSchwäche: Erweist sich eine zunächst unterschätzte Alternative als besser, muss sie nochmals genauer untersucht werden. Eine ungünstige Zugreihenfolge kostet zusätzliche Arbeit.\n\nWas merkst du davon?\nBei gleicher Stufe und Rechenzeit können die Verfahren unterschiedlich tief suchen und andere Züge wählen. Sie nutzen denselben Spielkern und dieselbe Stellungsbewertung; PVS ist also keine andere KI-Persönlichkeit. Auch PVS verwendet Suchspeicher.\n\nVergleichspartien auf der mittleren Stufe mit normaler Rechenzeit zeigen keinen belastbaren Spielstärkevorsprung eines Verfahrens. Das ist noch keine Einstufung für alle Stufen oder Geräte. Geschwindigkeit, gesamter Speicherbedarf und Energieverbrauch auf iPhone und iPad sind noch nicht verglichen. Beide Verfahren berechnen vollständig auf dem Gerät. Die Auswahl ist optional.', 'Which search should I choose?\nKeep MTD(f) if you simply want to play. PVS offers an alternative calculation to try. To make the opponent easier or harder, change the level first.\n\nMTD(f) · Default\nNarrows down a position’s evaluation through repeated focused searches, reusing stored intermediate results.\n\nStrength: Can save computation when the initial estimate is close to the eventual result and stored results can be reused.\n\nWeakness: An inaccurate initial estimate can require additional passes. This method relies particularly on search memory.\n\nPVS · Alternative\nExamines the first candidate more fully, then initially tests other moves to see whether they could be better.\n\nStrength: Can dismiss many alternatives with little computation when a good move is examined first.\n\nWeakness: If an initially underestimated alternative looks better, it needs a fuller re-search. Poor move ordering costs extra work.\n\nWhat will I notice?\nAt the same level and thinking time, the methods may reach different depths and choose different moves. They share the engine and position evaluation; PVS is not a different AI personality. PVS also uses search memory.\n\nComparison games at the middle level with normal thinking time show no reliable playing-strength advantage for either method. This does not establish a ranking across all levels or devices. Speed, total memory use and energy use on iPhone and iPad have not yet been compared. Both methods run entirely on your device. Changing this option is optional.'),
'advanced_options': ('Erweitert', 'Advanced'),
'search_help': ('Rechenzeit erklärt', 'About thinking time'),
'search_help_body': ('Normal · Voreinstellung\nSuchbudget je Stufe: 0,15 / 0,25 / 0,45 / 0,8 / 1,2 Sekunden.\n\nLänger\nSuchbudget je Stufe: 0,6 / 1 / 1,8 / 2,6 / 3,6 Sekunden. Erlaubt außerdem eine tiefere Suche.\n\nEine Berechnung kann früher fertig sein. Mehr Rechenzeit kann bessere Züge ermöglichen; der tatsächliche Vorteil hängt von der Stellung ab. Längere Berechnungen können mehr Energie benötigen. Die Werte sind Suchbudgets, keine garantierten Antwortzeiten. Das ruhige Zugtempo bleibt erhalten.\n\nMTD(f) und Normal sind die Voreinstellung. Erweiterte Änderungen gelten zusätzlich zur gewählten Stufe; bei gleicher Stufennummer kann sich die Zugwahl deshalb unterscheiden. Fertig auf der Computer-Seite übernimmt die Auswahl, Abbrechen verwirft sie.', 'Normal · Default\nSearch budgets by level: 0.15 / 0.25 / 0.45 / 0.8 / 1.2 seconds.\n\nLonger\nSearch budgets by level: 0.6 / 1 / 1.8 / 2.6 / 3.6 seconds. Also permits deeper searches.\n\nA calculation may finish earlier. More computation may find better moves; the benefit depends on the position. Longer calculations may use more energy. These are search budgets, not guaranteed response times. The measured presentation pace is retained.\n\nMTD(f) and Normal are the defaults. Advanced changes apply in addition to the selected level, so move choices can differ at the same level number. Done on the Computer page applies your selection; Cancel discards it.'),
'search_effort': ('Rechenzeit', 'Thinking time'),
'effort_standard': ('Normal', 'Normal'),
'effort_extended': ('Länger', 'Longer'),
'computer_help': ('Spielstärke erklärt', 'About difficulty'),
'computer_help_body': ('Fünf Spielstufen\n1 · Sehr leicht\n2 · Leicht\n3 · Mittel\n4 · Schwer\n5 · Sehr schwer\n\nNeue Partien beginnen zunächst mit Stufe 1 · Sehr leicht. Danach wird deine zuletzt bestätigte Spielstärke für zukünftige Partien gemerkt, auch nach einem App-Neustart. Du kannst die Stufe beim Einrichten oder während einer Partie ändern. Partie beginnen bzw. Fertig speichert die Auswahl; Abbrechen verwirft sie.\n\nDie Stufen erlauben zunehmend tiefere und längere Berechnungen. Sie beschreiben die Abstufung innerhalb dieser App; eine Elo-Wertung oder eine feste Gewinnchance ist damit nicht verbunden. Die Wirkung hängt auch von Stellung, Mühle-Variante und Gerät ab.\n\nUnter Erweitert kannst du die Suche und ihre Rechenzeit anpassen. Zum Spielen genügt die Voreinstellung.\n\nFertig übernimmt deine Auswahl für die nächsten Züge. Ein gerade berechneter Computerzug wird neu gesucht. Die Partie bleibt erhalten; Tipp und Rücknahme sind weiterhin verfügbar.', 'Five levels\n1 · Very easy\n2 · Easy\n3 · Medium\n4 · Hard\n5 · Very hard\n\nNew games initially use level 1 · Very easy. Your last confirmed difficulty is then remembered for future games, even after restarting the app. You can change it during setup or during a game. Start game or Done saves your choice; Cancel discards it.\n\nHigher levels allow deeper and longer calculations. These labels describe levels within this app; they do not imply an Elo rating or a fixed chance of winning. The effect also depends on the position, Morris variant and device.\n\nAdvanced lets you change the search and thinking time. The defaults are enough to start playing.\n\nDone applies your selection to future moves and restarts any computer move currently being calculated. Your game, hints and undo remain available.'),
'level_badge': ('Stufe %d/5', 'Level %d/5'),
'computer_configuration': ('Computer: Stufe %d/5 · %@', 'Computer: level %d/5 · %@'),
'capture_unmarked': ('Entferne einen erlaubten gegnerischen Stein.', 'Remove an eligible opposing stone.'),
'destination_unmarked': ('Wähle einen erlaubten freien Zielpunkt.', 'Choose a legal empty destination.'),
})
copy['capture_body'] = ('Steine in einer geschlossenen Mühle sind geschützt, solange andere gegnerische Steine verfügbar sind. Mit der Spielhilfe „Zugziele“ werden erlaubte Ziele auf dem Brett markiert.', 'Stones in a completed mill are protected while other opposing stones remain available. Enable Legal targets to mark eligible captures on the board.')
copy.update({
'expanded': ('Ausgeklappt', 'Expanded'), 'collapsed': ('Eingeklappt', 'Collapsed'),
'classic_choice': ('Klassisch', 'Classic'), 'twelve_choice': ('Zwölfstein', 'Twelve-stone'),
'morabaraba_choice': ('Morabaraba', 'Morabaraba'), 'lasker_choice': ('Lasker', 'Lasker'),
'variant_help': ('Spielvarianten erklärt', 'About variants'),
'variant_help_body': ('Klassische Mühle · 9 Steine\n' + copy['classic_rules'][0] + '\n\nZwölfstein-Mühle · 12 Steine\n' + copy['twelve_rules'][0] + '\n\nMorabaraba · 12 Steine\n' + copy['morabaraba_rules'][0] + '\n\nLasker-Mühle · 10 Steine\n' + copy['lasker_rules'][0],
 'Nine Men’s Morris · 9 stones\n' + copy['classic_rules'][1] + '\n\nTwelve Men’s Morris · 12 stones\n' + copy['twelve_rules'][1] + '\n\nMorabaraba · 12 stones\n' + copy['morabaraba_rules'][1] + '\n\nLasker Morris · 10 stones\n' + copy['lasker_rules'][1]),
})
copy['computer_help_body'] = tuple(t.replace('Fertig übernimmt deine Auswahl für die nächsten Züge.', 'Bei einer neuen Partie gilt deine Auswahl mit Spielbeginn. Während einer Partie übernimmt Fertig die Auswahl für die nächsten Züge.').replace('Done applies your selection to future moves', 'Starting a new game applies your selection. During a game, Done applies it to future moves') for t in copy['computer_help_body'])
copy['computer_help_body'] = (
    copy['computer_help_body'][0].replace('Unter Erweitert kannst du die Suche und ihre Rechenzeit anpassen.',
        'Alle Stufen berücksichtigen bereits die Anzahl und Beweglichkeit der Steine. Höhere Stufen erlauben mehr Vorausberechnung; sie schalten keinen anderen Spielstil ein.\n\nUnter Erweitert kannst du Suche, Rechenzeit und Spielstil anpassen. Ausgewogen bleibt die Empfehlung; Blockierend ist eine Alternative und kann schwächer spielen.'),
    copy['computer_help_body'][1].replace('Advanced lets you change the search and thinking time.',
        'Every level already considers stone count and mobility. Higher levels allow more lookahead; they do not switch play styles.\n\nAdvanced lets you change search, thinking time and play style. Balanced remains recommended; Blocking is an alternative and may play worse.'))
copy['style_help_body'] = tuple(t.replace('Fertig übernimmt Änderungen für die nächsten Züge.', 'Bei einer neuen Partie gilt die Auswahl mit Spielbeginn. Während einer Partie übernimmt Fertig Änderungen für die nächsten Züge.').replace('Done applies changes to future moves.', 'Starting a new game applies the selection. During a game, Done applies changes to future moves.') for t in copy['style_help_body'])
copy['search_help_body'] = tuple(t.replace('Fertig auf der Computer-Seite übernimmt die Auswahl, Abbrechen verwirft sie.', 'Beginne die neue Partie, um die Auswahl zu übernehmen. Während einer Partie übernimmt Fertig die Auswahl, Abbrechen verwirft sie.').replace('Done on the Computer page applies your selection; Cancel discards it.', 'Start a new game to apply your selection. During a game, Done applies your changes; Cancel discards them.') for t in copy['search_help_body'])
copy['display_help_body'] = tuple(text + addition for text, addition in zip(copy['display_help_body'], (
    '\n\nSteinanimationen deaktivieren\nSchalte diese Option ein, damit Steine sofort wechseln. Ausgeschaltet gleiten sie sanft zu ihrem Ziel und werden beim Setzen oder Entfernen kurz ein- bzw. ausgeblendet. Die iOS-Einstellung „Bewegung reduzieren“ hat Vorrang. Die Denkpause des Computers bleibt unverändert.\n\nAlle drei Schalter sind anfangs ausgeschaltet: keine Zugziel- oder Letzter-Zug-Markierungen, aber sanfte Steinbewegungen.',
    '\n\nDisable stone animations\nTurn this on for immediate changes. When off, stones glide to their destination and briefly fade in or out when placed or captured. The iOS Reduce Motion setting takes precedence. The computer’s thinking pause is unchanged.\n\nAll three switches are off by default: no legal-target or last-move markers, with gentle stone movements.')))
copy['credits_body'] = tuple(text.replace('Regeln und Suche:', 'Regeln, Suche und Eröffnungsdaten:').replace('Rules and search:', 'Rules, search and opening data:') for text in copy['credits_body'])
copy['computer_help_body'] = tuple(text + addition for text, addition in zip(copy['computer_help_body'], (
    '\n\nBei klassischer Mühle verwenden Stufe 4 und 5 zusätzlich ein kleines Eröffnungsbuch. Unter Erweitert → Eröffnung lässt sich das abschalten. Bei unbekannten Stellungen übernimmt die Suche.',
    '\n\nIn Nine Men’s Morris, levels 4 and 5 also use a small opening book. You can turn it off under Advanced → Opening. Unknown positions use normal search.')))
copy.update({
'made_in_berlin': ('Entwickelt mit ♥ in Berlin', 'Developed with ♥ in Berlin'),
'about_provider': ('Anbieter', 'Provider'),
'about_technical': ('Technische Angaben', 'Technical details'),
'privacy_play': ('Privat spielen', 'Play privately'),
'privacy_device': ('Auf deinem Gerät', 'On your device'),
'privacy_external': ('Externe Links & Kontakt', 'External links & contact'),
'credits_design': ('Eigenständig gestaltet', 'Independently designed'),
'credits_engine': ('Spielkern & KI', 'Game engine & AI'),
'credits_license': ('Freie Software', 'Free software'),
'about_vat': ('Umsatzsteuer-ID', 'VAT identification'),
'accent_color': ('Akzentfarbe', 'Accent color'),
'accent_forest': ('Waldgrün', 'Forest green'),
'accent_slate': ('Schieferblau', 'Slate blue'),
'accent_aubergine': ('Aubergine', 'Aubergine'),
'accent_terracotta': ('Terrakotta', 'Terracotta'),
'accent_petrol': ('Petrol', 'Teal'),
'accent_rose': ('Rosé', 'Rose'),
})
copy['display_help_body'] = tuple(text + addition for text, addition in zip(copy['display_help_body'], ('\n\nAkzentfarbe\nSchieferblau ist voreingestellt. Die Farbauswahl gilt für die gesamte App und wird auf diesem Gerät gespeichert. Sand, Graphit und die Spielsteine behalten ihre Farben.', '\n\nAccent color\nSlate blue is the default. Your color choice applies throughout the app and is saved on this device. Sand, graphite and the playing pieces keep their colors.')))
copy.pop(' twelve')
for i, lang in enumerate(['de','en']):
    folder=resources / f'{lang}.lproj'; folder.mkdir(parents=True, exist_ok=True)
    (folder/'Localizable.strings').write_text('\n'.join(f'{json.dumps(k)} = {json.dumps(v[i], ensure_ascii=False)};' for k,v in copy.items())+'\n')
    (folder/'InfoPlist.strings').write_text(f'"CFBundleDisplayName" = "{copy["app_name"][i]}";\n')
colors={
'Limestone': ('F6F3EB','171D20'), 'BoardSurface': ('EDE8DD','222C30'),
'Ink': ('263337','EFECE4'), 'QuietInk': ('596460','ADB7B4'),
'AccentColor': ('4A6074','A8BED1'), 'AccentContent': ('FFFFFF','171D20'),
'Accent-forest': ('4F624A','ADBF9F'), 'Accent-aubergine': ('72556C','CFB0C7'),
# Besser Lesen's Wildrose (#C87292 / #E095AF), deepened in light mode for text on limestone.
'Accent-rose': ('964665','E095AF'),
'Accent-terracotta': ('8F533C','DEB098'), 'Accent-petrol': ('17695F','8AD0BD'), 'BoardLine': ('727E77','81938C'),
'StoneEdge': ('6D7772','9BAAA4'),
'WhiteStoneTop': ('FFF9ED','FFF9ED'), 'WhiteStoneBottom': ('E3D9C7','E3D9C7'),
'BlackStoneTop': ('3E4B51','3E4B51'), 'BlackStoneBottom': ('263237','263237'),
'WhiteStoneMark': ('17695F','17695F'), 'BlackStoneMark': ('8AD0BD','8AD0BD')}
assets=resources/'Assets.xcassets'; assets.mkdir(exist_ok=True)
(assets/'Contents.json').write_text(json.dumps({'info':{'version':1,'author':'xcode'}}))
for name,values in colors.items():
    folder=assets/f'{name}.colorset'; folder.mkdir(exist_ok=True)
    entries=[]
    for i,h in enumerate(values):
        entry={'idiom':'universal','color':{'color-space':'srgb','components':{k:f'{int(h[n:n+2],16)/255:.5f}' for k,n in [('red',0),('green',2),('blue',4)]}|{'alpha':'1.000'}}}
        if i: entry['appearances']=[{'appearance':'luminosity','value':'dark'}]
        entries.append(entry)
    (folder/'Contents.json').write_text(json.dumps({'colors':entries,'info':{'version':1,'author':'xcode'}},indent=2))
plist={'CFBundleDisplayName':'Muehlenstein','CFBundleDevelopmentRegion':'en','CFBundleExecutable':'$(EXECUTABLE_NAME)',
'CFBundleIdentifier':'$(PRODUCT_BUNDLE_IDENTIFIER)','CFBundleInfoDictionaryVersion':'6.0','CFBundleName':'$(PRODUCT_NAME)',
'CFBundlePackageType':'APPL','CFBundleShortVersionString':'$(MARKETING_VERSION)','CFBundleVersion':'$(CURRENT_PROJECT_VERSION)',
'LSRequiresIPhoneOS':True,'ITSAppUsesNonExemptEncryption':False,'UILaunchScreen':{},'UIApplicationSceneManifest':{'UIApplicationSupportsMultipleScenes':False},
'UISupportedInterfaceOrientations':['UIInterfaceOrientationPortrait','UIInterfaceOrientationLandscapeLeft','UIInterfaceOrientationLandscapeRight'],
'UISupportedInterfaceOrientations~ipad':['UIInterfaceOrientationPortrait','UIInterfaceOrientationPortraitUpsideDown','UIInterfaceOrientationLandscapeLeft','UIInterfaceOrientationLandscapeRight']}
(root/'App/Info.plist').write_bytes(plistlib.dumps(plist))
