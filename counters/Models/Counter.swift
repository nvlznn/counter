import Foundation
import SwiftData

@Model
final class Counter {
    // CloudKit sync requires every stored property to have a default value,
    // and every relationship to be optional with an inverse.
    var name: String = ""
    var value: Int = 0
    var createdAt: Date = Date.now
    @Relationship(deleteRule: .cascade, inverse: \CounterEntry.counter)
    var entries: [CounterEntry]? = []

    /// Taps on + this close to the previous tap join the same history entry.
    static let quickTapMergeWindow: TimeInterval = 5 * 60

    init(name: String, value: Int = 0) {
        self.name = name
        self.value = value
        self.createdAt = .now
    }

    /// Adds one from the list's + button, merging into the latest entry when
    /// it is also a quick tap made within `quickTapMergeWindow`.
    func increment(at now: Date = .now) {
        value += 1
        if let latest = entries?.max(by: { $0.date < $1.date }),
           latest.isQuickTap,
           now.timeIntervalSince(latest.date) < Self.quickTapMergeWindow {
            latest.delta += 1
            latest.date = now
        } else {
            addEntry(CounterEntry(date: now, delta: 1, isQuickTap: true))
        }
    }

    /// Sets the value from the edit sheet, always recording a separate entry.
    func setValue(_ newValue: Int, at now: Date = .now) {
        let delta = newValue - value
        guard delta != 0 else { return }
        value = newValue
        addEntry(CounterEntry(date: now, delta: delta, isQuickTap: false))
    }

    private func addEntry(_ entry: CounterEntry) {
        if entries == nil {
            entries = []
        }
        entries?.append(entry)
    }
}
