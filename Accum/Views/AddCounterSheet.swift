import SwiftUI
import SwiftData

struct AddCounterSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var name = ""
    @FocusState private var isNameFocused: Bool

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        NavigationStack {
            Form {
                TextField("名稱", text: $name)
                    .focused($isNameFocused)
                    .submitLabel(.done)
                    .onSubmit(add)
            }
            .navigationTitle("新增計數器")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("新增", action: add)
                        .disabled(trimmedName.isEmpty)
                }
            }
            .onAppear {
                isNameFocused = true
            }
        }
    }

    private func add() {
        guard !trimmedName.isEmpty else { return }
        modelContext.insert(Counter(name: trimmedName))
        dismiss()
    }
}

#Preview {
    AddCounterSheet()
        .modelContainer(for: Counter.self, inMemory: true)
}
