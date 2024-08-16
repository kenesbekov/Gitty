import SwiftUI

enum Destination {
    case home
    case repositoryDetail(GitHubRepository)
}

final class AppRouter: ObservableObject {
    @Published var currentDestination: Destination?

    func navigateTo(_ destination: Destination) {
        self.currentDestination = destination
    }
}
