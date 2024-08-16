import SwiftUI

struct RepositoryDetailView: View {
    let repository: GitHubRepository

    var body: some View {
        VStack(alignment: .leading) {
            Text(repository.fullName)
                .font(.largeTitle)
                .padding()

            Text(repository.description ?? "No description")
                .font(.body)
                .padding()

            HStack {
                Text("Stars: \(repository.stargazersCount)")
                Text("Forks: \(repository.forksCount)")
            }
            .font(.footnote)
            .padding()

            Button("Open on GitHub") {
                if let url = URL(string: repository.htmlURL) {
                    UIApplication.shared.open(url)
                }
            }
            .padding()
        }
        .navigationTitle("Repository Details")
    }
}
