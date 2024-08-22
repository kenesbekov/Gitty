import Foundation

struct UserProfile: Identifiable, Codable, Hashable {
    typealias ID = Int

    private enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatarUrl"
        case followers
    }

    let id: ID
    let login: String
    let avatarURL: URL
    let followers: Int
}
