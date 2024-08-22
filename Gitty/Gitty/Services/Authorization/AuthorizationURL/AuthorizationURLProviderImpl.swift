import Foundation

final class AuthorizationURLProviderImpl: AuthorizationURLProvider {
    func get() -> URL? {
        var components = URLComponents(string: "https://github.com/login/oauth/authorize")
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: APIConstants.clientID),
            URLQueryItem(name: "redirect_uri", value: APIConstants.redirectURI)
        ]
        return components?.url
    }
}
