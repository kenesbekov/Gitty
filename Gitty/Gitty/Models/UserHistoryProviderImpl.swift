import Foundation

final class UserHistoryProviderImpl: UserHistoryProvider {
    var users: [User] = []

    private let maxHistoryCount = 20
    private let historyKey = "ViewedUsers"

    init() {
        loadHistory()
    }

    func add(_ user: User) {
        if let existingIndex = users.firstIndex(where: { $0.id == user.id }) {
            users.remove(at: existingIndex)
        }

        users.insert(user, at: 0)

        if users.count > maxHistoryCount {
            users.removeLast()
        }

        saveHistory()
    }

    func clear() {
        users.removeAll()
        saveHistory()
    }

    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: historyKey),
           let decodedUsers = try? JSONDecoder().decode([User].self, from: data) {
            users = decodedUsers
        }
    }

    private func saveHistory() {
        if let data = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(data, forKey: historyKey)
        }
    }
}
