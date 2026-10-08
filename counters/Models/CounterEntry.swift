import Foundation
import SwiftData

/// One change to a counter's value, shown in its history.
@Model
final class CounterEntry {
    // CloudKit sync requires every stored property to have a default value.
    var date: Date = Date.now
    var delta: Int = 0
    /// Entries from tapping + in the list can absorb later taps;
    /// entries from the edit sheet never do.
    var isQuickTap: Bool = false
    var counter: Counter?

    init(date: Date, delta: Int, isQuickTap: Bool) {
        self.date = date
        self.delta = delta
        self.isQuickTap = isQuickTap
    }
}
