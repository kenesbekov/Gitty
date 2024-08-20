import Foundation

// MARK: - Constants

private enum Constants {
    static let maxHistoryCount = 20
    static let historyKey = "ViewedUsers"
}

// MARK: - UserHistoryManager

final class UserHistoryManager {
    var users: [User] {
        cachedUsers.value
    }

    private let cachedUsers = Atomic<[User]>(with: [])

    init() {
        loadHistory()
    }

    private func loadHistory() {
        guard let data = UserDefaults.standard.data(forKey: Constants.historyKey) else {
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
            UserDefaults.standard.set(data, forKey: Constants.historyKey)
        } catch {
            print("Failed to save history: \(error.localizedDescription)")
        }
    }
}

// MARK: - UserHistoryManager.UserHistoryProvider

extension UserHistoryManager: UserHistoryProvider {
    func add(_ user: User) {
        var users = cachedUsers.value

        if let existingIndex = users.firstIndex(where: { $0.id == user.id }) {
            users.remove(at: existingIndex)
        }

        users.insert(user, at: 0)

        if users.count > Constants.maxHistoryCount {
            users.removeLast()
        }

        cachedUsers.update(with: users)
        saveHistory(users)
    }
}

// MARK: - UserHistoryManager.HistoryCleaner

extension UserHistoryManager: HistoryCleaner {
    func clear() {
        cachedUsers.update(with: [])
        saveHistory([])
    }
}
