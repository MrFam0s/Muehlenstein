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
         L10n.text("vat_id") + "\n" + vatID,
         L10n.text("made_in_berlin")].joined(separator: "\n\n")
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

/// Presentation-only reflow. Original bundled notices remain untouched.
/// Paragraphs, list entries, headings and literal examples retain their boundaries.
enum LicenseText {
    enum Kind: Equatable { case heading, paragraph, listItem, literal }
    struct Block {
        let text: String
        let kind: Kind
    }

    static func blocks(_ source: String) -> [Block] {
        let lines = source.replacingOccurrences(of: "\r\n", with: "\n")
            .replacingOccurrences(of: "\r", with: "\n").components(separatedBy: "\n")
        var result: [Block] = []
        var paragraph: [String] = []
        var fenced = false

        func matches(_ text: String, _ pattern: String) -> Bool {
            text.range(of: pattern, options: .regularExpression) != nil
        }
        func isList(_ line: String) -> Bool {
            matches(line, #"^(?:[-*•]|\(?[a-zA-Z0-9]+\)|[0-9]+\.)\s+"#)
        }
        func isHeading(_ text: String) -> Bool {
            if matches(text, #"^#{1,6}\s+"#) { return true }
            if matches(text, #"^(?:LICENSE|COPYING|NOTICE)(?:[-_.][A-Za-z0-9.-]+)?$"#) { return true }
            if ["Preamble", "Terms of Use", "Apache License", "MIT License",
                "How to Apply These Terms to Your New Programs"].contains(text) { return true }
            // Short numbered titles, not a paragraph beginning with a clause number.
            if text.count < 110, matches(text, #"^[0-9]+\. [^.]+\.$"#) { return true }
            return text.count < 100 && text == text.uppercased() &&
                text.rangeOfCharacter(from: .letters) != nil && !matches(text, #"[,;\"]"#)
        }
        func flush() {
            guard !paragraph.isEmpty else { return }
            var text = paragraph[0]
            for line in paragraph.dropFirst() {
                text += (text.hasSuffix("-") ? "" : " ") + line
            }
            let kind: Kind = isHeading(text) ? .heading : (isList(text) ? .listItem : .paragraph)
            result.append(Block(text: text, kind: kind))
            paragraph.removeAll(keepingCapacity: true)
        }

        for raw in lines {
            let line = raw.trimmingCharacters(in: .whitespaces)
            if line.hasPrefix("```") || line.hasPrefix("~~~") {
                flush()
                fenced.toggle()
                result.append(Block(text: raw, kind: .literal))
            } else if fenced || line.hasPrefix("|") || matches(line, #"^[-=+_]{3,}$"#) {
                flush()
                result.append(Block(text: raw, kind: .literal))
            } else if line.isEmpty {
                flush()
            } else if matches(line, #"^#{1,6}\s+"#) {
                flush()
                result.append(Block(text: line, kind: .heading))
            } else if matches(line, #"^(?:https?://|URL:|Authors:|License:|Copyright|©|Version [0-9])"#) {
                flush()
                result.append(Block(text: line, kind: .paragraph))
            } else {
                if isList(line) { flush() }
                paragraph.append(line)
            }
        }
        flush()
        return result
    }
}
