import Foundation

final class RepositoryHistoryProviderImpl: RepositoryHistoryProvider {
    var repositories: [Repository] {
        cachedRepositories.value
    }

    private let cachedRepositories = Atomic<[Repository]>(with: [])
    private let maxHistoryCount = 20
    private let historyKey = "ViewedRepositories"

    init() {
        loadHistory()
    }

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

    func clear() {
        let emptyRepositories: [Repository] = []
        cachedRepositories.update(with: emptyRepositories)
        saveHistory(emptyRepositories)
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
