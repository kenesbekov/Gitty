import Testing
import Foundation
@testable import Gitty

private enum Constants {
    static let historyKey = "ViewedUsers"
}

@Suite(.tags(.history))
struct UserHistoryTests {
    let provider: UserHistoryProvider
    let cleaner: UserHistoryCleaner

    let user = User(id: 1, login: "testuser", avatarURL: URL(string: "https://example.com/avatar.png")!)

    init() {
        let manager = UserHistoryManager()
        provider = manager
        cleaner = manager
    }

    @Test("Add user")
    func addUser() {
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
