import SwiftUI

struct UserHistoryView: View {
    @Injected private var historyProvider: UserHistoryProvider

    @State private var showAlert = false

    var body: some View {
        ZStack {
            if historyProvider.users.isEmpty {
                Text("No viewed users")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(historyProvider.users) { user in
                    NavigationLink(destination: UserRepositoriesView(user: user)) {
                        Text(user.login)
                            .font(.headline)
                    }
                    .onTapGesture {
                        historyProvider.add(user)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showAlert = true
                }) {
                    Text("Clear")
                }
            }
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Clear History"),
                message: Text("Are you sure you want to clear the history?"),
                primaryButton: .destructive(Text("Clear")) {
                    historyProvider.clear()
                },
                secondaryButton: .cancel()
            )
        }
        .navigationTitle("History")
    }
}
