import SwiftUI
import Combine

struct UsersView: View {
    let api: GitHubAPI
    let history: UserHistory

    init(api: GitHubAPI, history: UserHistory) {
        self.api = api
        self.history = history
    }

    @State private var query = ""
    @State private var users: [GitHubUser] = []
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var searchCancellable: AnyCancellable?

    private var searchSubject = PassthroughSubject<String, Never>()

    public var body: some View {
        NavigationView {
            VStack {
                if isLoading {
                    ProgressView("Loading...")
                        .padding()
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if users.isEmpty {
                    Text("No users found")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(users) { user in
                        NavigationLink(destination: UserRepositoriesView(api: api, user: user)) {
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
                }
            }
            .navigationTitle("Users")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: UserHistoryView(api: api, history: history)) {
                        Image(systemName: "clock")
                    }
                }
            }
            .padding()
            .onChange(of: query) { newValue in
                searchSubject.send(newValue)
            }
            .onAppear {
                searchCancellable = searchSubject
                    .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
                    .removeDuplicates()
                    .sink { query in
                        Task {
                            await searchUsers(query: query)
                        }
                    }
            }
            .onDisappear {
                searchCancellable?.cancel()
            }
            .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: "Search")
        }
    }

    private func searchUsers(query: String) async {
        defer {
            isLoading = false
        }

        do {
            isLoading = true
            let searchResponse = try await api.searchUsers(query: query, page: 1, perPage: 30)
            var fetchedUsers = searchResponse.items

            // Fetch followers count for each user
            for (index, user) in fetchedUsers.enumerated() {
                do {
                    let userProfile = try await api.fetchUserProfile(for: user)
                    fetchedUsers[index].followers = userProfile.followers
                } catch {
                    print("Failed to fetch profile for \(user.login): \(error.localizedDescription)")
                    fetchedUsers[index].followers = 0 // Default to 0 if failed
                }
            }

            // Sort users by followers count in descending order
            users = fetchedUsers.sorted { ($0.followers ?? 0) > ($1.followers ?? 0) }
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            users = []
        }
    }
}
