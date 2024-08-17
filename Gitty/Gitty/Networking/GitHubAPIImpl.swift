import Foundation

final class GitHubAPIImpl: GitHubAPI {
    private let clientID = "Ov23liKBw7Yddbu1ty8g"
    private let clientSecret = "cc04f9881b71ba8d8557c53141583a53c8527180"
    private let redirectURI = "gitty://oauth-callback"

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkClientImpl()) {
        self.networkClient = networkClient
    }

    func searchUsers(query: String, page: Int, perPage: Int) async throws -> GitHubUserSearchResponse {
        let endpoint = "/search/users?q=\(query)&page=\(page)&per_page=\(perPage)"
        return try await networkClient.fetch(endpoint, method: "GET", body: nil, headers: nil, isOAuthRequest: false)
    }

    func fetchUserProfile(for user: GitHubUser) async throws -> GitHubUserProfile {
        let endpoint = "/users/\(user.login)"
        let userProfile: GitHubUserProfile = try await networkClient.fetch(
            endpoint,
            method: "GET",
            body: nil,
            headers: nil,
            isOAuthRequest: false
        )
        return userProfile
    }

    func fetchUserRepositories(user: GitHubUserProfile) async throws -> [GitHubRepository] {
        let endpoint = "/users/\(user.login)/repos"
        return try await networkClient.fetch(endpoint, method: "GET", body: nil, headers: nil, isOAuthRequest: false)
    }

    func searchRepositories(query: String, page: Int, perPage: Int) async throws -> [GitHubRepository] {
        let endpoint = "/search/repositories?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&page=\(page)&per_page=\(perPage)"
        let response: GitHubRepositorySearchResponse = try await networkClient.fetch(
            endpoint,
            method: "GET",
            body: nil,
            headers: nil,
            isOAuthRequest: false
        )
        return response.items
    }


    func fetchAccessToken(authorizationCode: String) async throws -> String {
        let endpoint = "/login/oauth/access_token"
        let bodyComponents = [
            "client_id": clientID,
            "client_secret": clientSecret,
            "code": authorizationCode,
            "redirect_uri": redirectURI
        ]

        let bodyString = bodyComponents.map { "\($0.key)=\($0.value)" }
                                        .joined(separator: "&")
        guard let body = bodyString.data(using: .utf8) else {
            throw URLError(.cannotParseResponse)
        }

        let headers = [
            "Content-Type": "application/x-www-form-urlencoded"
        ]

        do {
            let response: OAuthTokenResponse = try await networkClient.fetch(
                endpoint,
                method: "POST",
                body: body,
                headers: headers,
                isOAuthRequest: true
            )

            return response.accessToken

        } catch {
            print("Failed to fetch access token: \(error.localizedDescription)")
            throw error
        }
    }

    func fetchGitHubUserProfile(accessToken: String) async throws -> GitHubUserProfile {
        let endpoint = "/user"
        let headers = ["Authorization": "token \(accessToken)"]
        let userProfile: GitHubUserProfile = try await networkClient.fetch(
            endpoint,
            method: "GET",
            body: nil,
            headers: headers,
            isOAuthRequest: false
        )
        return userProfile
    }
}
