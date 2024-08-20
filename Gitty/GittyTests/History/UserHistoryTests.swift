import Testing
import Foundation
@testable import Gitty

private enum Constants {
    static let historyKey = "ViewedUsers"
}

@Suite(.tags(.history))
struct UserHistoryTests {
    var provider: UserHistoryProvider!
    var cleaner: UserHistoryCleaner!

    let user = User(id: 1, login: "testuser", avatarURL: URL(string: "https://example.com/avatar.png")!)

    init() {
        let manager = UserHistoryManager()
        provider = manager
        cleaner = manager
    }

    func testAddUser() {
        provider.add(user)

        #expect(provider.users.count == 1)
        #expect(provider.users.first == user)
    }

    func testClearHistory() {
        provider.add(user)
        cleaner.clear()

        #expect(provider.users.isEmpty)
    }

    func testLoadHistory() {
        provider.add(user)

        #expect(provider.users.count == 1)
        #expect(provider.users.first == user)
    }

    func testSaveHistory() {
        provider.add(user)

        #expect(UserDefaults.standard.data(forKey: Constants.historyKey) != nil)
    }
}
