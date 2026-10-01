// SPDX-License-Identifier: AGPL-3.0-or-later
// Copyright (C) 2026 Fabian Amos / AmoSystems
import SwiftUI
import UIKit

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    private let sections = ["imprint", "privacy", "credits", "license", "third_party"]

    var body: some View {
        NavigationStack {
            AboutPage(identifier: "about_sections") {
                HStack(alignment: .top, spacing: 16) {
                    BrandMark()
                    VStack(alignment: .leading, spacing: 8) {
                        Text(L10n.text("app_name")).font(.system(.title2, design: .serif))
                        Text(AppInformation.build.display).font(.subheadline).foregroundStyle(Color.quietInk)
                            .accessibilityIdentifier("about_version")
                    }
                }.padding(.vertical, 8)
                VStack(spacing: 0) {
                    ForEach(sections, id: \.self) { section in
                        if section != sections.first { Divider().padding(.horizontal, 18) }
                        NavigationLink {
                            switch section {
                            case "imprint": ImprintView()
                            case "privacy": PrivacyView()
                            case "credits": CreditsView()
                            case "third_party": LicenseNoticesView()
                            default: LicenseView()
                            }
                        } label: {
                            HStack(spacing: 14) {
                                Image(systemName: symbol(section)).frame(width: 24).accessibilityHidden(true)
                                Text(L10n.text(section)).frame(maxWidth: .infinity, alignment: .leading)
                                Image(systemName: "chevron.right").font(.caption).accessibilityHidden(true)
                            }.padding(18).frame(minHeight: 60).contentShape(Rectangle())
                        }.accessibilityIdentifier(section)
                    }
                }.background(Color.boardSurface, in: RoundedRectangle(cornerRadius: 22))
            }
            .navigationTitle(L10n.text("about")).navigationBarTitleDisplayMode(.inline)
            .toolbar { ToolbarItem(placement: .confirmationAction) { Button(L10n.text("done")) { dismiss() } } }
        }.presentationDetents([.large])
    }

    private func symbol(_ section: String) -> String {
        switch section {
        case "imprint": "building.2"
        case "privacy": "hand.raised"
        case "credits": "info.circle"
        case "third_party": "books.vertical"
        default: "doc.text"
        }
    }
}

/// A single reading column; informational pages can grow with the preferred text size.
private struct AboutPage<Content: View>: View {
    let identifier: String
    @ViewBuilder var content: () -> Content

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28, content: content)
                .frame(maxWidth: 640, alignment: .leading)
                .padding(24).frame(maxWidth: .infinity)
        }.accessibilityIdentifier(identifier)
            .background(Color.limestone).foregroundStyle(Color.ink)
    }
}

private struct AboutSection<Content: View>: View {
    let title: String
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.text(title)).font(.system(.title3, design: .serif).weight(.semibold))
                .fixedSize(horizontal: false, vertical: true).accessibilityAddTraits(.isHeader)
            content()
        }.frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct AboutLink: View {
    let key: String
    let title: String
    let icon: String
    let url: URL

    var body: some View {
        Link(destination: url) {
            Label(title, systemImage: icon).fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
        }.foregroundStyle(Color.petrol)
            .accessibilityLabel(L10n.text(key)).accessibilityIdentifier(key)
    }
}

private struct ImprintView: View {
    var body: some View {
        AboutPage(identifier: "imprint_content") {
            AboutSection(title: "about_provider") {
                VStack(alignment: .leading, spacing: 6) {
                    Text(AppInformation.company).font(.headline)
                    Text(AppInformation.owner)
                }
                Text(AppInformation.address + "\n" + L10n.text("germany")).lineSpacing(4)
            }
            AboutSection(title: "contact") {
                VStack(alignment: .leading, spacing: 2) {
                    AboutLink(key: "contact_email", title: AppInformation.email, icon: "envelope", url: AppInformation.emailURL)
                    AboutLink(key: "website", title: "amosystems.org", icon: "globe", url: AppInformation.website)
                }
            }
            AboutSection(title: "about_vat") { Text(AppInformation.vatID) }
            Divider()
            Text(L10n.text("made_in_berlin")).font(.subheadline).foregroundStyle(Color.quietInk)
        }.navigationTitle(L10n.text("imprint")).navigationBarTitleDisplayMode(.inline)
    }
}

private struct PrivacyView: View {
    var body: some View {
        AboutPage(identifier: "privacy_content") {
            AboutParagraphs(text: L10n.text("privacy_body"), headings: ["privacy_play", "privacy_device", "privacy_external"])
        }.navigationTitle(L10n.text("privacy")).navigationBarTitleDisplayMode(.inline)
    }
}

