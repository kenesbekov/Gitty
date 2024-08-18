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

    @State private var isPaginationLoading = false
    @State private var currentPage = 1
    @State private var hasMorePages = true

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
                    Text("No repos found")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVStack {
                            ForEach(repositories.indices, id: \.self) { index in
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
                                        .lineLimit(4)
                                    
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
                                .onAppear {
                                    if index == repositories.count - 1 && hasMorePages && !isLoading && !isPaginationLoading {
                                        currentPage += 1
                                        Task {
                                            await searchRepositories(query: query, page: currentPage)
                                        }
                                    }
                                }
                            }
                            
                            if isPaginationLoading {
                                ProgressView()
                                    .padding()
                            }
                        }
                    }
                }
            }
            .onChange(of: query) { newValue in
                currentPage = 1
                hasMorePages = true
                repositories.removeAll()
                searchSubject.send(newValue)
            }
            .onAppear {
                searchCancellable = searchSubject
                    .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
                    .removeDuplicates()
                    .sink { query in
                        Task {
                            await searchRepositories(query: query, page: currentPage)
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

    private func searchRepositories(query: String, page: Int) async {
        defer {
            isLoading = false
            isPaginationLoading = false
        }

        do {
            if page == 1 {
                isLoading = true
            } else {
                isPaginationLoading = true
            }
            let sortOption: SortOption = .forks // You can make this dynamic if needed
            let orderOption: OrderOption = .descending // You can make this dynamic if needed
            let newRepositories = try await api.searchRepositories(query: query, sort: sortOption, order: orderOption, page: page, perPage: 20)
            if newRepositories.isEmpty {
                hasMorePages = false
            } else {
                repositories.append(contentsOf: newRepositories)
            }
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func markAsViewed(at index: Int) {
        repositories[index].isViewed = true
    }
}
