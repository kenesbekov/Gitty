import SwiftUI

struct UserRepositoriesView: View {
    @StateObject private var viewModel: UserRepositoriesViewModel

    init(user: GitHubUser) {
        _viewModel = StateObject(wrappedValue: UserRepositoriesViewModel(user: user))
    }

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView("Loading...")
                    .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                List(viewModel.repositories) { repository in
                    VStack(alignment: .leading) {
                        Text(repository.name)
                            .font(.headline)
                        Text(repository.description ?? "No description")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
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
        .navigationTitle("\(viewModel.user.login)'s Repos")
        .padding()
    }
}
