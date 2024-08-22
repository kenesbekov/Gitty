import SwiftUI

struct RepositoryView: View {
    let repository: Repository

    @Environment(\.openURL) private var openURL
    private let gradientColors = [Color.accentColor.opacity(0.15), Color.clear]

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Button {
                        openURL(repository.owner.htmlURL)
                    } label: {
                        HStack(spacing: 16) {
                            AsyncImage(url: repository.owner.avatarURL) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .clipShape(.circle)
                                    .overlay(Circle().stroke(Color.gray.opacity(0.3), lineWidth: 1))
                            } placeholder: {
                                ProgressView()
                                    .frame(width: 50, height: 50)
                            }

                            VStack(alignment: .leading) {
                                Text(repository.owner.login)
                                    .font(.headline)
                                    .foregroundColor(.primary)

                                Text("Owner")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                    }

                    if let description = repository.description {
                        Text(description)
                            .font(.body)
                            .foregroundColor(.primary)
                            .padding(.top, 8)
                    }

                    HStack {
                        statView(icon: "star.fill", title: "Stars", value: repository.stargazersCount)
                        statView(icon: "tuningfork", title: "Forks", value: repository.forksCount)
                        statView(icon: "eye.fill", title: "Watchers", value: repository.watchersCount)
                        statView(icon: "exclamationmark.circle.fill", title: "Issues", value: repository.openIssuesCount)
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.vertical, 12)
                    .background(.thinMaterial)
                    .cornerRadius(12)

                    Label("Last updated: \(formattedDate(repository.updatedAt))", systemImage: "calendar")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)

                    if let language = repository.language {
                        Text("Written in \(language)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    Button {
                        if let url = URL(string: repository.htmlURL.absoluteString) {
                            openURL(url)
                        }
                    } label: {
                        Text("View on GitHub")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .cornerRadius(12)
                    }
                    .padding(.top, 12)
                }
                .padding()
            }
        }
        .navigationTitle(repository.name)
    }

    private func statView(icon: String, title: String, value: Int) -> some View {
        VStack(alignment: .leading) {
            HStack(spacing: 4) {
                Image(systemName: icon)
                Text("\(value)")
            }

            Text(title)
        }
        .frame(maxWidth: .infinity)
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
