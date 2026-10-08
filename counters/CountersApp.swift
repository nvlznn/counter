import SwiftUI
import SwiftData

@main
struct CountersApp: App {
    init() {
        // Show the system clear (ⓧ) button in text fields while editing,
        // like the Label field in Clock. SwiftUI has no API for this.
        UITextField.appearance().clearButtonMode = .whileEditing
    }

    var body: some Scene {
        WindowGroup {
            CounterListView()
                .tint(.primary)
        }
        .modelContainer(for: [Counter.self, CounterEntry.self])
    }
}
