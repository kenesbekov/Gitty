import Foundation

struct GitHubUser: Identifiable, Codable, Hashable {
    private enum CodingKeys: String, CodingKey {
       case login
       case id
       case avatarURL = "avatar_url"
   }

    let login: String
    let id: Int
    let avatarURL: URL
    var followers: Int?
}
