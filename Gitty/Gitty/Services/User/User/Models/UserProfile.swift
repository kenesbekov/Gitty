import Foundation

struct UserProfile: Identifiable, Codable, Hashable {
    typealias ID = Int

    let id: ID
    let login: String
    let avatarURL: URL
    let followers: Int
    let name: String?
    let bio: String?

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatarUrl"
        case followers
        case name
        case bio
    }
}
