import SwiftUI
import SwiftData

struct CounterHistoryView: View {
    let counter: Counter

    private var entries: [CounterEntry] {
        (counter.entries ?? []).sorted { $0.date > $1.date }
    }

    var body: some View {
        List(entries) { entry in
            HStack {
                Text(entry.date, format: .dateTime.year().month().day().hour().minute())
                Spacer()
                Text(entry.delta, format: .number.sign(strategy: .always()))
                    .monospacedDigit()
                    .foregroundStyle(.secondary)
            }
        }
        .overlay {
            if entries.isEmpty {
                ContentUnavailableView(
                    "No History",
                    systemImage: "clock",
                    description: Text("Changes to this counter will appear here.")
                )
            }
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    let container = try! ModelContainer(
        for: Counter.self, CounterEntry.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let counter = Counter(name: "Water")
    container.mainContext.insert(counter)
    let start = Date.now.addingTimeInterval(-60 * 60)
    // Two taps a minute apart merge; a tap six minutes later starts a new entry.
    counter.increment(at: start)
    counter.increment(at: start.addingTimeInterval(60))
    counter.increment(at: start.addingTimeInterval(7 * 60))
    counter.setValue(2, at: start.addingTimeInterval(20 * 60))
    return NavigationStack {
        CounterHistoryView(counter: counter)
    }
    .modelContainer(container)
}
