// SPDX-License-Identifier: AGPL-3.0-or-later
import Foundation
import Observation

/// Owns the network transcript. GameStore displays and persists its validated projection.
/// White hosts; Black proposes moves. Only host snapshots change either board.
@MainActor @Observable final class LocalMatchSession {
    enum Phase { case idle, hosting, browsing, connecting, awaitingApproval, synchronizing, connected, paused }
    private(set) var phase: Phase = .idle
    private(set) var games: [NearbyGame] = []
    private(set) var game: SavedGame?
    private(set) var position: Position?
    private(set) var failure: LocalMatchFailure?
    private(set) var hasStarted = false
    var onUpdate: ((SavedGame, Position) -> Void)?

    private let transport: any MatchTransport
    private var selectedRoom: UUID?
    private var authenticated = false
    private var timeoutTask: Task<Void, Never>?
    private var role: Int?

    var identity: LocalMatchIdentity? { game?.network }
    var isConnected: Bool { phase == .connected || phase == .synchronizing }
    var canPlay: Bool { phase == .connected && position?.side == identity?.side && position?.isOver == false }
    var isHost: Bool { role == 0 }

    init(transport: (any MatchTransport)? = nil) {
        self.transport = transport ?? NearbyMatchTransport()
        self.transport.onGames = { [weak self] games in
            guard let self else { return }
            self.games = games
            // Reopening a saved game reconnects only to its original room.
            if let identity = self.identity, identity.side == 1, self.phase == .browsing,
               let original = games.first(where: { $0.matchID == identity.id }) {
                self.join(original)
            }
        }
        self.transport.onConnected = { [weak self] in self?.connected() }
        self.transport.onDisconnected = { [weak self] in
            guard let self, self.phase != .paused, self.phase != .idle else { return }
            self.pause()
        }
        self.transport.onFailure = { [weak self] in self?.fail(.unavailable) }
        self.transport.onData = { [weak self] in self?.receive($0) }
    }

    convenience init(restoring game: SavedGame, transport: (any MatchTransport)? = nil) throws {
        self.init(transport: transport)
        guard game.settings.opponent == .network, let identity = game.network,
              (0...1).contains(identity.side), game.moves.count <= LocalMatchPacket.maximumMoves else {
            throw LocalMatchFailure.invalidGame
        }
        self.position = try Engine.query(game)
        self.game = game
        self.role = identity.side
        self.hasStarted = true
        self.phase = .paused
    }

    func host(variant: Variant) {
        stop()
        do {
            let identity = LocalMatchIdentity(id: UUID(), side: 0, resumeKey: UUID())
            let game = SavedGame(settings: GameSettings(variant: variant, opponent: .network), network: identity)
            self.position = try Engine.query(game)
            self.game = game
            self.role = 0
            reconnect()
        } catch { fail(.invalidGame) }
    }
    func browse() {
        stop()
        game = nil
        position = nil
        role = 1
        reconnect()
    }
    func join(_ room: NearbyGame) {
        guard phase == .browsing, identity == nil || identity?.id == room.matchID else { return }
        selectedRoom = room.matchID
        failure = nil
        phase = .connecting
        armTimeout()
        transport.connect(to: room)
    }
    func reconnect() {
        guard !isConnected, phase != .connecting, phase != .awaitingApproval, role != nil else { return }
        timeoutTask?.cancel()
        failure = nil
        authenticated = false
        games = []
        if isHost, let game, let identity {
            phase = .hosting
            transport.host(id: identity.id, variant: game.settings.variant)
        } else {
            phase = .browsing
            transport.browse()
        }
    }
    func pause() {
        timeoutTask?.cancel()
        timeoutTask = nil
        if isConnected { try? transport.send(LocalMatchPacket(event: .pause).encoded()) }
        transport.stop()
        authenticated = false
        if phase != .idle { phase = .paused }
    }
    func stop() {
        pause()
        phase = .idle
        games = []
        failure = nil
        hasStarted = false
        authenticated = false
    }

    func acceptInvitation() {
        guard isHost, phase == .awaitingApproval else { return }
        authenticated = true
        do {
            try sendState()
            // Approval starts and saves the host match even if the first acknowledgement is lost.
            hasStarted = true
        } catch { fail(.unavailable) }
    }
    func declineInvitation() {
        guard isHost, phase == .awaitingApproval else { return }
        try? send(.rejected(.declined))
        phase = .paused
        timeoutTask?.cancel()
        timeoutTask = Task { [weak self] in
            do { try await Task.sleep(for: .milliseconds(350)) } catch { return }
            self?.reconnect()
        }
    }

