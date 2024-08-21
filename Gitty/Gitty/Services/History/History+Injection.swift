import Foundation

extension DependencyContainer {
    func registerHistoryServices() {
        let repositoryHistoryManager = RepositoryHistoryManager()
        let userHistoryManager = UserHistoryManager()

        register(repositoryHistoryManager, forType: RepositoryHistoryCleaner.self)
        register(repositoryHistoryManager, forType: RepositoryHistoryProvider.self)
        register(userHistoryManager, forType: UserHistoryCleaner.self)
        register(userHistoryManager, forType: UserHistoryProvider.self)
    }
}
