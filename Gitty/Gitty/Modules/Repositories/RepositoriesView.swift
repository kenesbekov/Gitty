import SwiftUI

struct RepositoriesView: View {
    @Environment(\.openURL) private var openURL
    @EnvironmentObject private var appStateManager: AppStateManagerImpl
    @State private var showingLogoutAlert = false
    @StateObject private var viewModel = RepositoriesViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                switch viewModel.paginationState {
                case .default:
                    emptyStateView
                case .loading:
                    ProgressView("Loading...")
                        .progressViewStyle(.circular)
                        .padding()
                case .noResults:
                    noResultsView
                case .success, .paginating:
                    repositoryListView
                case .error:
                    errorView
                }
            }
            .refreshable(action: viewModel.refreshed)
            .searchable(text: $viewModel.searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
            .navigationTitle("Repos")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showingLogoutAlert = true
                    } label: {
                        Image(systemName: "figure.walk")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: RepositoryHistoryView()) {
                        Image(systemName: "clock")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Picker(selection: $viewModel.selectedSortKind, label: EmptyView()) {
                            Text("Stars").tag(RepositorySortKind.stars)
                            Text("Forks").tag(RepositorySortKind.forks)
                            Text("Updated").tag(RepositorySortKind.updated)
                        }
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
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
            Spacer()

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

            Spacer()
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
        LazyVStack {
            ForEach(viewModel.repositories.indices, id: \.self) { index in
                RepositoryRowView(
                    repository: viewModel.repositories[index],
                    openURL: { url in openURL(url) },
                    markAsViewed: { viewModel.markAsViewed(at: index) }
                )
                .task {
                    await loadMoreIfNeeded(at: index)
                }
            }

            if viewModel.paginationState == .paginating {
                ProgressView()
                    .padding()
            }
        }
        .padding(.bottom, 20)
    }

    private func loadMoreIfNeeded(at index: Int) async {
        guard index == viewModel.repositories.endIndex - 1 else {
            return
        }

        await viewModel.loadMore()
    }
}
