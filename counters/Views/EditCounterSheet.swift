import SwiftUI
import SwiftData

struct EditCounterSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ScaledMetric(relativeTo: .largeTitle) private var wheelHeight = 280

    let counter: Counter
    private let valueRange: ClosedRange<Int>
    @State private var name: String
    @State private var value: Int

    init(counter: Counter) {
        self.counter = counter
        self.valueRange = 0...max(9_999, counter.value + 1_000)
        _name = State(initialValue: counter.name)
        _value = State(initialValue: counter.value)
    }

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    NumberWheel(value: $value, range: valueRange)
                        .frame(maxWidth: .infinity)
                        .frame(height: wheelHeight)
                }
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets())

                Section {
                    LabeledContent("Name") {
                        TextField("Name", text: $name)
                            .multilineTextAlignment(.trailing)
                            .submitLabel(.done)
                    }
                }
            }
            .navigationTitle("Edit Counter")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", action: save)
                        .disabled(trimmedName.isEmpty)
                }
            }
        }
    }

    private func save() {
        counter.name = trimmedName
        counter.value = value
        dismiss()
    }
}

#Preview {
    EditCounterSheet(counter: Counter(name: "Water", value: 6))
        .modelContainer(for: Counter.self, inMemory: true)
}