    func play(_ action: EngineAction) {
        guard canPlay, let game, let position, position.legal.contains(action), let snapshot = snapshot else { return }
        do {
            if isHost { try commit(action) }
            else {
                phase = .synchronizing
                armTimeout()
                try send(.move(revision: game.moves.count, digest: snapshot.digest, action: action))
            }
        } catch { fail(.unavailable) }
    }

    private var snapshot: LocalMatchSnapshot? {
        guard let game, let position, let identity else { return nil }
        return LocalMatchSnapshot(id: identity.id, resumeKey: identity.resumeKey, variant: game.settings.variant,
                                  moves: game.moves, fen: position.fen)
    }
    private func connected() {
        phase = .synchronizing
        armTimeout()
        if !isHost {
            phase = .awaitingApproval
            armTimeout(seconds: 60)
            do { try send(.join(resumeKey: identity?.resumeKey)) }
            catch { fail(.unavailable) }
        }
    }
    private func receive(_ data: Data) {
        guard phase != .idle, phase != .paused else { return }
        do {
            let event = try LocalMatchPacket.decode(data).event
            switch event {
            case let .join(resumeKey):
                guard isHost, !authenticated, phase == .synchronizing, let identity else { throw LocalMatchFailure.invalidGame }
                if resumeKey == identity.resumeKey {
                    authenticated = true
                    try sendState()
                } else if !hasStarted && resumeKey == nil {
                    phase = .awaitingApproval
                    armTimeout(seconds: 60)
                } else { throw LocalMatchFailure.invalidGame }
            case let .state(snapshot):
                guard !isHost, selectedRoom == snapshot.id else { throw LocalMatchFailure.invalidGame }
                let (game, position) = try snapshot.validatedGame(previous: self.game)
                self.game = game
                self.position = position
                // Persist before acknowledging receipt; the host remains the recovery authority.
                onUpdate?(game, position)
                try send(.acknowledged(revision: game.moves.count, digest: snapshot.digest))
                ready()
            case let .acknowledged(revision, digest):
                guard isHost, authenticated, let snapshot else { throw LocalMatchFailure.invalidGame }
                // A delayed acknowledgement cannot unlock a newer in-flight move.
                if revision < snapshot.moves.count { return }
                guard revision == snapshot.moves.count, digest == snapshot.digest else { throw LocalMatchFailure.invalidGame }
                ready()
            case let .move(revision, digest, action):
                guard isHost, authenticated, let game, let position, let snapshot else { throw LocalMatchFailure.invalidGame }
                // Resend the authoritative transcript for a repeated/stale proposal; never replay its move.
                if revision < game.moves.count { try sendState(); return }
                guard phase == .connected, revision == game.moves.count, digest == snapshot.digest,
                      position.side == 1, !position.isOver, position.legal.contains(action) else {
                    throw LocalMatchFailure.invalidGame
                }
                try commit(action)
            case let .rejected(reason): fail(reason)
            case .pause: pause()
            }
        } catch let reason as LocalMatchFailure {
            // Give the reliable rejection a short opportunity to leave before closing the session.
            try? send(.rejected(reason))
            failure = reason
            phase = .paused
            timeoutTask?.cancel()
            timeoutTask = Task { [weak self] in
                do { try await Task.sleep(for: .milliseconds(350)) } catch { return }
                self?.transport.stop()
            }
        } catch { fail(.invalidGame) }
    }
    private func commit(_ action: EngineAction) throws {
        guard var game, let position else { throw LocalMatchFailure.invalidGame }
        guard game.moves.count < LocalMatchPacket.maximumMoves else { throw LocalMatchFailure.invalidGame }
        game.moves.append(MoveRecord(notation: action.notation, side: position.side))
        let updated = try Engine.query(game)
        self.game = game
        self.position = updated
        onUpdate?(game, updated)
        try sendState()
    }
    private func sendState() throws {
        guard let snapshot else { throw LocalMatchFailure.invalidGame }
        phase = .synchronizing
        armTimeout()
        try send(.state(snapshot))
    }
    private func send(_ event: LocalMatchPacket.Event) throws {
        try transport.send(LocalMatchPacket(event: event).encoded())
    }
    private func ready() {
        timeoutTask?.cancel()
        timeoutTask = nil
        phase = .connected
        hasStarted = true
    }
    private func armTimeout(seconds: Int = 20) {
        timeoutTask?.cancel()
        timeoutTask = Task { [weak self] in
            do { try await Task.sleep(for: .seconds(seconds)) } catch { return }
            self?.fail(.timeout)
        }
    }
    private func fail(_ reason: LocalMatchFailure) {
        pause()
        failure = reason
    }
}
