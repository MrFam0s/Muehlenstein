// SPDX-License-Identifier: AGPL-3.0-or-later
import XCTest
import UIKit

final class MuehlensteinUITests: XCTestCase {
    @MainActor func testLargeTextHintsAndPagedGridsInLandscape() {
        XCUIDevice.shared.orientation = .landscapeLeft
        defer { XCUIDevice.shared.orientation = .portrait }
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing", "-ui-demo", "-AppleLanguages", "(de)", "-AppleLocale", "de_DE",
            "-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"]
        app.launch()
        let before = app.buttons["node_a7"].frame
        app.buttons["hint"].tap()
        XCTAssertTrue(app.staticTexts["hint_suggestion"].waitForExistence(timeout: 8))
        assertVisible(app.buttons["hint_explanation"], in: app)
        XCTAssertEqual(app.buttons["node_a7"].frame, before)
        XCTAssertEqual(app.scrollViews.count, 0)
        record("Hint-Largest-Landscape", app: app)
        app.buttons["history"].tap()
        assertVisible(app.otherElements["history_move_0"], in: app)
        assertVisible(app.buttons["next_page"], in: app)
        app.buttons["next_page"].tap()
        XCTAssertTrue(app.staticTexts["page_count"].label.hasPrefix("2"))
        XCTAssertEqual(app.scrollViews.count, 0)
        record("History-Largest-Landscape", app: app)
        app.buttons["Fertig"].tap()
        app.buttons["legal_moves"].tap()
        app.buttons["next_page"].tap()
        XCTAssertTrue(app.staticTexts["page_count"].label.hasPrefix("2"))
        let moves = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "legal_action_"))
        for move in moves.allElementsBoundByIndex { assertVisible(move, in: app) }
        assertVisible(app.buttons["next_page"], in: app)
        assertVisible(app.staticTexts["page_count"], in: app)
        XCTAssertEqual(app.scrollViews.count, 0)
        record("Legal-Moves-Largest-Landscape", app: app)
    }

    @MainActor func testCalmHintsHistoryGridAndCompactMovePicker() {
        let app = launch(demo: true)
        XCTAssertFalse(app.buttons["Zugdetails"].exists)
        let board = app.buttons["node_a7"].frame
        app.buttons["hint"].tap()
        XCTAssertTrue(app.staticTexts["hint_suggestion"].waitForExistence(timeout: 8))
        XCTAssertFalse(app.progressIndicators["search_progress"].exists)
        XCTAssertFalse(app.staticTexts["Ein Tipp wird vorbereitet."].exists)
        XCTAssertEqual(app.buttons["node_a7"].frame, board, "A hint must not move the board")
        app.buttons["hint_explanation"].tap()
        XCTAssertTrue((app.textViews.firstMatch.value as? String)?.contains("Zugvorschlag:") == true)
        XCTAssertFalse((app.textViews.firstMatch.value as? String)?.contains("Die Hinweise beschreiben") == true)
        record("Hint-Explanation", app: app)
        app.buttons["Fertig"].tap()
        app.buttons["hint"].tap()
        XCTAssertFalse(app.staticTexts["hint_suggestion"].exists)
        XCTAssertFalse(app.buttons["hint_explanation"].exists)
        XCTAssertEqual(app.buttons["node_a7"].frame, board)
        app.buttons["hint"].tap()
        XCTAssertTrue(app.staticTexts["hint_suggestion"].waitForExistence(timeout: 8))
        XCTAssertEqual(app.buttons["node_a7"].frame, board)
        app.buttons["history"].tap()
        let first = app.otherElements["history_move_0"]
        let second = app.otherElements["history_move_1"]
        XCTAssertTrue(first.waitForExistence(timeout: 3))
        XCTAssertEqual(first.frame.minY, second.frame.minY, accuracy: 1)
        XCTAssertGreaterThan(second.frame.minX, first.frame.minX)
        if UIDevice.current.userInterfaceIdiom == .pad {
            XCTAssertEqual(first.frame.minY, app.otherElements["history_move_2"].frame.minY, accuracy: 1)
        }
        XCTAssertEqual(app.scrollViews.count, 0)
        record("History-Grid", app: app)
        app.buttons["Spieldetails"].tap()
        XCTAssertTrue((app.textViews.firstMatch.value as? String)?.contains("Klassische Mühle") == true)
        record("History-Details", app: app)
        app.buttons["Fertig"].tap()
        app.buttons["game_options"].tap()
        app.buttons["Mögliche Züge"].tap()
        let action = app.buttons["legal_action_e5"]
        XCTAssertTrue(action.waitForExistence(timeout: 3))
        assertVisible(action, in: app)
        XCTAssertEqual(app.scrollViews.count, 0)
        record("Compact-Legal-Moves", app: app)
        action.tap()
        XCTAssertFalse(app.navigationBars["Mögliche Züge"].exists)
        XCTAssertTrue(app.buttons["node_e5"].label.contains("Weiß"))
        XCTAssertFalse(app.buttons["hint_explanation"].exists)
    }

    @MainActor func testLevelAndGameDetailsLiveOnlyInHistory() {
        let app = launch()
        app.buttons["new_game"].tap()
        app.buttons["start_game"].tap()
        XCTAssertFalse(app.otherElements["player_1"].label.contains("Stufe"))
        XCTAssertFalse(app.buttons["Zugdetails"].exists)
        record("Symmetric-Game-Header", app: app)
        app.buttons["history"].tap()
        app.buttons["Spieldetails"].tap()
        var details = ""
        for _ in 0..<10 {
            details += (app.textViews.firstMatch.value as? String) ?? ""
            let next = app.buttons.matching(NSPredicate(format: "identifier == %@ AND enabled == true", "next_page")).firstMatch
            if !next.exists { break }
            next.tap()
        }
        XCTAssertTrue(details.contains("Stufe 3"))
        XCTAssertTrue(details.contains("Ausgewogen"))
        XCTAssertTrue(details.contains("Klassische Mühle"))
    }

    // These review runs capture every inspector finding, including native controls.
    // They are evidence collection, not a claim that an empty/heuristic audit certifies WCAG.
    @MainActor func testContrastReviewLight() throws { try captureContrastReview("light") }
    @MainActor func testContrastReviewDark() throws { try captureContrastReview("dark") }
    @MainActor private func captureContrastReview(_ appearance: String) throws {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing", "-ui-appearance", appearance, "-AppleLanguages", "(de)", "-AppleLocale", "de_DE"]
        app.launch()
        var findings: [String] = []
        func capture(_ screen: String) throws {
            try app.performAccessibilityAudit(for: .contrast) { issue in
                findings.append("\(screen): \(issue.element?.label ?? "unknown") · \(String(describing: issue.element?.frame)) · \(issue.detailedDescription)")
                return true // All findings go into the review attachment; none are discarded.
            }
            // Capture after the audit has traversed the screen, so tap feedback has settled.
            record("Contrast-\(appearance)-\(screen)", app: app)
        }
        try capture("Home")
        app.buttons["learn_rules"].tap()
        try capture("Rules")
        app.buttons["Fertig"].tap()
        app.buttons["display_options"].tap()
        try capture("Playing-Aids")
        app.buttons["display_done"].tap()
        app.buttons["new_game"].tap()
        assertVariantsVisible(app)
        try capture("Setup")
        showSetupPanel("advanced", in: app)
        try capture("Advanced")
        app.buttons["Abbrechen"].tap()
        app.terminate()
        app.launchArguments += ["-ui-demo"]
        app.launch()
        XCTAssertTrue(app.buttons["node_a7"].waitForExistence(timeout: 5))
        try capture("Game")
        app.buttons["history"].tap()
        try capture("History")
        app.terminate()
        app.launchArguments.removeAll { $0 == "-ui-demo" }
        app.launch()
        app.buttons["new_game"].tap()
        app.buttons["opponent_local"].tap()
        app.buttons["start_game"].tap()
        for coordinate in ["c5", "a7", "d5", "d7", "e5"] { app.buttons["node_\(coordinate)"].tap() }
        XCTAssertTrue(app.staticTexts["Eine Mühle."].exists)
        try capture("Capture-Black-Stones")
        app.buttons["node_a7"].tap()
        for coordinate in ["g7", "b6", "a7"] { app.buttons["node_\(coordinate)"].tap() }
        XCTAssertTrue(app.staticTexts["Eine Mühle."].exists)
        try capture("Capture-White-Stones")
        let report = findings.isEmpty ? "No contrast findings." : findings.joined(separator: "\n")
        print("CONTRAST-REVIEW \(appearance): \(report)")
        let attachment = XCTAttachment(string: report)
        attachment.name = "Contrast-\(appearance)-Findings"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    @MainActor private func launch(demo: Bool = false) -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing", "-AppleLanguages", "(de)", "-AppleLocale", "de_DE"] + (demo ? ["-ui-demo"] : [])
        app.launch()
        return app
    }
    @MainActor func testAccessibleTargetsAndLabelsHome() throws {
        let app = launch()
        try auditAccessibility(app)
    }
    @MainActor func testAccessibleTargetsAndLabelsSetup() throws {
        let app = launch()
        app.buttons["new_game"].tap()
        app.buttons["advanced_options"].tap()
        record("Audit-Setup-Before", app: app)
        try auditAccessibility(app)
    }
    @MainActor func testAccessibleTargetsAndLabelsGame() throws {
        let app = launch(demo: true)
        XCTAssertTrue(app.buttons["node_a7"].waitForExistence(timeout: 5))
        try auditAccessibility(app)
    }
    @MainActor private func auditAccessibility(_ app: XCUIApplication) throws {
        // Aggregate every finding into one failure to keep the device result export manageable.
        // No findings from these checks are waived. Sheet contrast/font heuristics have
        // unresolved findings documented in VALIDATION; actual font growth is tested below.
        var findings: [String] = []
        for (name, type): (String, XCUIAccessibilityAuditType) in [
            ("elements", .elementDetection), ("targets", .hitRegion),
            ("labels", .sufficientElementDescription), ("traits", .trait)
        ] {
            try app.performAccessibilityAudit(for: type) { issue in
                let message = "\(name): \(issue.compactDescription) · \(issue.element?.label ?? "unknown") · \(issue.element?.identifier ?? "") · \(String(describing: issue.element?.frame)) · \(issue.detailedDescription)"
                print("ACCESSIBILITY: \(message)")
                findings.append(message)
                return true
            }
        }
        XCTAssertTrue(findings.isEmpty, findings.joined(separator: "\n"))
    }
    @MainActor func testSetupTextScalesAtLargestSize() {
        let app = launch()
        app.buttons["new_game"].tap()
        let normal = app.staticTexts["difficulty_value"].frame.height
        app.terminate()
        app.launchArguments += ["-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"]
        app.launch()
        app.buttons["new_game"].tap()
        showSetupPanel("difficulty", in: app)
        let enlarged = app.staticTexts["difficulty_value"]
        assertVisible(enlarged, in: app)
        XCTAssertGreaterThan(enlarged.frame.height, normal * 1.8, "The actual rendered type must grow substantially")
        record("Audit-Setup-Largest-Difficulty", app: app)
        showSetupPanel("variant", in: app)
        assertVariantsVisible(app)
        record("Audit-Setup-Largest-Variants", app: app)
        showSetupPanel("advanced", in: app)
        for key in ["algorithm_mtdf", "algorithm_pvs", "effort_standard", "effort_extended"] { assertVisible(app.buttons[key], in: app) }
        record("Audit-Setup-Largest-Advanced", app: app)
    }
    @MainActor func testLocalMillCaptureUndoAndHistory() {
        let app = launch()
        app.buttons["new_game"].tap()
        app.buttons["opponent_local"].tap()
        app.buttons["start_game"].tap()
        XCTAssertTrue(app.buttons["node_c5"].waitForExistence(timeout: 5))
        for coordinate in ["c5", "a7", "d5", "d7", "e5"] { app.buttons["node_\(coordinate)"].tap() }
        XCTAssertTrue(app.staticTexts["Eine Mühle."].exists)
        app.buttons["node_a7"].tap()
        XCTAssertTrue(app.staticTexts["Schwarz ist am Zug."].exists)
        app.buttons["undo"].tap()
        XCTAssertTrue(app.staticTexts["Eine Mühle."].exists)
        app.buttons["history"].tap()
        XCTAssertTrue(app.staticTexts["e5"].waitForExistence(timeout: 3))
        XCTAssertFalse(app.staticTexts["xa7"].exists)
    }
    @MainActor func testComputerRepliesAndUndoReturnsToOpening() {
        let app = launch()
        app.buttons["new_game"].tap()
        app.buttons["start_game"].tap()
        app.buttons["node_a7"].tap()
        XCTAssertTrue(app.staticTexts["Du bist am Zug."].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH %@", "Computer:")).firstMatch.exists)
        let marked = app.buttons.matching(NSPredicate(format: "value CONTAINS %@", "Ziel des letzten Zuges"))
        XCTAssertEqual(marked.count, 1)
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = "Computer-Move-Visible"
        attachment.lifetime = .keepAlways
        add(attachment)
        app.buttons["history"].tap()
        XCTAssertTrue(app.staticTexts["2"].waitForExistence(timeout: 3))
        app.buttons["Fertig"].tap()
        app.buttons["undo"].tap()
        XCTAssertTrue(app.staticTexts["0 Züge"].exists)
    }
    @MainActor func testSavedGameSurvivesRelaunch() {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing", "-ui-save", UUID().uuidString, "-AppleLanguages", "(de)", "-AppleLocale", "de_DE"]
        app.launch()
        app.buttons["new_game"].tap()
        app.buttons["opponent_local"].tap()
        app.buttons["start_game"].tap()
        app.buttons["node_a7"].tap()
        app.terminate()
        app.launch()
        app.buttons["continue_game"].tap()
        XCTAssertTrue(app.staticTexts["Schwarz ist am Zug."].exists)
        XCTAssertTrue(app.buttons["node_a7"].label.contains("Weiß"))
        app.buttons["undo"].tap()
        XCTAssertTrue(app.staticTexts["0 Züge"].exists)
    }
    @MainActor func testOngoingGameReplacementRequiresConfirmationFromHomeAndBoard() {
        let app = launch()
        app.buttons["new_game"].tap()
        app.buttons["opponent_local"].tap()
        app.buttons["start_game"].tap()
        app.buttons["node_a7"].tap()
        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.buttons["new_game"].tap()
        let cancelFrame = app.navigationBars.buttons["Abbrechen"].frame
        let outsideConfirmation = app.coordinate(withNormalizedOffset: .zero).withOffset(
            CGVector(dx: cancelFrame.midX - app.frame.minX, dy: cancelFrame.midY - app.frame.minY))
        app.buttons["start_game"].tap()
        XCTAssertTrue(app.staticTexts["Die laufende Partie durch eine neue ersetzen?"].waitForExistence(timeout: 3))
        // iOS presents this confirmation as a popover: tapping outside cancels it.
        outsideConfirmation.tap()
        XCTAssertFalse(app.buttons["Ersetzen und beginnen"].exists)
        app.navigationBars.buttons["Abbrechen"].tap()
        app.buttons["continue_game"].tap()
        XCTAssertTrue(app.buttons["node_a7"].label.contains("Weiß"))
        XCTAssertTrue(app.staticTexts["1 Zug"].exists)
        app.buttons["game_options"].tap()
        app.buttons["Neue Partie"].tap()
        app.buttons["start_game"].tap()
        XCTAssertTrue(app.staticTexts["Die laufende Partie durch eine neue ersetzen?"].waitForExistence(timeout: 3))
        app.buttons["Ersetzen und beginnen"].tap()
        XCTAssertTrue(app.staticTexts["0 Züge"].waitForExistence(timeout: 3))
    }
    @MainActor func testFinishedGameStartsAgainWithoutReplacementConfirmation() {
        let app = launch()
        // Shortest classic win from offline-games.json (0-loseNoLegalMoves).
        let moves = ["d6", "a4", "g1", "d2", "f4", "b4", "c4", "d1", "d3", "f2", "b2", "a7",
                     "a1", "g7", "d7", "d5", "e4", "g4", "e4-e5", "d5-c5", "e5-d5", "xc5", "b4-b6", "c4-b4"]
        app.buttons["new_game"].tap()
        app.buttons["opponent_local"].tap()
        app.buttons["start_game"].tap()
        // Check both entry points against a real engine-completed game.
        for fromHome in [false, true] {
            for move in moves {
                for node in move.replacingOccurrences(of: "x", with: "").split(separator: "-") {
                    app.buttons["node_\(node)"].tap()
                }
            }
            XCTAssertTrue(app.buttons["play_again"].waitForExistence(timeout: 3))
            if fromHome {
                app.navigationBars.buttons.element(boundBy: 0).tap()
                XCTAssertEqual(app.buttons["continue_game"].label, "Partie ansehen")
                app.buttons["new_game"].tap()
            } else {
                app.buttons["play_again"].tap()
            }
            app.buttons["opponent_local"].tap()
            app.buttons["start_game"].tap()
            XCTAssertTrue(app.staticTexts["0 Züge"].waitForExistence(timeout: 3))
            XCTAssertFalse(app.buttons["Ersetzen und beginnen"].exists)
            XCTAssertTrue(app.buttons["node_a7"].label.contains("frei"))
        }
    }
    @MainActor func testLegalMoveChooserMovesAlreadySelectedLaskerStone() {
        let app = launch()
        app.buttons["new_game"].tap()
        app.buttons["opponent_local"].tap()
        app.buttons["variant_lasker"].tap()
        app.buttons["start_game"].tap()
        app.buttons["node_a7"].tap()
        app.buttons["node_g7"].tap()
        app.buttons["node_a7"].tap() // Already selected, as it may also be after a hint.
        app.buttons["game_options"].tap()
        app.buttons["Mögliche Züge"].tap()
        let move = app.buttons["a7-d7"]
        for _ in 0..<12 {
            if move.exists { break }
            guard app.buttons["next_page"].isEnabled else { break }
            app.buttons["next_page"].tap()
        }
        XCTAssertTrue(move.exists)
        move.tap()
        XCTAssertTrue(app.staticTexts["3 Züge"].waitForExistence(timeout: 3))
        XCTAssertFalse(app.buttons["node_a7"].label.contains("Weiß"), "The chosen move must vacate its origin")
        XCTAssertTrue(app.buttons["node_d7"].label.contains("Weiß"))
        app.buttons["history"].tap()
        XCTAssertTrue(app.staticTexts["a7-d7"].exists, "The selected move must not become a placement")
    }
    @MainActor func testStoneMovementKeepsBoardTargetsFixedWithAndWithoutAnimation() {
        let app = launch()
        app.buttons["new_game"].tap()
        app.buttons["opponent_local"].tap()
        app.buttons["variant_lasker"].tap()
        app.buttons["start_game"].tap()
        let origin = app.buttons["node_a7"].frame
        let target = app.buttons["node_d7"].frame
        print("MOTION-NODES: \(origin) -> \(target)")
        for node in ["a7", "g7", "a7", "d7"] { app.buttons["node_\(node)"].tap() }
        XCTAssertTrue(app.buttons["node_d7"].label.contains("Weiß"))
        XCTAssertTrue(app.buttons["node_a7"].label.contains("frei"))
        XCTAssertEqual(app.buttons["node_a7"].frame, origin)
        XCTAssertEqual(app.buttons["node_d7"].frame, target)
        app.buttons["undo"].tap()
        XCTAssertTrue(app.buttons["node_a7"].label.contains("Weiß"))
        app.buttons["game_options"].tap()
        app.buttons["Spielhilfen"].tap()
        XCTAssertEqual(app.switches["animate_stones"].firstMatch.value as? String, "1")
        toggleSwitch("animate_stones", in: app)
        record("Stone-Animation-Option", app: app)
        app.buttons["display_done"].tap()
        for node in ["a7", "d7"] { app.buttons["node_\(node)"].tap() }
        XCTAssertTrue(app.buttons["node_d7"].label.contains("Weiß"))
        XCTAssertEqual(app.buttons["node_a7"].frame, origin)
        XCTAssertEqual(app.buttons["node_d7"].frame, target)
        XCTAssertEqual(app.scrollViews.count, 0)
    }
    @MainActor func testPendingCaptureSurvivesBackgroundAndRelaunch() {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing", "-ui-save", UUID().uuidString, "-AppleLanguages", "(de)", "-AppleLocale", "de_DE"]
        app.launch()
        app.buttons["new_game"].tap()
        app.buttons["opponent_local"].tap()
        app.buttons["start_game"].tap()
        for coordinate in ["c5", "a7", "d5", "d7", "e5"] { app.buttons["node_\(coordinate)"].tap() }
        XCTAssertTrue(app.staticTexts["Eine Mühle."].exists)
        XCUIDevice.shared.press(.home)
        app.activate()
        XCTAssertTrue(app.staticTexts["Eine Mühle."].waitForExistence(timeout: 3))
        app.terminate()
        app.launch()
        app.buttons["continue_game"].tap()
        XCTAssertTrue(app.staticTexts["Eine Mühle."].waitForExistence(timeout: 3))
        app.buttons["node_a7"].tap()
        XCTAssertTrue(app.staticTexts["Schwarz ist am Zug."].exists)
        XCTAssertTrue(app.staticTexts["6 Züge"].exists)
        app.buttons["undo"].tap()
        XCTAssertTrue(app.staticTexts["Eine Mühle."].exists)
        XCTAssertTrue(app.buttons["node_a7"].label.contains("Schwarz"))
    }
    @MainActor func testComputerReplyRemainsSingleAcrossBackgroundAndRelaunch() {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing", "-ui-save", UUID().uuidString, "-AppleLanguages", "(de)", "-AppleLocale", "de_DE"]
        app.launch()
        app.buttons["new_game"].tap()
        app.buttons["start_game"].tap()
        app.buttons["node_a7"].tap()
        XCUIDevice.shared.press(.home)
        app.activate()
        XCTAssertTrue(app.staticTexts["Du bist am Zug."].waitForExistence(timeout: 10))
        XCTAssertTrue(app.staticTexts["2 Züge"].exists)
        app.terminate()
        app.launch()
        app.buttons["continue_game"].tap()
        XCTAssertTrue(app.staticTexts["Du bist am Zug."].waitForExistence(timeout: 3))
        XCTAssertTrue(app.staticTexts["2 Züge"].exists)
        app.buttons["undo"].tap()
        XCTAssertTrue(app.staticTexts["0 Züge"].exists)
    }
    @MainActor func testPreviewScreenshot() {
        let app = launch(demo: true)
        XCTAssertTrue(app.buttons["node_a7"].waitForExistence(timeout: 5))
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = "Muehlenstein-Game"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    @MainActor func testEnglishNameAndHomeScreenshot() {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing", "-AppleLanguages", "(en)", "-AppleLocale", "en_US"]
        app.launch()
        XCTAssertTrue(app.staticTexts["Muehlenstein"].exists)
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = "Muehlenstein-Home-English"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    @MainActor private func assertVisible(_ element: XCUIElement, in app: XCUIApplication, file: StaticString = #filePath, line: UInt = #line) {
        XCTAssertTrue(element.exists, file: file, line: line)
        XCTAssertTrue(app.windows.firstMatch.frame.insetBy(dx: -1, dy: -1).contains(element.frame), "Clipped: \(element.identifier) \(element.frame)", file: file, line: line)
        XCTAssertTrue(element.isHittable, file: file, line: line)
    }
    @MainActor private func record(_ name: String, app: XCUIApplication) {
        let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    @MainActor private func toggleSwitch(_ key: String, in app: XCUIApplication) {
        let toggle = app.switches[key].firstMatch
        let before = toggle.value as? String
        // SwiftUI exposes the whole labelled row as a Switch; its actual control is at the trailing edge.
        toggle.coordinate(withNormalizedOffset: CGVector(dx: 1, dy: 0.5))
            .withOffset(CGVector(dx: -25, dy: 0)).tap()
        XCTAssertNotEqual(toggle.value as? String, before)
    }
    @MainActor private func assertFixedBoard(_ app: XCUIApplication) {
        XCTAssertTrue(app.buttons["node_a7"].waitForExistence(timeout: 5))
        XCTAssertEqual(app.scrollViews.count, 0)
        let nodes = app.buttons.matching(NSPredicate(format: "identifier BEGINSWITH %@", "node_"))
        XCTAssertEqual(nodes.count, 24)
        for node in nodes.allElementsBoundByIndex { assertVisible(node, in: app) }
        for key in ["undo", "hint", "history"] { assertVisible(app.buttons[key], in: app) }
        let before = app.buttons["node_a7"].frame
        app.buttons["node_d1"].press(forDuration: 0.05, thenDragTo: app.buttons["node_d2"])
        XCTAssertEqual(app.buttons["node_a7"].frame, before, "Dragging on the board must not shift the surface")
        app.buttons["node_a1"].tap()
        XCTAssertEqual(app.buttons["node_a7"].frame, before, "A new turn must not move the board")
    }
    @MainActor func testHomeAndSetupFitWithoutScrolling() {
        let app = launch()
        XCTAssertEqual(app.scrollViews.count, 0)
        XCTAssertFalse(app.staticTexts["ZEIT FÜR EINEN GUTEN ZUG"].exists)
        assertVisible(app.buttons["new_game"], in: app)
        assertVisible(app.buttons["learn_rules"], in: app)
        record("Fixed-Home", app: app)
        app.buttons["new_game"].tap()
        XCTAssertEqual(app.scrollViews.count, 0)
        assertVisible(app.buttons["start_game"], in: app)
        assertVariantsVisible(app)
        record("Fixed-Setup", app: app)
    }
    @MainActor func testBoardStaysFixedInPortrait() {
        let app = launch(demo: true)
        assertFixedBoard(app)
        record("Fixed-Game-Portrait", app: app)
    }
    @MainActor func testBoardAndSetupFitInLandscape() {
        XCUIDevice.shared.orientation = .landscapeLeft
        defer { XCUIDevice.shared.orientation = .portrait }
        let app = launch(demo: true)
        assertFixedBoard(app)
        record("Fixed-Game-Landscape", app: app)
        app.navigationBars.buttons.firstMatch.tap()
        assertVisible(app.buttons["continue_game"], in: app)
        assertVisible(app.buttons["new_game"], in: app)
        app.buttons["new_game"].tap()
        XCTAssertEqual(app.scrollViews.count, 0)
        assertVisible(app.buttons["start_game"], in: app)
        assertVariantsVisible(app)
        record("Fixed-Setup-Landscape", app: app)
    }
    @MainActor func testLargestTextKeepsBoardAndHomeAccessible() {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing", "-ui-demo", "-AppleLanguages", "(de)", "-AppleLocale", "de_DE",
                               "-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"]
        app.launch()
        assertFixedBoard(app)
        assertVisible(app.buttons["legal_moves"], in: app)
        record("Fixed-Game-Largest-Text", app: app)
        app.buttons["legal_moves"].tap()
        assertVisible(app.buttons["next_page"], in: app)
        app.buttons["next_page"].tap()
        XCTAssertTrue(app.staticTexts["page_count"].label.hasPrefix("2"))
        app.buttons["Fertig"].tap()
        app.navigationBars.buttons.firstMatch.tap()
        assertVisible(app.buttons["continue_game"], in: app)
        assertVisible(app.buttons["new_game"], in: app)
        assertVisible(app.buttons["learn_rules"], in: app)
        XCTAssertEqual(app.scrollViews.count, 0)
        record("Fixed-Home-Largest-Text", app: app)
        app.buttons["new_game"].tap()
        assertVisible(app.buttons["start_game"], in: app)
        assertVariantsVisible(app)
        record("Fixed-Setup-Largest-Text", app: app)
    }
    @MainActor func testLargestTextFitsLandscape() {
        XCUIDevice.shared.orientation = .landscapeLeft
        defer { XCUIDevice.shared.orientation = .portrait }
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing", "-ui-demo", "-AppleLanguages", "(de)", "-AppleLocale", "de_DE",
                               "-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"]
        app.launch()
        assertFixedBoard(app)
        record("Fixed-Game-Largest-Landscape", app: app)
        app.navigationBars.buttons.firstMatch.tap()
        assertVisible(app.buttons["continue_game"], in: app)
        assertVisible(app.buttons["new_game"], in: app)
        assertVisible(app.buttons["learn_rules"], in: app)
        record("Fixed-Home-Largest-Landscape", app: app)
        app.buttons["new_game"].tap()
        assertVisible(app.buttons["start_game"], in: app)
        assertVariantsVisible(app)
        record("Fixed-Setup-Largest-Landscape", app: app)
    }
    @MainActor func testLicenseAndAboutFitLargestLandscapeText() {
        XCUIDevice.shared.orientation = .landscapeLeft
        defer { XCUIDevice.shared.orientation = .portrait }
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing", "-AppleLanguages", "(de)", "-AppleLocale", "de_DE",
                               "-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"]
        app.launch()
        app.buttons["about"].tap()
        for _ in 0..<3 {
            if app.buttons["license"].exists && app.buttons["license"].isHittable { break }
            app.buttons["next_page"].tap()
        }
        assertVisible(app.buttons["license"], in: app)
        app.buttons["license"].tap()
        XCTAssertTrue((app.textViews.firstMatch.value as? String)?.contains("GNU AFFERO") == true)
        // NavigationStack may retain the disabled pager of the preceding screen in its AX tree.
        let next = app.buttons.matching(NSPredicate(format: "identifier == %@ AND enabled == true", "next_page")).firstMatch
        assertVisible(next, in: app)
        let firstPage = app.textViews.firstMatch.value as? String
        next.tap()
        XCTAssertNotEqual(app.textViews.firstMatch.value as? String, firstPage)
        record("Fixed-License-Largest-Landscape", app: app)
    }
    @MainActor func testRulesUsePagesWithoutScrolling() {
        let app = launch()
        app.buttons["learn_rules"].tap()
        let firstText = app.textViews.firstMatch.value as? String
        XCTAssertFalse(firstText?.isEmpty ?? true)
        app.buttons["next_page"].tap()
        XCTAssertNotEqual(app.textViews.firstMatch.value as? String, firstText)
        app.buttons["previous_page"].tap()
        XCTAssertEqual(app.textViews.firstMatch.value as? String, firstText)
        record("Paged-Rules", app: app)
    }

    @MainActor func testPlayingAidsCanBeHiddenAndPersistAcrossRelaunch() {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing", "-ui-save", UUID().uuidString, "-AppleLanguages", "(de)", "-AppleLocale", "de_DE"]
        app.launch()
        app.buttons["new_game"].tap()
        app.buttons["start_game"].tap()
        XCTAssertEqual(app.buttons.matching(NSPredicate(format: "value CONTAINS %@", "mögliches Ziel")).count, 24)
        app.buttons["node_a7"].tap()
        XCTAssertTrue(app.staticTexts["Du bist am Zug."].waitForExistence(timeout: 10))
        XCTAssertEqual(app.buttons.matching(NSPredicate(format: "value CONTAINS %@", "Ziel des letzten Zuges")).count, 1)
        XCTAssertFalse(app.otherElements["player_1"].label.contains("Stufe"))
        let boardFrame = app.buttons["node_a7"].frame
        app.buttons["game_options"].tap()
        app.buttons["Spielhilfen"].tap()
        record("Options-Playing-Aids", app: app)
        for key in ["show_legal", "show_last", "animate_stones"] { toggleSwitch(key, in: app) }
        app.buttons["display_done"].tap()
        XCTAssertEqual(app.buttons["node_a7"].frame, boardFrame)
        for fragment in ["mögliches Ziel", "Ziel des letzten Zuges"] {
            XCTAssertEqual(app.buttons.matching(NSPredicate(format: "value CONTAINS %@", fragment)).count, 0)
        }
        XCTAssertFalse(app.staticTexts.matching(NSPredicate(format: "label BEGINSWITH %@", "Computer:")).firstMatch.exists)
        XCTAssertFalse(app.otherElements["player_1"].label.contains("Stufe"))
        record("Options-Clean-Board", app: app)
        app.terminate()
        app.launch()
        app.buttons["continue_game"].tap()
        XCTAssertEqual(app.buttons.matching(NSPredicate(format: "value CONTAINS %@", "mögliches Ziel")).count, 0)
        XCTAssertEqual(app.buttons.matching(NSPredicate(format: "value CONTAINS %@", "Ziel des letzten Zuges")).count, 0)
        app.buttons["game_options"].tap()
        app.buttons["Spielhilfen"].tap()
        for key in ["show_legal", "show_last", "animate_stones"] {
            XCTAssertEqual(app.switches[key].firstMatch.value as? String, "0")
            toggleSwitch(key, in: app)
        }
        app.buttons["display_done"].tap()
        XCTAssertEqual(app.buttons.matching(NSPredicate(format: "value CONTAINS %@", "mögliches Ziel")).count, 22)
        XCTAssertEqual(app.buttons.matching(NSPredicate(format: "value CONTAINS %@", "Ziel des letzten Zuges")).count, 1)
    }

    @MainActor private func showSetupPanel(_ key: String, in app: XCUIApplication) {
        if app.buttons["setup_tab_" + key].exists {
            app.buttons["setup_tab_" + key].tap()
        } else if ["advanced", "style", "book"].contains(key) && !app.buttons["algorithm_pvs"].exists {
            app.buttons["advanced_options"].tap()
        }
    }
    @MainActor private func assertVariantsVisible(_ app: XCUIApplication) {
        showSetupPanel("variant", in: app)
        for key in ["classic", "twelve", "morabaraba", "lasker"] {
            assertVisible(app.buttons["variant_" + key], in: app)
            XCTAssertLessThanOrEqual(app.buttons["variant_" + key].frame.maxY, app.buttons["start_game"].frame.minY - 2, "Variant must not overlap the start button")
        }
    }
    @MainActor func testAdvancedSearchSelectionAndExplanations() {
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing", "-ui-save", UUID().uuidString, "-AppleLanguages", "(de)", "-AppleLocale", "de_DE"]
        app.launch()
        app.buttons["new_game"].tap()
        XCTAssertFalse(app.buttons["computer_options"].exists)
        XCTAssertFalse(app.buttons["algorithm_pvs"].exists)
        XCTAssertTrue(app.staticTexts["difficulty_value"].label.hasPrefix("3"))
        assertVariantsVisible(app)
        record("Inline-Setup", app: app)
        showSetupPanel("advanced", in: app)
        XCTAssertTrue(app.buttons["algorithm_mtdf"].isSelected)
        app.buttons["algorithm_pvs"].tap()
        app.buttons["effort_extended"].tap()
        showSetupPanel("style", in: app)
        XCTAssertTrue(app.buttons["style_balanced"].isSelected)
        app.buttons["style_blocking"].tap()
        app.buttons["info_style_help"].tap()
        var styleExplanation = ""
        for _ in 0..<12 {
            styleExplanation += (app.textViews.firstMatch.value as? String) ?? ""
            let next = app.buttons.matching(NSPredicate(format: "identifier == %@ AND enabled == true", "next_page")).firstMatch
            if !next.exists { break }
            next.tap()
        }
        for text in ["Voreinstellung", "Stärke:", "Schwäche:", "schwächer", "unabhängig von der Spielstufe"] {
            XCTAssertTrue(styleExplanation.contains(text))
        }
        app.navigationBars["Spielstil erklärt"].buttons["Fertig"].tap()
        showSetupPanel("book", in: app)
        XCTAssertTrue(app.buttons["book_automatic"].isSelected)
        app.buttons["book_off"].tap()
        app.buttons["info_book_help"].tap()
        var bookExplanation = ""
        for _ in 0..<12 {
            bookExplanation += (app.textViews.firstMatch.value as? String) ?? ""
            let next = app.buttons.matching(NSPredicate(format: "identifier == %@ AND enabled == true", "next_page")).firstMatch
            if !next.exists { break }
            next.tap()
        }
        for text in ["Stufe 4 und 5", "offline", "keinen perfekten", "Spielstil"] {
            XCTAssertTrue(bookExplanation.contains(text))
        }
        app.navigationBars["Eröffnungsbuch"].buttons["Fertig"].tap()
        showSetupPanel("advanced", in: app)
        XCTAssertTrue(app.navigationBars["Neue Partie"].exists)
        XCTAssertEqual(app.scrollViews.count, 0)
        record("Inline-Setup-Advanced", app: app)
        app.buttons["info_search_comparison"].tap()
        var explanation = ""
        for _ in 0..<12 {
            explanation += (app.textViews.firstMatch.value as? String) ?? ""
            let next = app.buttons.matching(NSPredicate(format: "identifier == %@ AND enabled == true", "next_page")).firstMatch
            if !next.exists { break }
            next.tap()
        }
        for fragment in ["MTD(f) · Voreinstellung", "PVS · Alternative", "Stärke:", "Schwäche:", "mittleren Stufe", "keinen belastbaren"] {
            XCTAssertTrue(explanation.contains(fragment))
        }
        app.navigationBars["Suchverfahren erklärt"].buttons["Fertig"].tap()
        app.buttons["start_game"].tap()
        app.buttons["game_options"].tap()
        app.buttons["Computer einstellen"].tap()
        showSetupPanel("advanced", in: app)
        XCTAssertTrue(app.buttons["algorithm_pvs"].isSelected)
        XCTAssertTrue(app.buttons["effort_extended"].isSelected)
        showSetupPanel("style", in: app)
        XCTAssertTrue(app.buttons["style_blocking"].isSelected)
        record("Inline-Computer-Options", app: app)
        app.buttons["computer_done"].tap()
        app.buttons["node_a7"].tap()
        XCTAssertTrue(app.staticTexts["Du bist am Zug."].waitForExistence(timeout: 10))
        app.terminate()
        app.launch()
        app.buttons["continue_game"].tap()
        app.buttons["game_options"].tap()
        app.buttons["Computer einstellen"].tap()
        showSetupPanel("style", in: app)
        XCTAssertTrue(app.buttons["style_blocking"].isSelected)
        app.buttons["style_balanced"].tap()
        showSetupPanel("book", in: app)
        XCTAssertTrue(app.buttons["book_off"].isSelected)
        app.buttons["book_automatic"].tap()
        app.buttons["computer_done"].tap()
        app.buttons["game_options"].tap()
        app.buttons["Computer einstellen"].tap()
        showSetupPanel("style", in: app)
        XCTAssertTrue(app.buttons["style_balanced"].isSelected)
        showSetupPanel("book", in: app)
        XCTAssertTrue(app.buttons["book_automatic"].isSelected)
    }

    @MainActor func testFiveLevelsAndCancelledAdvancedChanges() {
        let app = launch()
        app.buttons["new_game"].tap()
        for level in 1...5 {
            app.sliders["difficulty_slider"].adjust(toNormalizedSliderPosition: CGFloat(level - 1) / 4)
            XCTAssertTrue(app.staticTexts["difficulty_value"].label.hasPrefix("\(level) ·"))
        }
        for key in ["twelve", "morabaraba", "lasker", "classic"] {
            app.buttons["variant_" + key].tap()
            XCTAssertTrue(app.buttons["variant_" + key].isSelected)
        }
        app.buttons["opponent_local"].tap()
        XCTAssertFalse(app.sliders["difficulty_slider"].exists)
        XCTAssertFalse(app.buttons["advanced_options"].exists)
        app.buttons["opponent_computer"].tap()
        XCTAssertTrue(app.staticTexts["difficulty_value"].label.hasPrefix("5"))
        app.buttons["start_game"].tap()
        XCTAssertFalse(app.otherElements["player_1"].label.contains("Stufe"))
        app.buttons["game_options"].tap()
        app.buttons["Computer einstellen"].tap()
        showSetupPanel("advanced", in: app)
        app.buttons["algorithm_pvs"].tap()
        app.buttons["effort_extended"].tap()
        showSetupPanel("style", in: app)
        app.buttons["style_blocking"].tap()
        showSetupPanel("book", in: app)
        app.buttons["book_off"].tap()
        app.navigationBars["Computer"].buttons["Abbrechen"].tap()
        app.buttons["game_options"].tap()
        app.buttons["Computer einstellen"].tap()
        showSetupPanel("advanced", in: app)
        XCTAssertTrue(app.buttons["algorithm_mtdf"].isSelected)
        XCTAssertTrue(app.buttons["effort_standard"].isSelected)
        showSetupPanel("style", in: app)
        XCTAssertTrue(app.buttons["style_balanced"].isSelected)
        showSetupPanel("book", in: app)
        XCTAssertTrue(app.buttons["book_automatic"].isSelected)
        app.buttons["computer_done"].tap()
        app.buttons["node_a7"].tap()
        XCTAssertTrue(app.staticTexts["Du bist am Zug."].waitForExistence(timeout: 10))
    }

    @MainActor func testOptionsFitLargestTextInLandscapeWithoutScrolling() {
        XCUIDevice.shared.orientation = .landscapeLeft
        defer { XCUIDevice.shared.orientation = .portrait }
        let app = XCUIApplication()
        app.launchArguments = ["-ui-testing", "-AppleLanguages", "(de)", "-AppleLocale", "de_DE",
                               "-UIPreferredContentSizeCategoryName", "UICTContentSizeCategoryAccessibilityXXXL"]
        app.launch()
        app.buttons["display_options"].tap()
        for key in ["show_legal", "show_last", "animate_stones"] {
            let toggle = app.switches[key].firstMatch
            if !toggle.exists { app.buttons["next_page"].tap() }
            assertVisible(toggle, in: app)
            toggleSwitch(key, in: app)
            XCTAssertEqual(app.scrollViews.count, 0)
        }
        record("Inline-Playing-Aids-Largest-Landscape", app: app)
        app.buttons["display_done"].tap()
        app.buttons["new_game"].tap()
        showSetupPanel("difficulty", in: app)
        assertVisible(app.sliders["difficulty_slider"], in: app)
        assertVisible(app.buttons["info_computer_help"], in: app)
        record("Inline-Difficulty-Largest-Landscape", app: app)
        assertVariantsVisible(app)
        for key in ["classic", "twelve", "morabaraba", "lasker"] {
            app.buttons["variant_" + key].tap()
            XCTAssertTrue(app.buttons["variant_" + key].isSelected)
            XCTAssertTrue(app.navigationBars["Neue Partie"].exists)
        }
        record("Inline-Variants-Largest-Landscape", app: app)
        showSetupPanel("advanced", in: app)
        for key in ["algorithm_mtdf", "algorithm_pvs", "effort_standard", "effort_extended", "info_search_comparison", "info_search_help"] {
            assertVisible(app.buttons[key], in: app)
            XCTAssertLessThanOrEqual(app.buttons[key].frame.maxY, app.buttons["start_game"].frame.minY - 2)
        }
        XCTAssertEqual(app.scrollViews.count, 0)
        assertVisible(app.buttons["start_game"], in: app)
        record("Inline-Advanced-Largest-Landscape", app: app)
        showSetupPanel("style", in: app)
        for key in ["style_balanced", "style_blocking", "info_style_help"] {
            assertVisible(app.buttons[key], in: app)
            XCTAssertLessThanOrEqual(app.buttons[key].frame.maxY, app.buttons["start_game"].frame.minY - 2)
        }
        app.buttons["style_blocking"].tap()
        XCTAssertTrue(app.buttons["style_blocking"].isSelected)
        XCTAssertEqual(app.scrollViews.count, 0)
        record("Inline-Style-Largest-Landscape", app: app)
        showSetupPanel("book", in: app)
        for key in ["book_automatic", "book_off", "info_book_help"] {
            assertVisible(app.buttons[key], in: app)
            XCTAssertLessThanOrEqual(app.buttons[key].frame.maxY, app.buttons["start_game"].frame.minY - 2)
        }
        app.buttons["book_off"].tap()
        XCTAssertTrue(app.buttons["book_off"].isSelected)
        XCTAssertEqual(app.scrollViews.count, 0)
        record("Inline-Book-Largest-Landscape", app: app)
    }
}
