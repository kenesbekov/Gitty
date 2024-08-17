import SwiftUI

enum Destination: Hashable {
    case home
    case repositoryDetail(GitHubRepository)
    case userRepositories(GitHubUser)
    case userHistory
}

final class AppRouter: ObservableObject {
    @Published var currentDestination: Destination = .home

    func navigateTo(_ destination: Destination) {
        self.currentDestination = destination
    }
}
