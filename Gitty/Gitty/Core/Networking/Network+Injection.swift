import Foundation

extension DependencyContainer {
    func registerNetworkServices() {
        register(NetworkClientImpl(), forType: NetworkClient.self)
    }
}
