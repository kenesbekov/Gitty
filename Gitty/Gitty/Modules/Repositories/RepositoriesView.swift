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
                } else if viewModel.searchQuery.isEmpty {
                    Text("Start typing to search for repositories.")
                        .foregroundColor(.gray)
                        .padding()
                } else if viewModel.repositories.isEmpty {
                    noResults
                } else if viewModel.hasError {
                    Text("Oops! Something went wrong. Please try again.")
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    repositoryList
                }
            }
            .onChange(of: viewModel.searchQuery) { _ in
                viewModel.performSearch()
            }
            .searchable(text: $viewModel.searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
            .navigationTitle("Repositories")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: RepositoryHistoryView()) {
                        Image(systemName: "clock")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.deleteToken()
                    } label: {
                        Image(systemName: "figure.walk")
                    }
                }
            }
            .padding()
        }
    }

    private var noResults: some View {
        VStack(spacing: 0) {
            Image(systemName: "pill.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 60)
                .foregroundStyle(.secondary)
                .padding()

            Text("No Repos")
                .font(.title)
                .bold()

            Text("Check your connection or try again later.")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.horizontal, 16)
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
        guard index == viewModel.repositories.count - 1 else {
            return
        }

        viewModel.loadMoreRepositories()
    }
}
