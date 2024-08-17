import SwiftUI

struct RepositoryHistoryView: View {
    let history: RepositoryHistory

    var body: some View {
        List(history.repositories) { repository in
            Button {
                // Handle navigation to repository detail view
            } label: {
                VStack(alignment: .leading) {
                    Text(repository.fullName)
                        .font(.headline)
                    Text(repository.description ?? "No description")
                        .font(.subheadline)
                    HStack {
                        Text("Stars: \(repository.stargazersCount)")
                        Text("Forks: \(repository.forksCount)")
                    }
                    .font(.footnote)
                }
            }
        }
        .navigationTitle("Viewed Repositories")
    }
}
