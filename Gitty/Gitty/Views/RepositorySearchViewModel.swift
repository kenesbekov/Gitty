import Foundation

@MainActor
final class RepositorySearchViewModel: ObservableObject {
    private let repositoryRepo: any RepositoryRepository
    private let history: any RepositoryHistory

    @Published var repositories: [GitHubRepository] = []

    init(repositoryRepo: any RepositoryRepository, history: any RepositoryHistory) {
        self.repositoryRepo = repositoryRepo
        self.history = history
    }

    func searchRepositories(query: String) async {
        do {
            let fetchedRepositories = try await repositoryRepo.searchRepositories(query: query)
            self.repositories = fetchedRepositories
        } catch {
            // Handle error
            print("Failed to fetch repositories: \(error)")
        }
    }

    func addToHistory(_ repository: GitHubRepository) {
        history.addRepository(repository)
    }
}
