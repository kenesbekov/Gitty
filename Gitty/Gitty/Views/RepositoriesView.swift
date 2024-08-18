import SwiftUI

struct RepositoriesView: View {
    @StateObject private var viewModel = RepositoriesViewModel()
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.repositories.isEmpty {
                    Text("No repos found")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    repositoryList
                }
            }
            .onChange(of: viewModel.searchQuery) { _ in
                viewModel.performSearch()
            }
            .searchable(text: $viewModel.searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
            .navigationTitle("Repos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: RepositoryHistoryView(history: viewModel.history)) {
                        Image(systemName: "clock")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.deleteToken()
                    } label: {
                        Image(systemName: "pip.exit")
                    }
                }
            }
            .padding()
        }
    }

    private var repositoryList: some View {
        ScrollView {
            LazyVStack {
                repositoryRows
                if viewModel.isPaginationLoading {
                    ProgressView()
                        .padding()
                }
            }
        }
    }

    private var repositoryRows: some View {
        ForEach(viewModel.repositories.indices, id: \.self) { index in
            RepositoryRowView(
                repository: viewModel.repositories[index],
                openURL: { url in openURL(url) },
                markAsViewed: { viewModel.markRepositoryAsViewed(at: index) }
            )
            .onAppear {
                loadMoreIfNeeded(at: index)
            }
        }
    }

    private func loadMoreIfNeeded(at index: Int) {
        if index == viewModel.repositories.count - 1 {
            viewModel.loadMoreRepositories()
        }
    }
}
