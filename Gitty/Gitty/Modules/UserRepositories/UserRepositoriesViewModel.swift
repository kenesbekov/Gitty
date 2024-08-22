import SwiftUI

@MainActor
final class UserRepositoriesViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    var navigationTitle: String {
        "\(user.login)'s Repos"
    }

    @Injected private var repositoriesProvider: RepositoriesProvider
    @Injected private var historyProvider: RepositoryHistoryProvider

    private let user: User

    init(with user: User) {
        self.user = user

        Task {
            await fetchRepositories()
        }
    }

    func fetchRepositories() async {
        isLoading = true
        do {
            repositories = try await repositoriesProvider.get(userLogin: user.login, page: 1, limit: 30)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    func markAsViewed(at index: Int) {
        guard repositories.indices.contains(index) else {
            return
        }

        repositories[index].isViewed = true
        historyProvider.add(repositories[index])
    }
}
