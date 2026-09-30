#!/usr/bin/env python3
"""Authoritative bilingual copy and semantic design colors for the prototype."""
import json, plistlib
from pathlib import Path
root = Path(__file__).resolve().parent.parent
resources = root / 'App/Resources'
copy = {
'app_name': ('Mühlenstein', 'Muehlenstein'),
'turn_details': ('Zugdetails', 'Turn details'),
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
'replace_game': ('Die gespeicherte Partie durch eine neue ersetzen?', 'Replace the saved game with a new one?'),
'replace_and_start': ('Ersetzen und beginnen', 'Replace and start'),
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
'finished': ('Beendet', 'Finished'), 'action_count': ('%d Aktionen', '%d actions'),
'stone_counts': ('%d auf dem Brett · %d im Vorrat', '%d on board · %d in reserve'),
'play_again': ('Noch eine Partie', 'Play again'), 'rules': ('Spielregeln', 'Rules'), 'game_options': ('Partieoptionen', 'Game options'),
'legal_moves': ('Mögliche Züge als Liste', 'List legal moves'), 'no_moves': ('Noch keine Züge', 'No moves yet'),
'aim': ('Drei in einer Linie', 'Three in a row'),
'aim_body': ('Drei eigene Steine auf einer durchgehenden Brettlinie bilden eine Mühle. Jede neu gebildete Mühle erlaubt es, einen gegnerischen Stein zu entfernen.', 'Three of your stones on a continuous board line form a mill. Each newly formed mill lets you remove an opposing stone.'),
'placing_body': ('Weiß beginnt. Setzt abwechselnd einen Stein aus dem Vorrat auf einen freien Punkt.', 'White starts. Take turns placing a stone from your reserve on an empty point.'),
'moving_body': ('Ist dein Vorrat leer, ziehst du entlang einer Linie auf einen benachbarten freien Punkt. Mit nur noch drei Steinen darfst du auf jeden freien Punkt springen.', 'Once your reserve is empty, move along a line to an adjacent empty point. With only three stones left, you may fly to any empty point.'),
'capture_body': ('Steine in einer geschlossenen Mühle sind geschützt, solange andere gegnerische Steine verfügbar sind. Die möglichen Ziele werden auf dem Brett markiert.', 'Stones in a completed mill are protected while other opposing stones remain available. Legal targets are marked on the board.'),
'ending': ('Das Ende der Partie', 'End of the game'),
'ending_body': ('Wer keine legalen Züge mehr hat oder nach dem Setzen weniger als drei Steine besitzt, verliert. Stellungswiederholungen und längere Zugfolgen ohne Schlagen können zum Remis führen; der Spielkern entscheidet dies nach der gewählten Variante.', 'A player loses when no legal moves remain or when fewer than three stones remain after placement. Repeated positions and long sequences without capture can lead to a draw, according to the selected variant.'),
'about_body': ('Mühle in einer eigenständigen nativen iOS-Oberfläche. Mit dem offenen Spielkern von Sanmill.', 'Morris in an independently designed native iOS interface, powered by Sanmill’s open-source game engine.'),
'prototype': ('Entwicklungsstand', 'Development build'), 'privacy': ('Privatsphäre', 'Privacy'),
'privacy_body': ('Diese Version spielt vollständig auf dem Gerät. Sie verwendet keine Analyse-Dienste und kein Benutzerkonto. Die aktuelle Partie wird lokal gespeichert.', 'This version plays entirely on your device. It uses no analytics services or accounts. Your current game is saved locally.'),
'credits': ('Herkunft & Lizenz', 'Credits & license'),
'credits_body': ('Eigenständiger Sanmill-Fork. Regeln und Suche: calcitem und die Sanmill-Mitwirkenden. Quellstand: 8901a06f088b. Oberfläche und Swift-Anbindung: Muehlenstein. GNU AGPL v3 oder neuer. Das vollständige Quellarchiv dieser App wird vor einer öffentlichen Veröffentlichung bereitgestellt.', 'An independent Sanmill fork. Rules and search: calcitem and Sanmill contributors. Source revision: 8901a06f088b. Interface and Swift bridge: Muehlenstein. GNU AGPL v3 or later. The complete source archive of this app must be provided before public distribution.'),
'engine_error': ('Die Spielberechnung konnte nicht abgeschlossen werden. Bitte versuche es erneut.', 'The game calculation could not be completed. Please try again.'),
'restore_error': ('Die gespeicherte Partie konnte nicht geladen werden. Die Datei wurde nicht verändert.', 'The saved game could not be loaded. Its file has not been changed.'),
'save_error': ('Die Partie konnte nicht gespeichert werden. Sie bleibt für diese Sitzung geöffnet.', 'The game could not be saved. It remains open for this session.'),
'license_error': ('Lizenzdatei nicht verfügbar.', 'License file unavailable.')
}
copy.update({
'display_options': ('Spielhilfen', 'Playing aids'),
'show_legal': ('Zugziele', 'Legal targets'),
'show_last': ('Letzter Zug', 'Last move'),
'show_level': ('Spielstufe', 'Level badge'),
'display_help': ('Hinweise', 'About these options'),
'display_help_body': ('Zugziele\nMarkiert freie Setzpunkte, mögliche Ziele des ausgewählten Steins und erlaubte Schlagziele. Ausgeschaltet gelten dieselben Regeln; nur die Markierungen entfallen.\n\nLetzter Zug\nZeigt Ziel, Ausgangspunkt und entfernte Steine des letzten Zuges. Bei Computerzügen erscheint zusätzlich eine kurze Beschreibung. Der Verlauf bleibt unabhängig davon verfügbar.\n\nSpielstufe\nZeigt die gewählte Computerstufe neben dem Steinvorrat. Bei großer Schrift steht sie in den Partiedetails. Sie ist keine gemessene Elo-Wertung.\n\nDie Einstellungen werden auf diesem Gerät gespeichert. Ein ausdrücklich angeforderter Tipp und die Liste möglicher Züge bleiben auch bei ausgeschalteten Markierungen verfügbar.', 'Legal targets\nMarks empty placement points, legal destinations for the selected stone and available captures. Turning this off hides the markers; the rules stay the same.\n\nLast move\nShows the destination, origin and captured stones of the last turn. Computer moves also get a short description. The move history remains available independently.\n\nLevel badge\nShows the selected computer level beside its reserve. At large text sizes, find it in the turn details. This is not a measured Elo rating.\n\nThese preferences are saved on this device. Requested hints and the legal-move list remain available when markers are off.'),
'computer_options': ('Computer einstellen', 'Computer settings'),
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
'computer_help_body': ('Fünf Spielstufen\n1 · Sehr leicht\n2 · Leicht\n3 · Mittel\n4 · Schwer\n5 · Sehr schwer\n\nBeginne mit Stufe 3. Wähle eine niedrigere Stufe für eine entspanntere Partie oder eine höhere für mehr Herausforderung. Du kannst die Stufe auch während einer Partie ändern.\n\nDie Stufen erlauben zunehmend tiefere und längere Berechnungen. Sie beschreiben die Abstufung innerhalb dieser App; eine Elo-Wertung oder eine feste Gewinnchance ist damit nicht verbunden. Die Wirkung hängt auch von Stellung, Mühle-Variante und Gerät ab.\n\nUnter Erweitert kannst du die Suche und ihre Rechenzeit anpassen. Zum Spielen genügt die Voreinstellung.\n\nFertig übernimmt deine Auswahl für die nächsten Züge. Ein gerade berechneter Computerzug wird neu gesucht. Die Partie bleibt erhalten; Tipp und Rücknahme sind weiterhin verfügbar.', 'Five levels\n1 · Very easy\n2 · Easy\n3 · Medium\n4 · Hard\n5 · Very hard\n\nStart at level 3. Choose a lower level for a more relaxed game or a higher one for more challenge. You can change the level during a game.\n\nHigher levels allow deeper and longer calculations. These labels describe levels within this app; they do not imply an Elo rating or a fixed chance of winning. The effect also depends on the position, Morris variant and device.\n\nAdvanced lets you change the search and thinking time. The defaults are enough to start playing.\n\nDone applies your selection to future moves and restarts any computer move currently being calculated. Your game, hints and undo remain available.'),
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
copy['search_help_body'] = tuple(t.replace('Fertig auf der Computer-Seite übernimmt die Auswahl, Abbrechen verwirft sie.', 'Beginne die neue Partie, um die Auswahl zu übernehmen. Während einer Partie übernimmt Fertig die Auswahl, Abbrechen verwirft sie.').replace('Done on the Computer page applies your selection; Cancel discards it.', 'Start a new game to apply your selection. During a game, Done applies your changes; Cancel discards them.') for t in copy['search_help_body'])
copy.pop(' twelve')
for i, lang in enumerate(['de','en']):
    folder=resources / f'{lang}.lproj'; folder.mkdir(parents=True, exist_ok=True)
    (folder/'Localizable.strings').write_text('\n'.join(f'{json.dumps(k)} = {json.dumps(v[i], ensure_ascii=False)};' for k,v in copy.items())+'\n')
    (folder/'InfoPlist.strings').write_text(f'"CFBundleDisplayName" = "{copy["app_name"][i]}";\n')
colors={
'Limestone': ('F6F3EB','171D20'), 'BoardSurface': ('EDE8DD','222C30'),
'Ink': ('263337','EFECE4'), 'QuietInk': ('616B68','ADB7B4'),
'AccentColor': ('17695F','8AD0BD'), 'AccentContent': ('FFFFFF','102B26'), 'BoardLine': ('88918A','81938C')}
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
'CFBundlePackageType':'APPL','CFBundleShortVersionString':'0.1.0','CFBundleVersion':'1',
'LSRequiresIPhoneOS':True,'UILaunchScreen':{},'UIApplicationSceneManifest':{'UIApplicationSupportsMultipleScenes':False},
'UISupportedInterfaceOrientations':['UIInterfaceOrientationPortrait','UIInterfaceOrientationLandscapeLeft','UIInterfaceOrientationLandscapeRight'],
'UISupportedInterfaceOrientations~ipad':['UIInterfaceOrientationPortrait','UIInterfaceOrientationPortraitUpsideDown','UIInterfaceOrientationLandscapeLeft','UIInterfaceOrientationLandscapeRight']}
(root/'App/Info.plist').write_bytes(plistlib.dumps(plist))
