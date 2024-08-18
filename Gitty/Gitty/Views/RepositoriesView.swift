import SwiftUI

struct RepositoriesView: View {
    @ObservedObject var viewModel: RepositoriesViewModel
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
                    ScrollView {
                        LazyVStack {
                            ForEach(viewModel.repositories.indices, id: \.self) { index in
                                RepositoryRowView(
                                    repository: viewModel.repositories[index],
                                    openURL: { url in openURL(url) },
                                    markAsViewed: { viewModel.markAsViewed(at: index) }
                                )
                                .onAppear {
                                    if index == viewModel.repositories.count - 1 {
                                        viewModel.loadMoreRepositories()
                                    }
                                }
                            }

                            if viewModel.isPaginationLoading {
                                ProgressView()
                                    .padding()
                            }
                        }
                    }
                }
            }
            .onChange(of: viewModel.query) { _ in
                viewModel.searchRepositories()
            }
            .searchable(text: $viewModel.query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
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
}
