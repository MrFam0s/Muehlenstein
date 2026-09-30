// SPDX-License-Identifier: AGPL-3.0-or-later
import SwiftUI

@main struct MuehlensteinApp: App {
    @State private var store: GameStore
    @State private var preferences: AppPreferences
    init() {
        let isTest = ProcessInfo.processInfo.arguments.contains("-ui-testing")
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
        WindowGroup { HomeView(store: store).environment(preferences).tint(.petrol) }
    }
}
