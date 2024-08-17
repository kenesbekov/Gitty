import Foundation

struct GitHubUserProfile: Identifiable, Codable, Hashable {
    let id: Int
    let login: String
    let avatarURL: String
    let url: String
    let htmlURL: String
    let followers: Int
    let following: Int
    let name: String?
    let bio: String?

    enum CodingKeys: String, CodingKey {
        case id
        case login
        case avatarURL = "avatar_url"
        case url
        case htmlURL = "html_url"
        case followers
        case following
        case name
        case bio
    }
}
