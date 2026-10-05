import Foundation
import SwiftData

@Model
final class Counter {
    // CloudKit sync requires every stored property to have a default value.
    var name: String = ""
    var value: Int = 0
    var createdAt: Date = Date.now

    init(name: String, value: Int = 0) {
        self.name = name
        self.value = value
        self.createdAt = .now
    }
}
