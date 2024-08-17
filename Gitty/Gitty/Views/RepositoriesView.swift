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
                    List(repositories) { repository in
                        Button {
                            addToHistory(repository)
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

                                Text("Updated: \(dateFormatter.string(from: repository.updatedAt))")
                                    .font(.footnote)
                                    .foregroundColor(.secondary)
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
            .navigationTitle("Repositories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: RepositoryHistoryView(history: history)) {
                        Image(systemName: "clock")
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
            let sortOption: SortOption = .updated // You can make this dynamic if needed
            let orderOption: OrderOption = .descending // You can make this dynamic if needed
            repositories = try await api.searchRepositories(query: query, sort: sortOption, order: orderOption, page: 1, perPage: 30)
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
