import Testing
import Foundation
@testable import Gitty

// MARK: - Constants

private enum Constants {
    static let historyKey = "ViewedUsers"
}

// MARK: - UserHistoryTests

@Suite(.tags(.history))
struct UserHistoryTests {
    private let provider: UserHistoryProvider
    private let cleaner: UserHistoryCleaner

    private let user = User(
        id: 1,
        login: "testuser",
        avatarURL: URL(string: "https://example.com/avatar.png")!,
        htmlURL: URL(string: "https://example.com/html")!
    )

    init() {
        let manager = UserHistoryManager()
        provider = manager
        cleaner = manager
    }

    @Test("Add user")
    func addUser() {
        cleaner.clear()
        provider.add(user)

        #expect(provider.users.count == 1)
        #expect(provider.users.first == user)
    }

    @Test("Clear history")
    func clearHistory() {
        provider.add(user)
        cleaner.clear()

        #expect(provider.users.isEmpty)
    }

    @Test("Load history")
    func loadHistory() {
        provider.add(user)

        #expect(provider.users.count == 1)
        #expect(provider.users.first == user)
    }

    @Test("Save history")
    func saveHistory() {
        provider.add(user)

        #expect(UserDefaults.standard.data(forKey: Constants.historyKey) != nil)
    }
}
