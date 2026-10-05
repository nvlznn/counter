import SwiftUI
import SwiftData

struct CounterListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Counter.createdAt) private var counters: [Counter]
    @State private var isAddingCounter = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(counters) { counter in
                    CounterRowView(counter: counter)
                        .swipeActions {
                            Button(role: .destructive) {
                                modelContext.delete(counter)
                            } label: {
                                Label("刪除", systemImage: "trash")
                            }
                        }
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Accum")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("新增計數器", systemImage: "plus") {
                        isAddingCounter = true
                    }
                }
            }
            .overlay {
                if counters.isEmpty {
                    ContentUnavailableView {
                        Label("還沒有計數器", systemImage: "number")
                    } description: {
                        Text("點一下 \(Image(systemName: "plus")) 新增計數器。")
                    }
                }
            }
            .sheet(isPresented: $isAddingCounter) {
                AddCounterSheet()
            }
        }
    }
}

#Preview("空狀態") {
    CounterListView()
        .modelContainer(for: Counter.self, inMemory: true)
}

#Preview("有資料") {
    let container = try! ModelContainer(
        for: Counter.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    for (name, value) in [("喝水", 6), ("伏地挺身", 120), ("讀完的書", 3)] {
        container.mainContext.insert(Counter(name: name, value: value))
    }
    return CounterListView()
        .modelContainer(container)
}
