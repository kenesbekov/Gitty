import Foundation

struct GitHubUserSearchResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case items
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
    }

    let items: [GitHubUser]
    let totalCount: Int
    let incompleteResults: Bool
}
