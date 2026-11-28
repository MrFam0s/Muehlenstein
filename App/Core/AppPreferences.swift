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
    var lastComputerLevel: Int { didSet { defaults.set(lastComputerLevel, forKey: "lastComputerLevel") } }

    private(set) var usesAdaptiveStrength: Bool {
        didSet { defaults.set(usesAdaptiveStrength, forKey: "usesAdaptiveStrength") }
    }

    var newGameSettings: GameSettings {
        GameSettings(level: lastComputerLevel, adaptive: usesAdaptiveStrength)
    }

    func rememberComputerSettings(_ settings: GameSettings) {
        usesAdaptiveStrength = settings.adaptive
        if !settings.adaptive { lastComputerLevel = settings.level }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        usesAdaptiveStrength = defaults.bool(forKey: "usesAdaptiveStrength")
        showLegalMoves = defaults.object(forKey: "showLegalMoves") as? Bool ?? false
        showLastMove = defaults.object(forKey: "showLastMove") as? Bool ?? false
        animateStones = defaults.object(forKey: "animateStones") as? Bool ?? true
        accentPalette = defaults.string(forKey: "accentPalette").flatMap(AccentPalette.init(rawValue:)) ?? .slate
        let storedLevel = defaults.object(forKey: "lastComputerLevel") as? Int
        lastComputerLevel = storedLevel.flatMap { GameSettings.levels.contains($0) ? $0 : nil } ?? GameSettings.defaultLevel
    }
}
