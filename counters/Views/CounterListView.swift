import SwiftUI
import SwiftData

struct CounterListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Counter.createdAt) private var counters: [Counter]
    @State private var isAddingCounter = false
    @State private var editingCounter: Counter?

    var body: some View {
        NavigationStack {
            List {
                ForEach(counters) { counter in
                    Button {
                        editingCounter = counter
                    } label: {
                        CounterRowView(counter: counter)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            modelContext.delete(counter)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                    }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Counters")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("New Counter", systemImage: "plus") {
                        isAddingCounter = true
                    }
                }
            }
            .overlay {
                if counters.isEmpty {
                    ContentUnavailableView {
                        Label("No Counters", systemImage: "number")
                    } description: {
                        Text("Tap \(Image(systemName: "plus")) to add a counter.")
                    }
                }
            }
            .sheet(isPresented: $isAddingCounter) {
                AddCounterSheet()
            }
            .sheet(item: $editingCounter) { counter in
                EditCounterSheet(counter: counter)
            }
        }
    }
}

#Preview("Empty") {
    CounterListView()
        .modelContainer(for: [Counter.self, CounterEntry.self], inMemory: true)
}

#Preview("With Data") {
    let container = try! ModelContainer(
        for: Counter.self, CounterEntry.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    for (name, value) in [("Water", 6), ("Push-ups", 120), ("Books Read", 3)] {
        container.mainContext.insert(Counter(name: name, value: value))
    }
    return CounterListView()
        .modelContainer(container)
}
