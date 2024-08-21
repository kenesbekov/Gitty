import SwiftUI

@MainActor
final class UserRepositoriesViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    @Injected private var repositoriesProvider: RepositoriesProvider

    let user: User

    init(user: User) {
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
}
