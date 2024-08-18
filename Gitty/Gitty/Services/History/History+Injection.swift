import Foundation

extension DependencyContainer {
    func registerHistoryServices() {
        register(RepositoryHistoryProviderImpl(), forType: RepositoryHistoryProvider.self)
        register(UserHistoryProviderImpl(), forType: UserHistoryProvider.self)
    }
}
