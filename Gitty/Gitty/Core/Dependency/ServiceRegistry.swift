import Foundation

extension DependencyContainer {
    func registerServices() {
        registerKeychainServices()
        registerNetworkServices()
        registerAuthorizationServices()
        registerRepositoriesServices()
        registerHistoryServices()
        registerUserServices()
    }
}
