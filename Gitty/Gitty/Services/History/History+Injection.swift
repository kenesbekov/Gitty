import Foundation

extension DependencyContainer {
    func registerHistoryServices() {
        register(RepositoryHistoryManager(), forType: HistoryCleaner.self)
        register(RepositoryHistoryManager(), forType: RepositoryHistoryProvider.self)
        register(UserHistoryManager(), forType: HistoryCleaner.self)
        register(UserHistoryManager(), forType: UserHistoryProvider.self)
    }
}
