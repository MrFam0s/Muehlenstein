// SPDX-License-Identifier: AGPL-3.0-or-later
import SwiftUI
import UIKit

struct PageControls: View {
    @Binding var page: Int
    let count: Int
    var body: some View {
        HStack {
            Button { page -= 1 } label: { Image(systemName: "chevron.left").font(.system(size: 20)).frame(width: 52, height: 44) }
                .disabled(page == 0).accessibilityLabel(L10n.text("previous_page")).accessibilityIdentifier("previous_page")
            Spacer(minLength: 0)
            Text(L10n.format("page_count", page + 1, max(1, count))).font(.caption).monospacedDigit()
                .accessibilityIdentifier("page_count")
            Spacer(minLength: 0)
            Button { page += 1 } label: { Image(systemName: "chevron.right").font(.system(size: 20)).frame(width: 52, height: 44) }
                .disabled(page + 1 >= count).accessibilityLabel(L10n.text("next_page")).accessibilityIdentifier("next_page")
        }.foregroundStyle(Color.petrol)
    }
}

/// TextKit uses the exact same font, insets and line wrapping to paginate and render.
/// Every UTF-16 character is retained, including the complete bundled license.
@MainActor enum TextPagination {
    static func pages(_ text: String, size: CGSize, font: UIFont) -> [String] {
        guard !text.isEmpty, size.width > 0, size.height >= font.lineHeight else { return [text] }
        let storage = NSTextStorage(string: text, attributes: [.font: font])
        let layout = NSLayoutManager()
        storage.addLayoutManager(layout)
        let source = text as NSString
        var pages: [String] = []
        var consumed = 0
        while consumed < source.length {
            let container = NSTextContainer(size: size)
            container.lineFragmentPadding = 0
            layout.addTextContainer(container)
            let glyphs = layout.glyphRange(for: container)
            let range = layout.characterRange(forGlyphRange: glyphs, actualGlyphRange: nil)
            guard range.length > 0 else { break }
            pages.append(source.substring(with: range))
            consumed = NSMaxRange(range)
        }
        // Never silently drop text even if a future font cannot fit a line.
        if consumed < source.length { pages.append(source.substring(from: consumed)) }
        return pages.isEmpty ? [text] : pages
    }
}

private struct TextPage: UIViewRepresentable {
    let text: String
    let font: UIFont
    func makeUIView(context: Context) -> UITextView {
        let view = UITextView(usingTextLayoutManager: false)
        view.textContainer.lineFragmentPadding = 0
        view.isScrollEnabled = false
        view.isEditable = false
        view.textContainerInset = .zero
        view.backgroundColor = .clear
        view.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return view
    }
    func updateUIView(_ view: UITextView, context: Context) {
        view.font = font
        view.textColor = UIColor(named: "Ink")
        if view.text != text { view.text = text }
    }
}

struct PagedReadingView: View {
    let text: String
    @ScaledMetric(relativeTo: .body) private var fontSize: CGFloat = 17
    @State private var page = 0
    private struct Metrics: Equatable { let size: CGSize; let fontSize: CGFloat; let text: String }
    @State private var pages: [String] = []
    var body: some View {
        GeometryReader { geometry in
            let size = CGSize(width: max(1, geometry.size.width - 40), height: max(1, geometry.size.height - 100))
            let metrics = Metrics(size: size, fontSize: fontSize, text: text)
            VStack(spacing: 16) {
                TextPage(text: pages.isEmpty ? "" : pages[min(page, pages.count - 1)], font: .systemFont(ofSize: fontSize))
                    .frame(width: size.width, height: size.height)
                if pages.count > 1 { PageControls(page: $page, count: pages.count) }
            }.padding(20)
                .onChange(of: metrics, initial: true) { _, value in
                    pages = TextPagination.pages(value.text, size: value.size, font: .systemFont(ofSize: value.fontSize))
                    page = min(page, max(0, pages.count - 1))
                }
        }.background(Color.limestone)
    }
}

struct PagedRows<Item, Row: View>: View {
    let items: [Item]
    @ViewBuilder let row: (Int, Item) -> Row
    @ScaledMetric(relativeTo: .body) private var rowHeight: CGFloat = 52
    @State private var page = 0
    var body: some View {
        GeometryReader { geometry in
            let perPage = max(1, Int(max(1, geometry.size.height - 100) / rowHeight))
            let count = max(1, (items.count + perPage - 1) / perPage)
            let safePage = min(page, count - 1)
            VStack(spacing: 0) {
                ForEach((safePage * perPage)..<min(items.count, (safePage + 1) * perPage), id: \.self) { index in
                    row(index, items[index]).frame(height: rowHeight)
                }
                Spacer(minLength: 0)
                if count > 1 { PageControls(page: Binding(get: { safePage }, set: { page = $0 }), count: count) }
            }.padding(20).frame(maxWidth: .infinity, maxHeight: .infinity)
                .onChange(of: perPage) { _, _ in page = 0 }
        }.background(Color.limestone)
    }
}

struct ReadingSheet: View {
    @Environment(\.dismiss) private var dismiss
    let title: String
    let text: String
    var body: some View {
        NavigationStack {
            PagedReadingView(text: text).navigationTitle(title).navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .confirmationAction) { Button(L10n.text("done")) { dismiss() } } }
        }.presentationDetents([.large])
    }
}
