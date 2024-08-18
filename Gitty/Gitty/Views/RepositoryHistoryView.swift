import SwiftUI

struct RepositoryHistoryView: View {
    let history: RepositoryHistory

    @Environment(\.openURL) var openURL
    @State private var showAlert = false

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    var body: some View {
        ZStack {
            if history.repositories.isEmpty {
                Text("No viewed repos")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(history.repositories) { repository in
                    VStack(alignment: .leading) {
                        Button {
                            openURL(repository.htmlURL)
                            history.add(repository)
                        } label: {
                            Text(repository.name)
                                .font(.headline)
                        }

                        Text(repository.description ?? "No description")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text("Owner: \(repository.owner.login)")
                        HStack {
                            Text("Stars: \(repository.stargazersCount)")
                            Text("Forks: \(repository.forksCount)")
                        }
                        .font(.footnote)
                        .foregroundColor(.secondary)

                        Text("Updated: \(dateFormatter.string(from: repository.updatedAt))")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
        .navigationTitle("Viewed Repos")
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
                    history.clear()
                },
                secondaryButton: .cancel()
            )
        }
    }
}
