import SwiftUI

struct RepositoryRowView: View {
    let repository: Repository
    let openURL: (URL) -> Void
    let markAsViewed: () -> Void
    let showViewedIndicator: Bool

    @State private var isViewed: Bool

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

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
        _isViewed = State(initialValue: repository.isViewed)
    }

    var body: some View {
        Button {
            openURL(repository.htmlURL)
            if !isViewed {
                markAsViewed()
                isViewed = true
            }
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

                Text("Updated: \(dateFormatter.string(from: repository.updatedAt))")
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(showViewedIndicator && isViewed ? Color.blue.opacity(0.1) : Color.clear)
            .animation(.easeInOut, value: isViewed)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
