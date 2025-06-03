import Foundation

class AuthViewModel: ObservableObject {
    @Published var currentUser: UserModel? = nil {
        didSet {
            persistLoggedInUser()
            if let user = currentUser {
                debugPrint("✅👤 [AuthViewModel] Logged in as: \(user.userName)")
            } else {
                debugPrint("🚪 [AuthViewModel] User logged out")
            }
        }
    }
    
    @Published var users: [UserModel] = [] {
        didSet {
            persistAllUsers()
            debugPrint("👤 [AuthViewModel] Users list updated. Count:", users.count)
        }
    }
    
    // keys for userdefaults
    private let usersKey = "registeredUsers"
    private let loggedInKey = "loggedInUsername"

    init() {
        self.users = loadAllUsers()
        debugPrint("📥 [AuthViewModel] Loaded users. Count:", users.count)
        if let savedUsername = UserDefaults.standard.string(forKey: loggedInKey),
           let matchedUser = users.first(where: { $0.userName == savedUsername }) {
            currentUser = matchedUser
            debugPrint("🔑 [AuthViewModel] Restored session for: \(savedUsername)")
        }
    }

    func register(user: UserModel) {
        // check if username is taken
        guard !users.contains(where: {$0.userName == user.userName}) else {
            debugPrint("⚠️ [AuthViewModel] Username already taken: \(user.userName)")
            return
        }
        users.append(user)
        currentUser = user
        debugPrint("✅👤 [AuthViewModel] Registered new user:", user.userName)
    }

    func login(userName: String, password: String) {
        if let match = users.first(where: { $0.userName == userName && $0.password == password }) {
            currentUser = match
            debugPrint("🔑✅ [AuthViewModel] Login successful for:", userName)
        } else {
            currentUser = nil
            debugPrint("⚠️ [AuthViewModel] Login failed for:", userName)
        }
    }

    func logout() {
        debugPrint("🚪 [AuthViewModel] Logging out user: \(currentUser?.userName ?? "none")")
        currentUser = nil
    }

    // reads users from userdefaults, returns [] if nothing
    private func loadAllUsers() -> [UserModel] {
        let defaults = UserDefaults.standard
        guard let data = defaults.data(forKey: usersKey) else {
            debugPrint("⚠️ [AuthViewModel] No users found in UserDefaults")
            return []
        }
        do {
            let decoded = try JSONDecoder().decode([UserModel].self, from: data)
            return decoded
        } catch {
            debugPrint("⚠️ [AuthViewModel] Failed to decode users array:", error)
            return []
        }
    }

    // saves users to userdefaults
    private func persistAllUsers() {
        let defaults = UserDefaults.standard
        do {
            let encoded = try JSONEncoder().encode(self.users)
            defaults.set(encoded, forKey: usersKey)
            debugPrint("💾 [AuthViewModel] Persisted all users")
        } catch {
            debugPrint("⚠️ [AuthViewModel] Failed to encode users array:", error)
        }
    }

    // saves or clears current user in userdefaults
    private func persistLoggedInUser() {
        let defaults = UserDefaults.standard
        if let user = currentUser {
            defaults.set(user.userName, forKey: loggedInKey)
            debugPrint("💾 [AuthViewModel] Persisted logged in user: \(user.userName)")
        } else {
            defaults.removeObject(forKey: loggedInKey)
            debugPrint("💾 [AuthViewModel] Cleared logged in user from UserDefaults")
        }
    }
}
