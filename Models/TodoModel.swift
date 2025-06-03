import Foundation

struct TodoModel: Identifiable, Codable, Equatable {
    var id: UUID
    var title: String
    var isCompleted: Bool
}
