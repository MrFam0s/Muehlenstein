// SPDX-License-Identifier: AGPL-3.0-or-later
import Foundation

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
