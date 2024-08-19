import Foundation

// MARK: - RepositoryHistoryManager

final class RepositoryHistoryManager {
    var repositories: [Repository] {
        cachedRepositories.value
    }

    private let cachedRepositories = Atomic<[Repository]>(with: [])
    private let maxHistoryCount = 20
    private let historyKey = "ViewedRepositories"

    init() {
        loadHistory()
    }

    private func loadHistory() {
        guard let data = UserDefaults.standard.data(forKey: historyKey) else {
            return
        }

        do {
            let decodedRepositories = try JSONDecoder().decode([Repository].self, from: data)
            cachedRepositories.update(with: decodedRepositories)
        } catch {
            print("Load history error:", error.localizedDescription)
            print("Data content: \(String(data: data, encoding: .utf8) ?? "Invalid data")")
        }
    }

    private func saveHistory(_ repositories: [Repository]) {
        do {
            let data = try JSONEncoder().encode(repositories)
            UserDefaults.standard.set(data, forKey: historyKey)
        } catch {
            print("Save history error:", error.localizedDescription)
        }
    }
}

// MARK: - RepositoryHistoryManager.RepositoryHistoryProvider

extension RepositoryHistoryManager: RepositoryHistoryProvider {
    func add(_ repository: Repository) {
        var repositories = cachedRepositories.value

        if let existingIndex = repositories.firstIndex(where: { $0.id == repository.id }) {
            repositories.remove(at: existingIndex)
        }

        repositories.insert(repository, at: 0)

        if repositories.count > maxHistoryCount {
            repositories.removeLast()
        }

        cachedRepositories.update(with: repositories)
        saveHistory(repositories)
    }
}

// MARK: - RepositoryHistoryManager.RepositoryHistoryCleaner

extension RepositoryHistoryManager: RepositoryHistoryCleaner {
    func clear() {
        cachedRepositories.update(with: [])
        saveHistory([])
    }
}
