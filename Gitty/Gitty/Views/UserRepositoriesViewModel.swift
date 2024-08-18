import Foundation
import SwiftUI

@MainActor
final class UserRepositoriesViewModel: ObservableObject {
    @Published var repositories: [GitHubRepository] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    @Inject private var api: GitHubAPI

    let user: GitHubUser

    init(user: GitHubUser) {
        self.user = user
        Task {
            await fetchRepositories()
        }
    }

    func fetchRepositories() async {
        defer {
            isLoading = false
        }

        do {
            isLoading = true
            repositories = try await api.searchRepositories(query: "user:\(user.login)", page: 1, perPage: 30)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
