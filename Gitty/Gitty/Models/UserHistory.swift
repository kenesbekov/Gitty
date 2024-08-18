import Foundation

protocol UserHistory: AnyObject {
    var viewedUsers: [GitHubUser] { get }

    func addUser(_ user: GitHubUser)
}


final class UserHistoryImpl: UserHistory {
    var viewedUsers: [GitHubUser] = []

    private let maxHistoryCount = 20
    private let historyKey = "ViewedUsers"

    init() {
        loadHistory()
    }

    func addUser(_ user: GitHubUser) {
        if let existingIndex = viewedUsers.firstIndex(where: { $0.id == user.id }) {
            viewedUsers.remove(at: existingIndex)
        }

        viewedUsers.insert(user, at: 0)

        if viewedUsers.count > maxHistoryCount {
            viewedUsers.removeLast()
        }

        saveHistory()
    }

    private func loadHistory() {
        if let data = UserDefaults.standard.data(forKey: historyKey),
           let decodedUsers = try? JSONDecoder().decode([GitHubUser].self, from: data) {
            viewedUsers = decodedUsers
        }
    }

    private func saveHistory() {
        if let data = try? JSONEncoder().encode(viewedUsers) {
            UserDefaults.standard.set(data, forKey: historyKey)
        }
    }
}
