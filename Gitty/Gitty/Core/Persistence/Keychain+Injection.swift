import Foundation

extension DependencyContainer {
    func registerKeychainServices() {
        register(KeychainManagerImpl(), forType: KeychainManager.self)
    }
}
