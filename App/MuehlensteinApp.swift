// SPDX-License-Identifier: AGPL-3.0-or-later
import SwiftUI

@main struct MuehlensteinApp: App {
    @State private var store: GameStore
    @State private var preferences: AppPreferences
    init() {
        let isTest = ProcessInfo.processInfo.arguments.contains("-ui-testing")
        // Keep an attached phone awake only during UI tests; ordinary launches use its normal timer.
        if isTest { UIApplication.shared.isIdleTimerDisabled = true }
        let args = ProcessInfo.processInfo.arguments
        var testStorage: URL?
        if isTest, let index = args.firstIndex(of: "-ui-save"), args.indices.contains(index + 1),
           let id = UUID(uuidString: args[index + 1]) {
            testStorage = URL.applicationSupportDirectory.appending(path: "MuehlensteinTests/\(id.uuidString).json")
        }
        let store = GameStore(inMemory: isTest && testStorage == nil, storageURL: testStorage)
        if ProcessInfo.processInfo.arguments.contains("-ui-demo") { store.loadPreviewGame() }
        _store = State(initialValue: store)
        let defaults = isTest ? UserDefaults(suiteName: "MuehlensteinTests.\(testStorage?.lastPathComponent ?? UUID().uuidString)")! : .standard
        _preferences = State(initialValue: AppPreferences(defaults: defaults))
    }
    var body: some Scene {
        WindowGroup {
            HomeView(store: store).environment(preferences)
                .environment(\.accentPalette, preferences.accentPalette).tint(preferences.accentPalette.color)
                .preferredColorScheme(testColorScheme)
        }
    }
    // Screenshot/audit runs must cover both appearances without changing device preferences.
    private var testColorScheme: ColorScheme? {
        let args = ProcessInfo.processInfo.arguments
        guard args.contains("-ui-testing"), let index = args.firstIndex(of: "-ui-appearance"),
              args.indices.contains(index + 1) else { return nil }
        return args[index + 1] == "dark" ? .dark : .light
    }
}
