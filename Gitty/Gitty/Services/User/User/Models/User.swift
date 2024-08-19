import Foundation

struct User: Identifiable, Codable, Hashable {
    private enum CodingKeys: String, CodingKey {
       case login
       case id
       case avatarURL = "avatarUrl"
   }

    let login: String
    let id: Int
    let avatarURL: URL
    var followers: Int?
    var isViewed = false
}
