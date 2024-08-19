import Foundation

final class NetworkClientImpl: NetworkClient {
    private let session: URLSession
    private let decoder: JSONDecoder

    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.session = session
        self.decoder = decoder
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
    }

    func request<Response: Decodable>(
        _ endpoint: String,
        method: HTTPMethod = .get,
        body: Data? = nil,
        headers: [String: String]? = nil,
        isOAuthRequest: Bool = false
    ) async throws(NetworkError) -> Response {
        let baseURL = isOAuthRequest ? BaseURL.oauth : BaseURL.api

        guard
            let baseURL,
            let url = URL(string: "\(baseURL)\(endpoint)")
        else {
            throw .invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }

        do {
            let (data, response) = try await session.data(for: request)
            return try processResponse(data: data, response: response)
        } catch {
            throw .networkError(error)
        }
    }

    func request<Response: Decodable>(_ endpoint: String) async throws(NetworkError) -> Response {
        try await request(endpoint, method: .get, body: nil, headers: nil, isOAuthRequest: false)
    }

    func request<Response: Decodable>(_ endpoint: String, headers: [String: String]?) async throws(NetworkError) -> Response {
        try await request(endpoint, method: .get, body: nil, headers: headers, isOAuthRequest: false)
    }

    private func processResponse<Response: Decodable>(
        data: Data,
        response: URLResponse
    ) throws(NetworkError) -> Response {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw .invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            let statusCode = httpResponse.statusCode
            throw .httpError(statusCode: statusCode)
        }

        do {
            return try decoder.decode(Response.self, from: data)
        } catch {
            let jsonString = String(data: data, encoding: .utf8) ?? "No data"
            print("Decoding Error: \(error.localizedDescription)")
            print("Response Data: \(jsonString)")
            throw .decodingError(error)
        }
    }
}
