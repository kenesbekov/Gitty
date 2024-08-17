import Foundation

struct GitHubRepository: Identifiable, Codable, Hashable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case description
        case owner
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case htmlURL = "html_url"
        case updatedAt = "updated_at"
    }

    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let stargazersCount: Int
    let owner: GitHubUser
    let updatedAt: Date
    let forksCount: Int
    let htmlURL: URL

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        fullName = try container.decode(String.self, forKey: .fullName)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        stargazersCount = try container.decode(Int.self, forKey: .stargazersCount)
        owner = try container.decode(GitHubUser.self, forKey: .owner)
        forksCount = try container.decode(Int.self, forKey: .forksCount)
        htmlURL = try container.decode(URL.self, forKey: .htmlURL)

        let dateString = try container.decode(String.self, forKey: .updatedAt)
        let formatter = ISO8601DateFormatter()
        updatedAt = formatter.date(from: dateString) ?? Date()
    }
}
