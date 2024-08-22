import SwiftUI

struct RepositoryView: View {
    let repository: Repository

    @Environment(\.openURL) private var openURL
    private let gradientColors = [Color.accentColor.opacity(0.18), Color.clear]

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
                    ownerSection
                    descriptionSection
                    statsSection
                    lastUpdatedSection
                    languageSection
                    viewOnGitHubButton
                }
                .padding()
            }
        }
        .navigationTitle(repository.name)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var ownerSection: some View {
        Button {
            openURL(repository.owner.htmlURL)
        } label: {
            HStack(spacing: 16) {
                AsyncImage(url: repository.owner.avatarURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
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
    }

    @ViewBuilder
    private var descriptionSection: some View {
        if let description = repository.description {
            Text(description)
                .font(.body)
                .foregroundColor(.primary)
                .padding(.top, 8)
        }
    }

    private var statsSection: some View {
        HStack {
            statView(type: .stars, value: repository.stargazersCount)
            statView(type: .forks, value: repository.forksCount)
            statView(type: .watchers, value: repository.watchersCount)
            statView(type: .issues, value: repository.openIssuesCount)
        }
        .font(.subheadline)
        .foregroundColor(.secondary)
        .padding(.vertical, 12)
        .background(.thinMaterial)
        .cornerRadius(12)
    }

    private var lastUpdatedSection: some View {
        Label("Last updated: \(formattedDate(repository.updatedAt))", systemImage: "calendar")
            .font(.footnote)
            .foregroundColor(.secondary)
            .padding(.top, 8)
    }

    @ViewBuilder
    private var languageSection: some View {
        if let language = repository.language {
            Text("Written in \(language)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    private var viewOnGitHubButton: some View {
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

    private func statView(type: RepositoryStatType, value: Int) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
                Image(systemName: type.iconName)
                Text("\(value)")
            }

            Text(type.title)
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


