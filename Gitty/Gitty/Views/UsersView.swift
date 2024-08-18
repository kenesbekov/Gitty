import SwiftUI

struct UsersView: View {
    @StateObject private var viewModel = UsersViewModel()
    @Environment(\.openURL) private var openURL

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.users.isEmpty {
                    Text("No users found")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(viewModel.users) { user in
                        NavigationLink(destination: UserRepositoriesView(user: user)) {
                            UserRowView(user: user)
                        }
                        .onTapGesture {
                            viewModel.addToHistory(user: user)
                        }
                    }
                }
            }
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: UserHistoryView()) {
                        Image(systemName: "clock")
                    }
                }
            }
            .padding()
            .searchable(text: $viewModel.query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
            .onSubmit(of: .search) {
                viewModel.searchUsers()
            }
        }
    }
}

struct UserRowView: View {
    let user: GitHubUser

    var body: some View {
        VStack(alignment: .leading) {
            Text(user.login)
                .font(.headline)

            if let followers = user.followers {
                Text("Followers: \(followers)")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
    }
}
