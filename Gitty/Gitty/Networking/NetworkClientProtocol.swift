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

final class NetworkClientImpl: NetworkClient {
    private let apiBaseURL: String
    private let oauthBaseURL: String
    private let session = URLSession.shared

    init(apiBaseURL: String = "https://api.github.com", oauthBaseURL: String = "https://github.com") {
        self.apiBaseURL = apiBaseURL
        self.oauthBaseURL = oauthBaseURL
    }

    func fetch<T: Decodable>(
        _ endpoint: String,
        method: String = "GET",
        body: Data? = nil,
        headers: [String: String]? = nil,
        isOAuthRequest: Bool = false
    ) async throws -> T {
        let baseURL = isOAuthRequest ? oauthBaseURL : apiBaseURL
        guard let url = URL(string: "\(baseURL)\(endpoint)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        headers?.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }

        // Add OAuth token if needed
        if isOAuthRequest {
            // Add OAuth token handling if needed
        }

        do {
            let (data, response) = try await session.data(for: request)

            // Log raw response data
            print("Raw Response Data: \(String(data: data, encoding: .utf8) ?? "No data")")

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                let errorMessage = "HTTP Error: \(response)"
                print(errorMessage)
                throw URLError(.badServerResponse)
            }

            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
        } catch {
            // Log detailed network error
            print("Network Error: \(error.localizedDescription)")
            throw error
        }
    }

}
