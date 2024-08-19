import Foundation

extension DependencyContainer {
    func registerHistoryServices() {
        register(RepositoryHistoryManager(), forType: RepositoryHistoryCleaner.self)
        register(RepositoryHistoryManager(), forType: RepositoryHistoryProvider.self)
        register(UserHistoryManager(), forType: UserHistoryCleaner.self)
        register(UserHistoryManager(), forType: UserHistoryProvider.self)
    }
}
