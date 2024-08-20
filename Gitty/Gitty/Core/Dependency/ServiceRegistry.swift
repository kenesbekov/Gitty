import Foundation

extension DependencyContainer {
    func registerServices() {
        registerKeychainServices()
        registerNetworkServices()
        registerAuthenticationServices()
        registerRepositoriesServices()
        registerHistoryServices()
        registerUserServices()
    }
}
