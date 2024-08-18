import Foundation

final class RepositoryHistoryImpl: RepositoryHistory {
    var repositories: [GitHubRepository] = []

    private let maxHistoryCount = 20
    private let historyKey = "ViewedRepositories"

    init() {
        loadHistory()
    }

    func add(_ repository: GitHubRepository) {
        if let existingIndex = repositories.firstIndex(where: { $0.id == repository.id }) {
            repositories.remove(at: existingIndex)
        }

        repositories.insert(repository, at: 0)

        if repositories.count > maxHistoryCount {
            repositories.removeLast()
        }

        saveHistory()
    }

    func clear() {
        repositories.removeAll()
        saveHistory()
    }

    private func loadHistory() {
        guard let data = UserDefaults.standard.data(forKey: historyKey) else {
            return
        }

        do {
            let decodedRepositories = try JSONDecoder().decode([GitHubRepository].self, from: data)
            repositories = decodedRepositories
        } catch {
            print("Load history error:", error.localizedDescription)
            print("Data content: \(String(data: data, encoding: .utf8) ?? "Invalid data")")
        }
    }

    private func saveHistory() {
        do {
            let data = try JSONEncoder().encode(repositories)
            UserDefaults.standard.set(data, forKey: historyKey)
        } catch {
            print("Save history error:", error.localizedDescription)
        }
    }
}
