import Foundation

struct User: Identifiable, Codable, Sendable, Hashable {
    typealias ID = Int

    private enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatarUrl"
        case htmlURL = "htmlUrl"
   }

    let id: ID
    let login: String
    let avatarURL: URL
    let htmlURL: URL
    var followers: Int?
    var isViewed = false
}
