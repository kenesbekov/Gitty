import SwiftUI

struct UsersView: View {
    @StateObject private var viewModel = UsersViewModel()
    @Environment(\.openURL) private var openURL
    @State private var showingLogoutAlert = false

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else if viewModel.searchQuery.isEmpty {
                    Text("Start typing to search for repositories.")
                        .foregroundColor(.gray)
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
            .padding()
            .searchable(text: $viewModel.searchQuery, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
            .onSubmit(of: .search) {
                viewModel.searchUsers()
            }
            .alert("Are you sure you want to log out?", isPresented: $showingLogoutAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Log Out", role: .destructive) {
//                    viewModel.deleteToken(appStateManager: appStateManager)
                }
            }
        }
    }
}

struct UserRowView: View {
    let user: User

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
