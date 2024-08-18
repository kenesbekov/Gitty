import Foundation

extension DependencyContainer {
    func registerAuthenticationServices() {
        register(TokenValidatorImpl(), forType: TokenValidator.self)
        register(AccessTokenProviderImpl(), forType: AccessTokenProvider.self)
    }
}
