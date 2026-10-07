// SPDX-License-Identifier: AGPL-3.0-or-later
import Foundation
@preconcurrency import MultipeerConnectivity

struct NearbyGame: Identifiable, Equatable, Sendable {
    let id: String
    let matchID: UUID
    let variant: Variant
    var room: String { String(matchID.uuidString.prefix(6)) }
}

@MainActor protocol MatchTransport: AnyObject {
    var onGames: (([NearbyGame]) -> Void)? { get set }
    var onConnected: (() -> Void)? { get set }
    var onDisconnected: (() -> Void)? { get set }
    var onData: ((Data) -> Void)? { get set }
    var onFailure: (() -> Void)? { get set }
    func host(id: UUID, variant: Variant)
    func browse()
    func connect(to game: NearbyGame)
    func send(_ data: Data) throws
    func stop()
}

/// Encrypted, reliable, two-peer transport. All mutable state belongs to the main actor.
/// Delegate callbacks from retired sessions are ignored, including late disconnects.
@MainActor final class NearbyMatchTransport: NSObject, MatchTransport {
    static let service = "muehlenstein"
    var onGames: (([NearbyGame]) -> Void)?
    var onConnected: (() -> Void)?
    var onDisconnected: (() -> Void)?
    var onData: ((Data) -> Void)?
    var onFailure: (() -> Void)?
    private let peer = MCPeerID(displayName: "Muehlenstein-" + String(UUID().uuidString.prefix(8)))
    private var session: MCSession?
    private var advertiser: MCNearbyServiceAdvertiser?
    private var browser: MCNearbyServiceBrowser?
    private var selectedPeer: MCPeerID?
    private var found: [String: (NearbyGame, MCPeerID)] = [:]

    func host(id: UUID, variant: Variant) {
        reset()
        let advertiser = MCNearbyServiceAdvertiser(peer: peer, discoveryInfo: [
            "match": id.uuidString, "variant": String(variant.rawValue), "protocol": String(LocalMatchPacket.currentVersion)
        ], serviceType: Self.service)
        self.advertiser = advertiser
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
    }
    func browse() {
        reset()
        let browser = MCNearbyServiceBrowser(peer: peer, serviceType: Self.service)
        self.browser = browser
        browser.delegate = self
        browser.startBrowsingForPeers()
    }
    func connect(to game: NearbyGame) {
        guard selectedPeer == nil, let target = found[game.id]?.1, let browser, let session else {
            onFailure?(); return
        }
        selectedPeer = target
        browser.invitePeer(target, to: session, withContext: nil, timeout: 15)
    }
    func send(_ data: Data) throws {
        guard data.count <= LocalMatchPacket.maximumBytes, let session, let selectedPeer,
              session.connectedPeers == [selectedPeer] else { throw LocalMatchFailure.unavailable }
        try session.send(data, toPeers: [selectedPeer], with: .reliable)
    }
    func stop() {
        advertiser?.delegate = nil
        advertiser?.stopAdvertisingPeer()
        advertiser = nil
        browser?.delegate = nil
        browser?.stopBrowsingForPeers()
        browser = nil
        session?.delegate = nil
        session?.disconnect()
        session = nil
        selectedPeer = nil
        found = [:]
    }
    private func reset() {
        stop()
        session = MCSession(peer: peer, securityIdentity: nil, encryptionPreference: .required)
        session?.delegate = self
    }
}

extension NearbyMatchTransport: MCNearbyServiceBrowserDelegate {
    nonisolated func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String: String]?) {
        Task { @MainActor in
            guard browser === self.browser, peerID != self.peer,
                  let rawID = info?["match"], let id = UUID(uuidString: rawID),
                  let rawVariant = info?["variant"], let number = Int(rawVariant), let variant = Variant(rawValue: number),
                  info?["protocol"] == String(LocalMatchPacket.currentVersion) else { return }
            let key = peerID.displayName
            self.found[key] = (NearbyGame(id: key, matchID: id, variant: variant), peerID)
            self.onGames?(self.found.values.map(\.0).sorted { $0.room < $1.room })
        }
    }
    nonisolated func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        Task { @MainActor in
            guard browser === self.browser else { return }
            self.found.removeValue(forKey: peerID.displayName)
            self.onGames?(self.found.values.map(\.0).sorted { $0.room < $1.room })
        }
    }
    nonisolated func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
        Task { @MainActor in if browser === self.browser { self.onFailure?() } }
    }
}

extension NearbyMatchTransport: MCNearbyServiceAdvertiserDelegate {
    nonisolated func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID,
                               withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        let reply = InvitationReply(handler: invitationHandler)
        Task { @MainActor in
            guard advertiser === self.advertiser, self.selectedPeer == nil, let session = self.session else {
                reply.handler(false, nil); return
            }
            self.selectedPeer = peerID
            reply.handler(true, session)
        }
    }
    nonisolated func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        Task { @MainActor in if advertiser === self.advertiser { self.onFailure?() } }
    }
}
private struct InvitationReply: @unchecked Sendable { let handler: (Bool, MCSession?) -> Void }

extension NearbyMatchTransport: MCSessionDelegate {
    nonisolated func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        Task { @MainActor in
            guard session === self.session, peerID == self.selectedPeer else { return }
            switch state {
            case .connected:
                self.advertiser?.stopAdvertisingPeer()
                self.browser?.stopBrowsingForPeers()
                self.onConnected?()
            case .notConnected: self.onDisconnected?()
            case .connecting: break
            @unknown default: self.onFailure?()
            }
        }
    }
    nonisolated func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        Task { @MainActor in
            guard session === self.session, peerID == self.selectedPeer else { return }
            guard data.count <= LocalMatchPacket.maximumBytes else { self.onFailure?(); return }
            self.onData?(data)
        }
    }
    nonisolated func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) { stream.close() }
    nonisolated func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) { progress.cancel() }
    nonisolated func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {}
}
