import Foundation

struct Repository: Identifiable, Codable, Sendable, Hashable {
    typealias ID = Int

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case owner
        case stargazersCount
        case forksCount
        case htmlURL = "htmlUrl"
        case updatedAt
    }

    let id: ID
    let name: String
    let description: String?
    let stargazersCount: Int
    let forksCount: Int
    let owner: User
    let updatedAt: Date
    let htmlURL: URL
    var isViewed = false

    init(
        id: ID,
        name: String,
        description: String?,
        stargazersCount: Int,
        forksCount: Int,
        owner: User,
        updatedAt: Date,
        htmlURL: URL
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.stargazersCount = stargazersCount
        self.forksCount = forksCount
        self.owner = owner
        self.updatedAt = updatedAt
        self.htmlURL = htmlURL
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(ID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        stargazersCount = try container.decode(Int.self, forKey: .stargazersCount)
        forksCount = try container.decode(Int.self, forKey: .forksCount)
        owner = try container.decode(User.self, forKey: .owner)
        htmlURL = try container.decode(URL.self, forKey: .htmlURL)

        let dateString = try container.decode(String.self, forKey: .updatedAt)
        let formatter = ISO8601DateFormatter()
        updatedAt = formatter.date(from: dateString) ?? Date()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(owner, forKey: .owner)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encode(stargazersCount, forKey: .stargazersCount)
        try container.encode(forksCount, forKey: .forksCount)
        try container.encode(htmlURL, forKey: .htmlURL)

        let formatter = ISO8601DateFormatter()
        let dateString = formatter.string(from: updatedAt)
        try container.encode(dateString, forKey: .updatedAt)
    }
}
