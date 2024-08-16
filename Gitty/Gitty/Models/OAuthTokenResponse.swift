import Foundation

struct OAuthTokenResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
    }

    let accessToken: String
    let tokenType: String
    let scope: String
}
