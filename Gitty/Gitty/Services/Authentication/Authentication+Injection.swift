import Foundation

extension DependencyContainer {
    func registerAuthenticationServices() {
        register(OAuthHandlerImpl(), forType: OAuthHandler.self)
        register(TokenValidatorImpl(), forType: TokenValidator.self)
        register(AccessTokenProviderImpl(), forType: AccessTokenProvider.self)
    }
}
