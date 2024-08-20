import Testing
import SwiftUI
@testable import Gitty

@MainActor
@Suite(.tags(.viewModel))
struct RepositoriesViewModelTests {
    var viewModel: RepositoriesViewModel!
    var mockRepositoriesProvider: MockRepositoriesProvider!
    var mockHistoryProvider: MockRepositoryHistoryProvider!
    var mockAppStateManager: MockAppStateManager!

    let mockRepositories = [
        Repository(
            id: 1,
            name: "Repo1",
            description: nil,
            stargazersCount: 10,
            forksCount: 5,
            owner: User(id: 1, login: "user1", avatarURL: URL(string: "https://example.com/avatar.png")!),
            updatedAt: Date(),
            htmlURL: URL(string: "https://example.com")!
        )
    ]

    init() {
        mockRepositoriesProvider = MockRepositoriesProvider()
        mockHistoryProvider = MockRepositoryHistoryProvider()
        mockAppStateManager = MockAppStateManager()

        viewModel = RepositoriesViewModel(
            repositoriesProvider: mockRepositoriesProvider,
            historyProvider: mockHistoryProvider
        )
    }

    @Test
    func testInitialState() {
        #expect(viewModel.searchQuery.isEmpty)
        #expect(viewModel.repositories.isEmpty)
        #expect(viewModel.paginationState == .default)
    }

    @Test
    func testSearchUpdatesRepositories() async {
        mockRepositoriesProvider.mockRepositories = mockRepositories

        viewModel.searchQuery = "Test"
        await viewModel.search()

        #expect(viewModel.repositories.count == 1)
        #expect(viewModel.repositories.first?.name == "Repo1")
        #expect(viewModel.paginationState == .success)
    }

    @Test
    func testLoadMoreRepositories() async {
        mockRepositoriesProvider.mockRepositories = mockRepositories

        viewModel.searchQuery = "Test"
        await viewModel.search()
        await viewModel.loadMoreRepositories()

        #expect(viewModel.repositories.count == 2)
        #expect(viewModel.paginationState == .success)
    }

    @Test
    func testMarkRepositoryAsViewed() {
        let repository = Repository(id: 3, name: "Repo3", description: nil, stargazersCount: 30, forksCount: 15, owner: User(id: 3, login: "user3", avatarURL: URL(string: "https://example.com/avatar3.png")!), updatedAt: Date(), htmlURL: URL(string: "https://example.com/repo3")!)
        viewModel.repositories = [repository]

        viewModel.markRepositoryAsViewed(at: 0)

        #expect(viewModel.repositories[0].isViewed)
        #expect(mockHistoryProvider.repositories.contains(where: { $0.id == repository.id }))
    }

    @Test
    func testSearchHandlesError() async {
        mockRepositoriesProvider.shouldThrowError = true

        viewModel.searchQuery = "Test"
        await viewModel.search()

        #expect(viewModel.paginationState == .error("An error occurred"))
    }
}

// Mocks

final class MockRepositoriesProvider: RepositoriesProvider, @unchecked Sendable {
    var mockRepositories: [Repository] = []
    var shouldThrowError: Bool = false

    func get(
        matching query: String,
        sort: SortKind,
        order: OrderKind,
        page: Int,
        perPage: Int
    ) async throws -> [Repository] {
        if shouldThrowError {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
        return mockRepositories
    }

    func get(userLogin: String, page: Int, perPage: Int) async throws -> [Repository] {
        if shouldThrowError {
            throw NSError(domain: "", code: 0, userInfo: nil)
        }
        return mockRepositories
    }
}

final class MockRepositoryHistoryProvider: RepositoryHistoryProvider, @unchecked Sendable {
    var repositories: [Repository] = []

    func add(_ repository: Repository) {
        repositories.append(repository)
    }
}

final class MockAppStateManager: AppStateManager {
    func logout() {
        // Mock logout logic if needed
    }
}
