import Foundation

struct UserProfile: Identifiable, Codable, Hashable {
    let id: Int
    let login: String
    let avatarURL: String
    let url: String
    let htmlURL: String
    let followers: Int
    let name: String?
    let bio: String?

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatarUrl"
        case url
        case htmlURL = "htmlUrl"
        case followers
        case name
        case bio
    }
}
