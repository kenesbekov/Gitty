import Foundation

enum NetworkError: Error, LocalizedError {
    typealias StatusCode = Int

    case invalidURL
    case invalidResponse
    case httpError(statusCode: StatusCode)
    case networkError(Error)
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "The URL is invalid."
        case .invalidResponse:
            "The response from the server was invalid."
        case .httpError(let statusCode):
            "HTTP Error with status code: \(statusCode)."
        case .networkError(let error):
            "Network error: \(error.localizedDescription)."
        case .decodingError(let error):
            "Decoding error: \(error.localizedDescription)."
        }
    }
}