private struct CreditsView: View {
    var body: some View {
        AboutPage(identifier: "credits_content") {
            ReadingText(text: L10n.text("about_body"))
            AboutParagraphs(text: L10n.text("credits_body"), headings: ["credits_design", "credits_engine", "credits_license"])
            VStack(alignment: .leading, spacing: 4) {
                AboutLink(key: "source_code", title: L10n.text("source_code"), icon: "chevron.left.forwardslash.chevron.right", url: AppInformation.source)
                AboutLink(key: "Sanmill", title: "Sanmill", icon: "arrow.up.right.square", url: AppInformation.upstream)
            }
            Divider()
            Text("© 2026 Fabian Amos / AmoSystems").font(.footnote).foregroundStyle(Color.quietInk)
            DisclosureGroup(L10n.text("about_technical")) {
                VStack(alignment: .leading, spacing: 12) {
                    Text(AppInformation.build.display)
                    Text(AppInformation.build.identifier)
                    Text("Sanmill · 8901a06f088bf49a1602fee8686ed25ac5a33925")
                }.font(.footnote).textSelection(.enabled)
                    .frame(maxWidth: .infinity, alignment: .leading).padding(.top, 12)
            }
        }.navigationTitle(L10n.text("credits")).navigationBarTitleDisplayMode(.inline)
    }
}

private struct AboutParagraphs: View {
    let text: String
    let headings: [String]

    var body: some View {
        ForEach(Array(text.components(separatedBy: "\n\n").enumerated()), id: \.offset) { index, paragraph in
            if headings.indices.contains(index) {
                AboutSection(title: headings[index]) { ReadingText(text: paragraph) }
            } else {
                ReadingText(text: paragraph)
            }
        }
    }
}

/// TextKit supplies hyphenation and justified prose. Narrow lines use natural
/// alignment so large text does not acquire distracting gaps between words.
private struct ReadingText: UIViewRepresentable {
    let text: String
    var scrolls = false
    @ScaledMetric(relativeTo: .body) private var fontSize = 17

    func makeUIView(context: Context) -> UITextView {
        let view = UITextView(usingTextLayoutManager: false)
        view.isEditable = false
        view.isScrollEnabled = scrolls
        view.backgroundColor = .clear
        view.textContainer.lineFragmentPadding = 0
        view.textContainerInset = scrolls ? UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24) : .zero
        view.contentInsetAdjustmentBehavior = .automatic
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return view
    }

    func updateUIView(_ view: UITextView, context: Context) {
        applyText(to: view, width: view.bounds.width)
    }

    func sizeThatFits(_ proposal: ProposedViewSize, uiView: UITextView, context: Context) -> CGSize? {
        guard let width = proposal.width else { return nil }
        applyText(to: uiView, width: width)
        if scrolls { return CGSize(width: width, height: proposal.height ?? 500) }
        return uiView.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude))
    }

    private func applyText(to view: UITextView, width: CGFloat) {
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineSpacing = 4
        // License documents retain their original line breaks and alignment.
        paragraph.alignment = !scrolls && width / fontSize >= 26 ? .justified : .natural
        paragraph.hyphenationFactor = scrolls ? 0 : 0.7
        let attributed = NSAttributedString(string: text, attributes: [
            .font: UIFont.systemFont(ofSize: fontSize), .foregroundColor: UIColor(Color.ink),
            .paragraphStyle: paragraph
        ])
        if !view.attributedText.isEqual(to: attributed) { view.attributedText = attributed }
    }
}

private struct LicenseDocument: View {
    let text: String
    var body: some View {
        ReadingText(text: text, scrolls: true).accessibilityIdentifier("license_document")
            .frame(maxWidth: 688).frame(maxWidth: .infinity).background(Color.limestone)
    }
}

struct LicenseNoticesView: View {
    var notices: [LicenseNotice]? = nil
    var title: String = L10n.text("third_party")
    @State private var loaded: [LicenseNotice]?
    @State private var failed = false
    var body: some View {
        Group {
            if let entries = notices ?? loaded {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(entries) { notice in
                            NavigationLink {
                                if let children = notice.children {
                                    LicenseNoticesView(notices: children, title: notice.title)
                                } else {
                                    LicenseDocument(text: notice.text ?? "").navigationTitle(notice.title)
                                        .navigationBarTitleDisplayMode(.inline)
                                }
                            } label: {
                                HStack(spacing: 12) {
                                    Text(notice.title).frame(maxWidth: .infinity, alignment: .leading)
                                        .fixedSize(horizontal: false, vertical: true)
                                    Image(systemName: "chevron.right").font(.caption).accessibilityHidden(true)
                                }.padding(.vertical, 16).frame(minHeight: 56).contentShape(Rectangle())
                            }.accessibilityIdentifier(notice.id)
                            Divider()
                        }
                    }.frame(maxWidth: 640).padding(.horizontal, 24).padding(.vertical, 12)
                        .frame(maxWidth: .infinity)
                }.accessibilityIdentifier("license_notices")
            } else if failed { Text(L10n.text("license_error")) }
            else { ProgressView() }
        }.background(Color.limestone).foregroundStyle(Color.ink)
            .navigationTitle(title).navigationBarTitleDisplayMode(.inline)
            .task {
                guard notices == nil, loaded == nil else { return }
                do { loaded = try LicenseNotice.load() } catch { failed = true }
            }
    }
}

struct LicenseView: View {
    var body: some View {
        LicenseDocument(text: contents).navigationTitle("GNU AGPL v3").navigationBarTitleDisplayMode(.inline)
    }
    private var contents: String {
        guard let url = Bundle.main.url(forResource: "AGPL-3.0", withExtension: "txt"),
              let content = try? String(contentsOf: url, encoding: .utf8) else { return L10n.text("license_error") }
        return content
    }
}
