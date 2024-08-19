import Foundation

final class UserHistoryProviderImpl: UserHistoryProvider {
    var users: [User] {
        cachedUsers.value
    }

    private let cachedUsers = Atomic<[User]>(with: [])
    private let maxHistoryCount = 20
    private let historyKey = "ViewedUsers"

    init() {
        loadHistory()
    }

    func add(_ user: User) {
        var users = cachedUsers.value

        if let existingIndex = users.firstIndex(where: { $0.id == user.id }) {
            users.remove(at: existingIndex)
        }

        users.insert(user, at: 0)

        if users.count > maxHistoryCount {
            users.removeLast()
        }

        cachedUsers.update(with: users)
        saveHistory(users)
    }

    func clear() {
        let emptyUsers: [User] = []
        cachedUsers.update(with: emptyUsers)
        saveHistory(emptyUsers)
    }

    private func loadHistory() {
        guard let data = UserDefaults.standard.data(forKey: historyKey) else {
            return
        }

        do {
            let decodedUsers = try JSONDecoder().decode([User].self, from: data)
            cachedUsers.update(with: decodedUsers)
        } catch {
            print("Failed to load history: \(error.localizedDescription)")
        }
    }

    private func saveHistory(_ users: [User]) {
        do {
            let data = try JSONEncoder().encode(users)
            UserDefaults.standard.set(data, forKey: historyKey)
        } catch {
            print("Failed to save history: \(error.localizedDescription)")
        }
    }
}
