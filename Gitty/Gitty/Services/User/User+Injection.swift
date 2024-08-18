import Foundation

extension DependencyContainer {
    func registerUserServices() {
        register(UserProfileProviderImpl(), forType: UserProfileProvider.self)
        register(UsersProviderImpl(), forType: UsersProvider.self)
        register(UserRepositoriesProviderImpl(), forType: UserRepositoriesProvider.self)
    }
}
