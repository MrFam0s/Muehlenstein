// SPDX-License-Identifier: AGPL-3.0-or-later
// Copyright (C) 2026 Fabian Amos / AmoSystems
import Foundation

enum AppInformation {
    static let company = "AmoSystems"
    static let owner = "Fabian Amos"
    static let address = "Christburger Str. 15/2\n10405 Berlin"
    static let email = "info@fabianamos.com"
    static let vatID = "DE272109895"
    static let website = URL(string: "https://amosystems.org")!
    static let emailURL = URL(string: "mailto:info@fabianamos.com")!
    static let source = URL(string: "https://github.com/MrFam0s/Muehlenstein")!
    static let upstream = URL(string: "https://github.com/calcitem/Sanmill/tree/8901a06f088bf49a1602fee8686ed25ac5a33925")!

    struct Build: Equatable {
        let version: String
        let number: String
        let identifier: String
        init(info: [String: Any]) {
            version = info["CFBundleShortVersionString"] as? String ?? "–"
            number = info["CFBundleVersion"] as? String ?? "–"
            identifier = info["CFBundleIdentifier"] as? String ?? "–"
        }
        var display: String { L10n.format("version_build", version, number) }
    }
    static var build: Build { Build(info: Bundle.main.infoDictionary ?? [:]) }
    static var imprint: String {
        [company + "\n" + owner, address + "\n" + L10n.text("germany"),
         L10n.text("contact") + "\n" + email + "\namosystems.org",
         L10n.text("vat_id") + "\n" + vatID].joined(separator: "\n\n")
    }
    static var credits: String {
        [L10n.text("about_body"), L10n.text("credits_body"),
         "© 2026 Fabian Amos / AmoSystems", build.display, build.identifier,
         "Sanmill · 8901a06f088bf49a1602fee8686ed25ac5a33925"].joined(separator: "\n\n")
    }
}

struct LicenseNotice: Decodable, Identifiable {
    let id: String
    let title: String
    let text: String?
    let children: [LicenseNotice]?

    static func load(bundle: Bundle = .main) throws -> [LicenseNotice] {
        guard let url = bundle.url(forResource: "notices", withExtension: "json", subdirectory: "Legal") else {
            throw CocoaError(.fileNoSuchFile)
        }
        return try JSONDecoder().decode([LicenseNotice].self, from: Data(contentsOf: url))
    }
}
