import SwiftUI

struct RepositoriesRowView: View {
    let repository: Repository
    let openURL: (URL) -> Void
    let markAsViewed: () -> Void
    let showViewedIndicator: Bool

    @State private var isViewed: Bool
    @State private var isNavigationActive = false

    init(
        repository: Repository,
        openURL: @escaping (URL) -> Void,
        markAsViewed: @escaping () -> Void,
        showViewedIndicator: Bool = true
    ) {
        self.repository = repository
        self.openURL = openURL
        self.markAsViewed = markAsViewed
        self.showViewedIndicator = showViewedIndicator
        self.isViewed = repository.isViewed
    }

    var body: some View {
        Button {
            markAsViewed()
            isViewed = true
            isNavigationActive = true
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(repository.name)
                        .font(.headline)
                        .foregroundColor(.accentColor)
                        .lineLimit(1)

                    Spacer()

                    if showViewedIndicator && isViewed {
                        Image(systemName: "eye")
                            .foregroundColor(.secondary)
                            .opacity(0.5)
                            .transition(.opacity)
                    }
                }

                if let description = repository.description, !description.isEmpty {
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                } else {
                    Text("No description available")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .italic()
                }

                Label("\(repository.owner.login)", systemImage: "person.fill")
                    .font(.footnote)
                    .foregroundColor(.secondary)

                HStack {
                    Label("\(repository.stargazersCount)", systemImage: "star.fill")
                        .font(.footnote)
                        .foregroundColor(.yellow)

                    Label("\(repository.forksCount)", systemImage: "tuningfork")
                        .font(.footnote)
                        .foregroundColor(.blue)
                }

                Text("Updated: \(formattedDate(repository.updatedAt))")
                    .font(.footnote)
                    .foregroundColor(.secondary)

                Divider()
            }
            .frame(maxWidth: .infinity)
            .padding(.top)
            .padding(.horizontal)
        }
        .background(
            NavigationLink(
                destination: RepositoryView(repository: repository),
                isActive: $isNavigationActive,
                label: { EmptyView() }
            )
        )
        .contextMenu {
            Button {
                openURL(repository.owner.htmlURL)
            } label: {
                Label("Go to Owner", systemImage: "person")
            }

            Button {
                openURL(repository.htmlURL)
            } label: {
                Label("Go to GitHub", systemImage: "link")
            }
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
