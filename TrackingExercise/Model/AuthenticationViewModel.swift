import SwiftUI
import SwiftData
import Combine

final class AuthenticationViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var rememberMe: Bool = false
    @Published var errorMessage: String?

    // Reference to the SwiftData ModelContext.
    var modelContext: ModelContext?

    // Registration function: registers a new user if one with the same username doesn't exist.
    func register() {
        guard let context = modelContext else {
            errorMessage = "ModelContext is not available."
            return
        }
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both username and password."
            return
        }
        
        do {
            // Fetch all users.
            let descriptor: FetchDescriptor<User> = FetchDescriptor()
            let allUsers = try context.fetch(descriptor)
            // Filter in memory.
            let existingUsers = allUsers.filter { $0.username == username }
            if !existingUsers.isEmpty {
                errorMessage = "Username already exists. Choose a different one."
                return
            }
            let newUser = User(username: username, password: password, rememberMe: rememberMe)
            context.insert(newUser)
            currentUser = newUser
            errorMessage = nil
        } catch {
            errorMessage = "Registration failed: \(error.localizedDescription)"
        }
    }

    // Login function: finds a user with matching username and password.
    func login() {
        guard let context = modelContext else {
            errorMessage = "ModelContext is not available."
            return
        }
        guard !username.isEmpty, !password.isEmpty else {
            errorMessage = "Please enter both username and password."
            return
        }
        
        do {
            let descriptor: FetchDescriptor<User> = FetchDescriptor()
            let allUsers = try context.fetch(descriptor)
            if let user = allUsers.first(where: { $0.username == username && $0.password == password }) {
                currentUser = user
                user.rememberMe = rememberMe
                errorMessage = nil
            } else {
                errorMessage = "Invalid username or password."
            }
        } catch {
            errorMessage = "Login failed: \(error.localizedDescription)"
        }
    }

    // Logout function.
    func logout() {
        currentUser = nil
        username = ""
        password = ""
        rememberMe = false
    }
}
