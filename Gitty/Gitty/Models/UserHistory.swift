import Foundation

protocol UserHistory: AnyObject {
    var users: [GitHubUser] { get }

    func add(_ user: GitHubUser)
    func clear()
}


final class UserHistoryImpl: UserHistory {
    var users: [GitHubUser] = []

    private let maxHistoryCount = 20
    private let historyKey = "ViewedUsers"

    init() {
        loadHistory()
    }

    func add(_ user: GitHubUser) {
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
           let decodedUsers = try? JSONDecoder().decode([GitHubUser].self, from: data) {
            users = decodedUsers
        }
    }

    private func saveHistory() {
        if let data = try? JSONEncoder().encode(users) {
            UserDefaults.standard.set(data, forKey: historyKey)
        }
    }
}
