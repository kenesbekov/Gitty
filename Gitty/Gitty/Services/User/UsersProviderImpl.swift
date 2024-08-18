import Foundation

final class UsersProviderImpl: UsersProvider {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkClientImpl()) {
        self.networkClient = networkClient
    }

    func get(matching query: String, page: Int, perPage: Int) async throws -> GetUsersResponse {
        let endpoint = "/search/users?q=\(query)&page=\(page)&per_page=\(perPage)"
        return try await networkClient.fetch(endpoint, method: "GET", body: nil, headers: nil, isOAuthRequest: false)
    }
}
