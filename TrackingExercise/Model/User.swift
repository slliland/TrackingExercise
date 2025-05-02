import Foundation
import SwiftData

@Model
final class User: Identifiable {
    var id = UUID()
    var username: String
    var password: String   // For demo purposes only—do not store plain text passwords in production!
    var rememberMe: Bool

    init(username: String, password: String, rememberMe: Bool = false) {
        self.username = username
        self.password = password
        self.rememberMe = rememberMe
    }
}
