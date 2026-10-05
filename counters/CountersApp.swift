import SwiftUI
import SwiftData

@main
struct CountersApp: App {
    var body: some Scene {
        WindowGroup {
            CounterListView()
        }
        .modelContainer(for: Counter.self)
    }
}
