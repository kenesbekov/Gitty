import SwiftUI

struct RepositoryHistoryView: View {
    @Injected private var historyProvider: RepositoryHistoryProvider
    @State private var showAlert = false
    @Environment(\.openURL) private var openURL

    var body: some View {
        ZStack {
            if historyProvider.repositories.isEmpty {
                emptyStateView
            } else {
                repositoryListView
            }
        }
        .navigationTitle("History")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showAlert = true
                } label: {
                    Text("Clear")
                }
                .disabled(historyProvider.repositories.isEmpty)
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
    }

    private func clearHistory() {
        historyProvider.clear()
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

            Text("No viewed repos")
                .font(.headline)
                .foregroundColor(.gray)
                .padding()
        }
    }

    private var repositoryListView: some View {
        ScrollView {
            LazyVStack {
                ForEach(historyProvider.repositories) { repository in
                    RepositoryRowView(
                        repository: repository,
                        openURL: { url in openURL(url) },
                        markAsViewed: { historyProvider.add(repository) },
                        showViewedIndicator: false
                    )
                }
            }
            .padding(.bottom, 20)
        }
    }
}
