import Foundation

protocol NetworkClient {
    func fetch<T: Decodable>(
        _ endpoint: String,
        method: String,
        body: Data?,
        headers: [String: String]?,
        isOAuthRequest: Bool
    ) async throws -> T
}
