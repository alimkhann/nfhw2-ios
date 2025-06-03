import Foundation

struct UserModel: Codable, Identifiable {
    var firstName: String
    var lastName: String
    var userName: String
    var password: String
    
    var id: String { userName }
}
