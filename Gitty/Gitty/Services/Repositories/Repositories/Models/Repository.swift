import Foundation

struct Repository: Identifiable, Codable, Sendable, Hashable {
    typealias ID = Int

    private enum CodingKeys: String, CodingKey {
        case description
        case forksCount
        case htmlURL = "htmlUrl"
        case id
        case language
        case name
        case openIssuesCount
        case owner
        case stargazersCount
        case updatedAt
        case watchersCount
    }

    let id: ID
    let name: String
    let description: String?
    let forksCount: Int
    let htmlURL: URL
    let language: String?
    let openIssuesCount: Int
    let owner: User
    let stargazersCount: Int
    let updatedAt: Date
    let watchersCount: Int
    var isViewed = false

    init(
        id: ID,
        name: String,
        description: String?,
        forksCount: Int,
        htmlURL: URL,
        language: String?,
        openIssuesCount: Int,
        owner: User,
        stargazersCount: Int,
        updatedAt: Date,
        watchersCount: Int
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.forksCount = forksCount
        self.htmlURL = htmlURL
        self.language = language
        self.openIssuesCount = openIssuesCount
        self.owner = owner
        self.stargazersCount = stargazersCount
        self.updatedAt = updatedAt
        self.watchersCount = watchersCount
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(ID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        forksCount = try container.decode(Int.self, forKey: .forksCount)
        htmlURL = try container.decode(URL.self, forKey: .htmlURL)
        language = try container.decodeIfPresent(String.self, forKey: .language)
        openIssuesCount = try container.decode(Int.self, forKey: .openIssuesCount)
        owner = try container.decode(User.self, forKey: .owner)
        stargazersCount = try container.decode(Int.self, forKey: .stargazersCount)
        watchersCount = try container.decode(Int.self, forKey: .watchersCount)

        let dateString = try container.decode(String.self, forKey: .updatedAt)
        let formatter = ISO8601DateFormatter()
        updatedAt = formatter.date(from: dateString) ?? Date()
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(description, forKey: .description)
        try container.encode(forksCount, forKey: .forksCount)
        try container.encode(htmlURL, forKey: .htmlURL)
        try container.encodeIfPresent(language, forKey: .language)
        try container.encode(openIssuesCount, forKey: .openIssuesCount)
        try container.encode(owner, forKey: .owner)
        try container.encode(stargazersCount, forKey: .stargazersCount)
        try container.encode(watchersCount, forKey: .watchersCount)

        let formatter = ISO8601DateFormatter()
        let dateString = formatter.string(from: updatedAt)
        try container.encode(dateString, forKey: .updatedAt)
    }
}
