import SwiftUI

struct UserHistoryView: View {
    let userHistory: UserHistory

    @EnvironmentObject var appRouter: AppRouter

    var body: some View {
        NavigationView {
            ZStack {
                if userHistory.viewedUsers.isEmpty {
                    Text("No viewed users")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    List(userHistory.viewedUsers) { user in
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
