import Foundation

struct GetUsersResponse: Decodable {
    private enum CodingKeys: String, CodingKey {
        case items
        case totalCount = "total_count"
        case incompleteResults = "incomplete_results"
    }

    let items: [User]
    let totalCount: Int
    let incompleteResults: Bool
}
