// SPDX-License-Identifier: AGPL-3.0-or-later
import Foundation
import Observation

enum AccentPalette: String, CaseIterable, Identifiable {
    case slate, forest, aubergine, terracotta, petrol, rose
    var id: String { rawValue }
    var name: String { L10n.text("accent_" + rawValue) }
    var assetName: String { self == .slate ? "AccentColor" : "Accent-" + rawValue }
}

@MainActor @Observable final class AppPreferences {
    private let defaults: UserDefaults
    var showLegalMoves: Bool { didSet { defaults.set(showLegalMoves, forKey: "showLegalMoves") } }
    var showLastMove: Bool { didSet { defaults.set(showLastMove, forKey: "showLastMove") } }
    var animateStones: Bool { didSet { defaults.set(animateStones, forKey: "animateStones") } }
    var accentPalette: AccentPalette { didSet { defaults.set(accentPalette.rawValue, forKey: "accentPalette") } }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        showLegalMoves = defaults.object(forKey: "showLegalMoves") as? Bool ?? false
        showLastMove = defaults.object(forKey: "showLastMove") as? Bool ?? false
        animateStones = defaults.object(forKey: "animateStones") as? Bool ?? true
        accentPalette = defaults.string(forKey: "accentPalette").flatMap(AccentPalette.init(rawValue:)) ?? .slate
    }
}
