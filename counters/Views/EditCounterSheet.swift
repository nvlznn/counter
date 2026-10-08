import SwiftUI
import SwiftData

struct EditCounterSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ScaledMetric(relativeTo: .largeTitle) private var wheelHeight = 280
    private let keyboardGap: CGFloat = 24
    private let nameRowID = "name"

    let counter: Counter
    private let valueRange: ClosedRange<Int>
    @State private var name: String
    @State private var value: Int
    @FocusState private var isNameFocused: Bool

    init(counter: Counter) {
        self.counter = counter
        // A window around the current value keeps the wheel small enough for
        // accessibility; reopening the sheet re-centers it.
        self.valueRange = max(0, counter.value - 500)...(counter.value + 500)
        _name = State(initialValue: counter.name)
        _value = State(initialValue: counter.value)
    }

    private var trimmedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
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
                                .focused($isNameFocused)
                        }
                        .id(nameRowID)

                        LabeledContent("Created") {
                            Text(counter.createdAt, format: .dateTime.year().month().day().hour().minute())
                        }
                    }

                    Section {
                        NavigationLink("History") {
                            CounterHistoryView(counter: counter)
                        }
                    }
                }
                // Keep the name row clear of the keyboard instead of flush against it,
                // like Reminders.
                .safeAreaPadding(.bottom, isNameFocused ? keyboardGap : 0)
                // Scroll once the keyboard has finished appearing; before that the
                // form has no room to scroll, and the system leaves the row flush
                // against the keyboard.
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
                    guard isNameFocused else { return }
                    withAnimation {
                        proxy.scrollTo(nameRowID, anchor: .bottom)
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
        counter.setValue(value)
        dismiss()
    }
}

#Preview {
    EditCounterSheet(counter: Counter(name: "Water", value: 6))
        .modelContainer(for: [Counter.self, CounterEntry.self], inMemory: true)
}
