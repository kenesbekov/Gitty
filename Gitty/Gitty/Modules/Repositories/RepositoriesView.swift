import SwiftUI

struct RepositoriesView: View {
    @StateObject private var viewModel = RepositoriesViewModel()
    @Environment(\.openURL) private var openURL
    @EnvironmentObject private var appStateManager: AppStateManager
    @State private var showingLogoutAlert = false

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if viewModel.searchQuery.isEmpty {
                    emptyStateView
                } else if viewModel.repositories.isEmpty {
                    noResultsView
                } else if viewModel.hasError {
                    errorView
                } else {
                    repositoryListView
                }
            }
            .onChange(of: viewModel.searchQuery) { _ in
                viewModel.performSearch()
            }
            .searchable(text: $viewModel.searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
            .navigationTitle("Repos")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingLogoutAlert = true
                    } label: {
                        Label("Logout", systemImage: "figure.walk")
                            .foregroundColor(.red)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: RepositoryHistoryView()) {
                        Label("History", systemImage: "clock")
                    }
                }
            }
            .alert("Are you sure you want to log out?", isPresented: $showingLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Log Out", role: .destructive) {
                    viewModel.deleteToken(appStateManager: appStateManager)
                }
            }
        }
    }

    private var emptyStateView: some View {
        VStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(.gray)
                .padding()

            Text("Start typing to search for repositories.")
                .font(.headline)
                .foregroundColor(.gray)
                .padding()
        }
    }

    private var noResultsView: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 60)
                .foregroundColor(.orange)
                .padding()

            Text("No Repositories Found")
                .font(.title2)
                .bold()

            Text("Check your connection or try again later.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    private var errorView: some View {
        VStack(spacing: 20) {
            Image(systemName: "xmark.octagon")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 60)
                .foregroundColor(.red)
                .padding()

            Text("Oops! Something went wrong.")
                .font(.title2)
                .foregroundColor(.red)

            Text("Please try again.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }

    private var repositoryListView: some View {
        ScrollView {
            LazyVStack {
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

                if viewModel.isPaginationLoading {
                    ProgressView()
                        .padding()
                }
            }
            .padding(.bottom, 20)
            .refreshable {
                viewModel.performSearch()
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
