import SwiftUI
import SwiftData

@main
struct AccumApp: App {
    var body: some Scene {
        WindowGroup {
            CounterListView()
        }
        .modelContainer(for: Counter.self)
    }
}
