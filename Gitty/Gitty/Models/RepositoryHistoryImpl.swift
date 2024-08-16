import Foundation

final class RepositoryHistoryImpl: RepositoryHistory {
    private let maxHistoryCount = 20
    private let historyKey = "ViewedRepositories"
    
    func addRepository(_ repository: GitHubRepository) {
        var history = loadHistory()
        history.insert(repository, at: 0)
        if history.count > maxHistoryCount {
            history.removeLast()
        }
        saveHistory(history)
    }
    
    func loadHistory() -> [GitHubRepository] {
        if let data = UserDefaults.standard.data(forKey: historyKey),
           let history = try? JSONDecoder().decode([GitHubRepository].self, from: data) {
            return history
        }
        return []
    }
    
    private func saveHistory(_ history: [GitHubRepository]) {
        if let data = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(data, forKey: historyKey)
        }
    }
}
