import Foundation

// MARK: - Constants

private enum Constants {
    static let maxHistoryCount = 20
    static let historyKey = "ViewedRepositories"
}

// MARK: - RepositoryHistoryManager

final class RepositoryHistoryManager {
    var repositories: [Repository] {
        cachedRepositories.value
    }

    private let cachedRepositories = Atomic<[Repository]>(with: [])

    init() {
        loadHistory()
    }

    private func loadHistory() {
        guard let data = UserDefaults.standard.data(forKey: Constants.historyKey) else {
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
            UserDefaults.standard.set(data, forKey: Constants.historyKey)
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

        if repositories.count > Constants.maxHistoryCount {
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
