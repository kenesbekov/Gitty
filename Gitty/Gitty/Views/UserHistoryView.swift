import SwiftUI

struct UserHistoryView: View {
    let api: GitHubAPI
    let history: UserHistory

    var body: some View {
        ZStack {
            if history.viewedUsers.isEmpty {
                Text("No viewed users")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(history.viewedUsers) { user in
                    NavigationLink(destination: UserRepositoriesView(api: api, user: user)) {
                        Text(user.login)
                            .font(.headline)
                    }
                }
            }
        }
        .navigationTitle("Viewed Users")
    }
}
