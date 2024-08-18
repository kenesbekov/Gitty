//
//  RepositoryRowView.swift
//  Gitty
//
//  Created by Adam Kenesbekov on 18.08.2024.
//


import SwiftUI

struct RepositoryRowView: View {
    let repository: GitHubRepository
    let openURL: (URL) -> Void
    let markAsViewed: () -> Void

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    var body: some View {
        VStack(alignment: .leading) {
            Button(action: {
                openURL(repository.htmlURL)
                markAsViewed()
            }) {
                Text(repository.name)
                    .font(.headline)
                    .foregroundColor(.primary)
            }
            .buttonStyle(PlainButtonStyle())
            
            if let description = repository.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(4)
            } else {
                Text("No description")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(4)
            }

            Text("Owner: \(repository.owner.login)")
                .font(.footnote)
                .foregroundColor(.secondary)

            HStack {
                Text("Stars: \(repository.stargazersCount)")
                Text("Forks: \(repository.forksCount)")
            }
            .font(.footnote)
            .foregroundColor(.secondary)

            Text("Updated: \(dateFormatter.string(from: repository.updatedAt))")
                .font(.footnote)
                .foregroundColor(.secondary)

            if repository.isViewed {
                Text("Viewed")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
        }
        .padding()
    }
}
