import SwiftUI

struct UserHistoryView: View {
    let history: UserHistory

    @EnvironmentObject var appRouter: AppRouter

    var body: some View {
        NavigationView {
            ZStack {
                if history.viewedUsers.isEmpty {
                    Text("No viewed users")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(history.viewedUsers) { user in
                        Button {
                            appRouter.navigateTo(.userRepositories(user))
                        } label: {
                            Text(user.login)
                                .font(.headline)
                        }
                    }
                }
            }
            .navigationTitle("Viewed Users")
        }
    }
}
