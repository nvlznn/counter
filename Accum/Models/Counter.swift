import Foundation
import SwiftData

@Model
final class Counter {
    var name: String
    var value: Int
    var createdAt: Date

    init(name: String, value: Int = 0) {
        self.name = name
        self.value = value
        self.createdAt = .now
    }
}
