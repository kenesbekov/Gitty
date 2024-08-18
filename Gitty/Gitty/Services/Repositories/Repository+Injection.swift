import Foundation

extension DependencyContainer {
    func registerRepositoriesServices() {
        register(RepositoriesProviderImpl(), forType: RepositoriesProvider.self)
    }
}
