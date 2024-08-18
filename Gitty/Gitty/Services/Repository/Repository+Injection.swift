import Foundation

extension DependencyContainer {
    func registerRepositoryServices() {
        register(RepositoriesProviderImpl(), forType: RepositoriesProvider.self)
        register(UserRepositoriesProviderImpl(), forType: UserRepositoriesProvider.self)
    }
}
