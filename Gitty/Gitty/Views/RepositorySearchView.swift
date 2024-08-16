import SwiftUI

struct RepositorySearchView: View {
    let api: GitHubAPI

    @EnvironmentObject private var appRouter: AppRouter
    @State private var query = ""
    @State private var repositories: [GitHubRepository] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            TextField("Search repositories", text: $query, onCommit: {
                Task {
                    await searchRepositories(query: query)
                }
            })
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())

            if isLoading {
                ProgressView()
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else {
                List(repositories) { repository in
                    VStack(alignment: .leading) {
                        Text(repository.fullName)
                            .font(.headline)
                        Text(repository.description ?? "No description")
                            .font(.subheadline)
                        HStack {
                            Text("Stars: \(repository.stargazersCount)")
                            Text("Forks: \(repository.forksCount)")
                        }
                        .font(.footnote)
                    }
                    .onTapGesture {
                        appRouter.navigateTo(.repositoryDetail(repository))
                    }
                }
            }
        }
        .navigationTitle("Search Repositories")
    }

    private func searchRepositories(query: String) async {
        defer {
            isLoading = false
        }

        do {
            isLoading = true
            repositories = try await api.searchRepositories(query: query, page: 1, perPage: 30)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
