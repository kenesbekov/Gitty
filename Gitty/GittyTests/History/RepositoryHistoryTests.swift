import Testing
import Foundation
@testable import Gitty

private enum Constants {
    static let historyKey = "ViewedRepositories"
}

@Suite(.tags(.history))
struct RepositoryHistoryTests {
    let provider: RepositoryHistoryProvider
    let cleaner: RepositoryHistoryCleaner

    let repository = Repository(
        id: 1,
        name: "testrepo",
        description: "A test repository",
        forksCount: 50,
        htmlURL: URL(string: "https://example.com/repo.png")!,
        language: "Swift",
        openIssuesCount: 3,
        owner: User(
            id: 1,
            login: "testuser",
            avatarURL: URL(string: "https://example.com/avatar.png")!,
            htmlURL: URL(string: "https://example.com/html")!
        ),
        stargazersCount: 100,
        updatedAt: ISO8601DateFormatter().date(from: "2023-08-20T10:20:30Z")!,
        watchersCount: 14
    )

    init() {
        let manager = RepositoryHistoryManager()
        provider = manager
        cleaner = manager
    }

    @Test("Add repository")
    func add() {
        provider.add(repository)

        #expect(provider.repositories.count == 1)
        #expect(provider.repositories.first == repository)
    }

    @Test("Clear history")
    func clearHistory() {
        provider.add(repository)
        cleaner.clear()

        #expect(provider.repositories.isEmpty)
    }

    @Test("Load history")
    func loadHistory() {
        provider.add(repository)

        #expect(provider.repositories.count == 1)
        #expect(provider.repositories.first == repository)
    }

    @Test("Save history")
    func saveHistory() {
        provider.add(repository)

        #expect(UserDefaults.standard.data(forKey: Constants.historyKey) != nil)
    }
}
