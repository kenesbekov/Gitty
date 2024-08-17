import SwiftUI

struct UserRepositoriesView: View {
    let api: GitHubAPI
    let user: GitHubUser

    @State private var repositories: [GitHubRepository] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
                    .padding()
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(repositories) { repository in
                    VStack(alignment: .leading) {
                        Text(repository.fullName)
                            .font(.headline)
                        Text(repository.description ?? "No description")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        HStack {
                            Text("Stars: \(repository.stargazersCount)")
                            Text("Forks: \(repository.forksCount)")
                        }
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("\(user.login)'s Repositories")
        .onAppear {
            Task {
                await fetchRepositories()
            }
        }
    }

    private func fetchRepositories() async {
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
