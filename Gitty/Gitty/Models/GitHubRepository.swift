import Foundation

struct GitHubRepository: Identifiable, Codable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case description
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case htmlURL = "html_url"
    }

    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let stargazersCount: Int
    let forksCount: Int
    let htmlURL: String
}
