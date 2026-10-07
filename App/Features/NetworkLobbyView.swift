// SPDX-License-Identifier: AGPL-3.0-or-later
import SwiftUI

/// The same compact connection panel is used during setup and to reconnect a saved match.
struct NetworkLobbyView: View {
    @Bindable var session: LocalMatchSession
    var variant: Variant = .classic
    @Environment(\.accentPalette) private var palette
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.openURL) private var openURL

    var body: some View {
        ViewThatFits(in: .vertical) {
            content.fixedSize(horizontal: false, vertical: true)
            ScrollView { content }
        }
        .foregroundStyle(Color.ink)
        .onChange(of: scenePhase) { _, phase in
            if phase == .background { session.pause() }
            else if phase == .active && session.phase == .paused { session.reconnect() }
        }
    }

    private var content: some View {
        VStack(spacing: 18) {
            if let failure = session.failure {
                Text(failure.message).font(.subheadline).multilineTextAlignment(.center)
                    .accessibilityIdentifier("network_error")
            }
            switch session.phase {
            case .idle:
                Image(systemName: "ipad.and.iphone").font(.system(size: 36)).foregroundStyle(palette.color).accessibilityHidden(true)
                Text(L10n.text("network_intro")).font(.subheadline).multilineTextAlignment(.center)
                Button { session.host(variant: variant) } label: {
                    Label(L10n.text("network_host"), systemImage: "plus")
                }.buttonStyle(PrimaryButton()).accessibilityIdentifier("network_host")
                Button { session.browse() } label: {
                    Label(L10n.text("network_join"), systemImage: "magnifyingglass")
                        .frame(maxWidth: .infinity, minHeight: 48)
                }.accessibilityIdentifier("network_browse")
            case .hosting:
                if let identity = session.identity {
                    Text(L10n.format("network_room", identity.room)).font(.headline)
                    Text(L10n.text(session.hasStarted ? "network_resume_help" : "network_invite_help"))
                        .font(.subheadline).multilineTextAlignment(.center)
                    waiting("network_waiting")
                }
            case .browsing:
                if session.hasStarted {
                    Text(L10n.text("network_resume_help")).font(.subheadline).multilineTextAlignment(.center)
                    waiting("network_searching")
                } else {
                    Text(L10n.text("network_choose_room")).font(.headline)
                    if session.games.isEmpty { waiting("network_searching") }
                    else {
                        // A network can contain more rooms than fit in a sheet. Only this list scrolls.
                        ScrollView {
                            VStack(spacing: 8) {
                                ForEach(session.games) { room in
                                    Button { session.join(room) } label: {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 3) {
                                                Text(L10n.format("network_room", room.room)).font(.headline)
                                                Text(L10n.text(room.variant.key)).font(.caption)
                                            }
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                        }.padding(12).frame(minHeight: 56)
                                            .background(Color.boardSurface, in: RoundedRectangle(cornerRadius: 12))
                                    }.buttonStyle(.plain).accessibilityIdentifier("network_room_" + room.room)
                                }
                            }
                        }.frame(maxHeight: 180)
                    }
                }
            case .awaitingApproval:
                Text(L10n.text(session.isHost ? "network_invitation" : "network_wait_approval"))
                    .font(.headline).multilineTextAlignment(.center)
                if session.isHost {
                    Button(L10n.text("network_accept")) { session.acceptInvitation() }
                        .buttonStyle(PrimaryButton()).accessibilityIdentifier("network_accept")
                    Button(L10n.text("network_decline")) { session.declineInvitation() }
                        .frame(minHeight: 44).accessibilityIdentifier("network_decline")
                } else { ProgressView() }
            case .connecting, .synchronizing:
                waiting("network_connecting")
            case .connected:
                Image(systemName: "checkmark.circle").font(.largeTitle).foregroundStyle(palette.color).accessibilityHidden(true)
                Text(L10n.text("network_connected")).font(.headline).accessibilityIdentifier("network_connected")
                Text(L10n.format("network_you_are", L10n.text(session.identity?.side == 0 ? "white" : "black")))
                Text(L10n.text("network_fair_play")).font(.subheadline).multilineTextAlignment(.center)
            case .paused:
                Text(L10n.text("network_paused")).font(.headline)
                Text(L10n.text(session.hasStarted ? "network_resume_help" : "network_intro")).font(.subheadline).multilineTextAlignment(.center)
                Button(L10n.text("network_reconnect")) {
                    session.reconnect()
                }.buttonStyle(PrimaryButton()).accessibilityIdentifier("network_reconnect")
            }
            if !session.isConnected {
                VStack(spacing: 4) {
                    Text(L10n.text("network_help")).font(.caption).multilineTextAlignment(.center).foregroundStyle(Color.quietInk)
                    Button(L10n.text("network_settings")) {
                        if let url = URL(string: UIApplication.openSettingsURLString) { openURL(url) }
                    }.font(.caption).frame(minHeight: 44)
                }
            }
        }.frame(maxWidth: .infinity)
    }
    private func waiting(_ key: String) -> some View {
        HStack(spacing: 10) { ProgressView(); Text(L10n.text(key)).font(.subheadline) }
            .frame(minHeight: 44).accessibilityIdentifier(key)
    }
}

struct NetworkConnectionView: View {
    let session: LocalMatchSession
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            NetworkLobbyView(session: session).padding(20).frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.limestone)
                .navigationTitle(L10n.text("network_connection")).navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .confirmationAction) { Button(L10n.text("done")) { dismiss() } } }
        }.presentationDetents([.medium, .large])
            .presentationSizing(SettingsSheetSizing(height: 540))
    }
}
