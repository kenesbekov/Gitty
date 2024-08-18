import Foundation

extension DependencyContainer {
    func registerServices() {
        registerNetworkServices()
        registerAuthenticationServices()
        registerRepositoryServices()
        registerHistoryServices()
        registerUserServices()
    }
}
