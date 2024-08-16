import Foundation

struct GitHubUserProfile: Decodable {
    let login: String
    let id: Int
    let avatar_url: String
}
