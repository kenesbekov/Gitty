import SwiftUI

struct RepositorySearchView: View {
    let api: GitHubAPI
    let history: RepositoryHistory

    @EnvironmentObject private var appRouter: AppRouter
    @State private var query = ""
    @State private var repositories: [GitHubRepository] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search repositories", text: $query, onCommit: {
                    Task {
                        await searchRepositories(query: query)
                    }
                })
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

                if isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if repositories.isEmpty {
                    Text("No repositories found")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(repositories) { repository in
                        Button {
                            addToHistory(repository)
                            appRouter.navigateTo(.repositoryDetail(repository))
                        } label: {
                            VStack(alignment: .leading) {
                                Text(repository.fullName)
                                    .font(.headline)
                                Text(repository.description ?? "No description")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)

                                Text("Owner: \(repository.owner.login)")
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
            }
            .navigationTitle("Search Repositories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: RepositoryHistoryView(history: history)) {
                        Image(systemName: "clock.arrow.circlepath")
                    }
                }
            }
            .padding()
        }
    }

    private func searchRepositories(query: String) async {
        defer {
            isLoading = false
        }

        do {
            isLoading = true
            repositories = try await api.searchRepositories(query: query, page: 1, perPage: 30)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            repositories = []
        }
    }

    private func addToHistory(_ repository: GitHubRepository) {
        history.add(repository)
    }
}
