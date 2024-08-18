import Foundation

extension DependencyContainer {
    func registerServices() {
        registerNetworkServices()
        registerAuthenticationServices()
        registerRepositoriesServices()
        registerHistoryServices()
        registerUserServices()
    }
}
