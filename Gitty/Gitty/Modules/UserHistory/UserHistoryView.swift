import SwiftUI

struct UserHistoryView: View {
    @Injected private var cleaner: HistoryCleaner
    @Injected private var provider: UserHistoryProvider

    @State private var showAlert = false
    @State private var users: [User]

    init() {
        @Injected var provider: UserHistoryProvider
        self.users = provider.users
    }

    var body: some View {
        ZStack {
            if users.isEmpty {
                emptyStateView
            } else {
                usersListView
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showAlert = true
                } label: {
                    Text("Clear")
                }
                .disabled(users.isEmpty)
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Clear History"),
                message: Text("Are you sure you want to clear the history?"),
                primaryButton: .destructive(Text("Clear")) {
                    clearHistory()
                },
                secondaryButton: .cancel()
            )
        }
        .navigationTitle("History")
    }

    private func clearHistory() {
        users.removeAll()
        cleaner.clear()
        provideSuccessHapticFeedback()
    }

    private func provideSuccessHapticFeedback() {
        let feedbackGenerator = UINotificationFeedbackGenerator()
        feedbackGenerator.prepare()
        feedbackGenerator.notificationOccurred(.success)
    }

    private var emptyStateView: some View {
        VStack {
            Image(systemName: "clock")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 60, height: 60)
                .foregroundColor(.gray)
                .padding()

            Text("No viewed users")
                .font(.headline)
                .foregroundColor(.gray)
                .padding()
        }
    }

    private var usersListView: some View {
        ScrollView {
            LazyVStack {
                ForEach(users) { user in
                    NavigationLink(
                        destination: UserRepositoriesView(user: user)
                    ) {
                        UserRowView(
                            user: user,
                            markAsViewed: {
                                provider.add(user)
                            },
                            showViewedIndicator: false
                        )
                    }
                }
            }
            .padding(.bottom, 20)
        }
    }
}
