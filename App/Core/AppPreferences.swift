// SPDX-License-Identifier: AGPL-3.0-or-later
import Foundation
import Observation

@MainActor @Observable final class AppPreferences {
    private let defaults: UserDefaults
    var showLegalMoves: Bool { didSet { defaults.set(showLegalMoves, forKey: "showLegalMoves") } }
    var showLastMove: Bool { didSet { defaults.set(showLastMove, forKey: "showLastMove") } }
    var animateStones: Bool { didSet { defaults.set(animateStones, forKey: "animateStones") } }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        showLegalMoves = defaults.object(forKey: "showLegalMoves") as? Bool ?? false
        showLastMove = defaults.object(forKey: "showLastMove") as? Bool ?? false
        animateStones = defaults.object(forKey: "animateStones") as? Bool ?? true
    }
}
