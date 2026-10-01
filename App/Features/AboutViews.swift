// SPDX-License-Identifier: AGPL-3.0-or-later
// Copyright (C) 2026 Fabian Amos / AmoSystems
import SwiftUI

struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var dynamicType
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if !dynamicType.isAccessibilitySize {
                    HStack(spacing: 14) {
                        BrandMark()
                        VStack(alignment: .leading, spacing: 6) {
                            Text(L10n.text("app_name")).font(.system(.title2, design: .serif))
                            Text(AppInformation.build.display).font(.subheadline).foregroundStyle(Color.quietInk)
                                .accessibilityIdentifier("about_version")
                            Text(AppInformation.company).font(.caption).foregroundStyle(Color.quietInk)
                        }
                        Spacer(minLength: 0)
                    }.padding(.horizontal, 20).padding(.top, 16)
                }
                PagedRows(items: ["imprint", "privacy", "credits", "license", "third_party"]) { _, section in
                    NavigationLink {
                        switch section {
                        case "imprint":
                            PagedReadingView(text: AppInformation.imprint).navigationTitle(L10n.text("imprint"))
                                .toolbar { ToolbarItemGroup(placement: .bottomBar) {
                                    externalLink("contact_email", icon: "envelope", url: AppInformation.emailURL)
                                    Spacer()
                                    externalLink("website", icon: "globe", url: AppInformation.website)
                                } }
                        case "privacy":
                            PagedReadingView(text: L10n.text("privacy_body")).navigationTitle(L10n.text("privacy"))
                        case "credits":
                            PagedReadingView(text: AppInformation.credits).navigationTitle(L10n.text("credits"))
                                .toolbar { ToolbarItemGroup(placement: .bottomBar) {
                                    externalLink("source_code", icon: "chevron.left.forwardslash.chevron.right", url: AppInformation.source)
                                    Spacer()
                                    externalLink("Sanmill", icon: "arrow.up.right.square", url: AppInformation.upstream)
                                } }
                        case "third_party": LicenseNoticesView()
                        default: LicenseView()
                        }
                    } label: {
                        HStack(spacing: 12) {
                            Label(L10n.text(section), systemImage: symbol(section))
                            Spacer(minLength: 4)
                            Image(systemName: "chevron.right").font(.caption).accessibilityHidden(true)
                        }.frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    }.accessibilityIdentifier(section)
                }
            }.background(Color.limestone).foregroundStyle(Color.ink)
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
    private func externalLink(_ key: String, icon: String, url: URL) -> some View {
        Link(destination: url) {
            Label(L10n.text(key), systemImage: icon)
                .labelStyle(.iconOnly).font(.system(size: 22)).frame(minWidth: 44, minHeight: 44)
        }.accessibilityLabel(L10n.text(key)).accessibilityIdentifier(key)
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
                PagedRows(items: entries) { _, notice in
                    NavigationLink {
                        if let children = notice.children {
                            LicenseNoticesView(notices: children, title: notice.title)
                        } else {
                            PagedReadingView(text: notice.text ?? "").navigationTitle(notice.title)
                        }
                    } label: {
                        Text(notice.title).lineLimit(2).frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    }.accessibilityIdentifier(notice.id)
                }
            } else if failed { Text(L10n.text("license_error")) }
            else { ProgressView() }
        }.navigationTitle(title).navigationBarTitleDisplayMode(.inline)
            .task {
                guard notices == nil, loaded == nil else { return }
                do { loaded = try LicenseNotice.load() } catch { failed = true }
            }
    }
}

struct LicenseView: View {
    var body: some View {
        PagedReadingView(text: contents).navigationTitle("GNU AGPL v3").navigationBarTitleDisplayMode(.inline)
    }
    private var contents: String {
        guard let url = Bundle.main.url(forResource: "AGPL-3.0", withExtension: "txt"),
              let content = try? String(contentsOf: url, encoding: .utf8) else { return L10n.text("license_error") }
        return content
    }
}
