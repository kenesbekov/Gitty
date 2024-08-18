import Foundation

extension DependencyContainer {
    func registerUserServices() {
        register(UserProfileProviderImpl(), forType: UserProfileProvider.self)
        register(UsersProviderImpl(), forType: UsersProvider.self)
        register(UserHistoryProviderImpl(), forType: UserHistoryProvider.self)
        register(RepositoryHistoryProviderImpl(), forType: RepositoryHistoryProvider.self)
        register(OAuthHandlerImpl(), forType: OAuthHandler.self)
    }
}
