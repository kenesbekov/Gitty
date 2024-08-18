import SwiftUI
import Combine

struct RepositoriesView: View {
    let api: GitHubAPI
    let history: RepositoryHistory

    init(api: GitHubAPI, history: RepositoryHistory) {
        self.api = api
        self.history = history
    }

    @State private var query = ""
    @State private var repositories: [GitHubRepository] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var searchCancellable: AnyCancellable?
    @Environment(\.openURL) var openURL
    @EnvironmentObject private var appStateManager: AppStateManager

    private var searchSubject = PassthroughSubject<String, Never>()

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    var body: some View {
        NavigationView {
            VStack {
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
                    List(repositories.indices, id: \.self) { index in
                        let repository = repositories[index]

                        VStack(alignment: .leading) {
                            Button {
                                openURL(repository.htmlURL)
                                history.add(repository)
                                markAsViewed(at: index)
                            } label: {
                                Text(repository.name)
                                    .font(.headline)
                            }

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

                            Text("Updated: \(dateFormatter.string(from: repository.updatedAt))")
                                .font(.footnote)
                                .foregroundColor(.secondary)

                            if repository.isViewed {
                                Text("Viewed")
                                    .font(.footnote)
                                    .foregroundColor(.blue)
                            }
                        }
                    }
                }
            }
            .onChange(of: query) { newValue in
                searchSubject.send(newValue)
            }
            .onAppear {
                searchCancellable = searchSubject
                    .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
                    .removeDuplicates()
                    .sink { query in
                        Task {
                            await searchRepositories(query: query)
                        }
                    }
            }
            .onDisappear {
                searchCancellable?.cancel()
            }
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
            .navigationTitle("Repos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: RepositoryHistoryView(history: history)) {
                        Image(systemName: "clock")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        deleteToken()
                    } label: {
                        Image(systemName: "pip.exit")
                    }
                }
            }
            .padding()
        }
    }

    private func deleteToken() {
        appStateManager.logout()
    }

    private func searchRepositories(query: String) async {
        defer {
            isLoading = false
        }

        do {
            isLoading = true
            let sortOption: SortOption = .forks // You can make this dynamic if needed
            let orderOption: OrderOption = .descending // You can make this dynamic if needed
            repositories = try await api.searchRepositories(query: query, sort: sortOption, order: orderOption, page: 1, perPage: 30)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            repositories = []
        }
    }

    private func markAsViewed(at index: Int) {
        repositories[index].isViewed = true
    }
}
