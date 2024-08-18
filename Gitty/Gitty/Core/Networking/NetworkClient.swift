import Foundation

protocol NetworkClient {
    func request<Response: Decodable>(
        _ endpoint: String,
        method: HTTPMethod,
        body: Data?,
        headers: [String: String]?,
        isOAuthRequest: Bool
    ) async throws -> Response

    func request<Response: Decodable>(
        _ endpoint: String
    ) async throws -> Response

    func request<Response: Decodable>(
        _ endpoint: String,
        headers: [String: String]?
    ) async throws -> Response
}
