// SPDX-License-Identifier: AGPL-3.0-or-later
import Foundation
import Observation

/// Quick computations never show a transient busy indicator. Waiting for the
/// presentation pace is separate from actual computation and does not show it.
@MainActor @Observable final class DelayedSearchProgress {
    private(set) var isVisible = false
    private var task: Task<Void, Never>?
    func start(after delay: Duration = .seconds(2)) {
        finish()
        task = Task { [weak self] in
            do { try await Task.sleep(for: delay) } catch { return }
            guard !Task.isCancelled else { return }
            self?.isVisible = true
        }
    }
    func finish() {
        task?.cancel()
        task = nil
        isVisible = false
    }
}

/// Presentation time overlaps computation; it never reduces the search budget.
struct ComputerPacing: Sendable {
    var fixedDelay: Duration?
    static let natural = ComputerPacing()
    func minimumTime(action: Int, phase: Int) -> Duration {
        if let fixedDelay { return fixedDelay }
        let milliseconds: Int
        if action == 2 { milliseconds = Int.random(in: 650...900) }
        else if phase == 2 { milliseconds = Int.random(in: 950...1250) }
        else { milliseconds = Int.random(in: 850...1150) }
        return .milliseconds(milliseconds)
    }
}
