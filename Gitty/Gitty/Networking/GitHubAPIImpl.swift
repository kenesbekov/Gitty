import Foundation

final class GitHubAPIImpl: GitHubAPI {
    private let clientID = "Ov23liKBw7Yddbu1ty8g"
    private let clientSecret = "cc04f9881b71ba8d8557c53141583a53c8527180"
    private let redirectURI = "gitty://oauth-callback"

    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = NetworkClientImpl()) {
        self.networkClient = networkClient
    }

    func validateToken(_ token: String) async throws -> Bool {
        let endpoint = "/user"
        let headers = ["Authorization": "token \(token)"]

        do {
            let _: GitHubUserProfile = try await networkClient.fetch(
                endpoint,
                method: "GET",
                body: nil,
                headers: headers,
                isOAuthRequest: false
            )
            return true
        } catch {
            return false
        }
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

    func searchRepositories(query: String, sort: SortOption, order: OrderOption, page: Int, perPage: Int) async throws -> [GitHubRepository] {
        let sortValue: String
        let orderValue: String

        switch sort {
        case .stars:
            sortValue = "stars"
        case .forks:
            sortValue = "forks"
        case .updated:
            sortValue = "updated"
        }

        switch order {
        case .ascending:
            orderValue = "asc"
        case .descending:
            orderValue = "desc"
        }

        let endpoint = "/search/repositories?q=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&sort=\(sortValue)&order=\(orderValue)&page=\(page)&per_page=\(perPage)"

        let response: GitHubRepositorySearchResponse = try await networkClient.fetch(
            endpoint,
            method: "GET",
            body: nil,
            headers: nil,
            isOAuthRequest: false
        )

        return response.items
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

        let bodyString = bodyComponents
            .map { "\($0.key)=\($0.value)" }
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

            try KeychainService.shared.saveToken(response.accessToken)
            return response.accessToken
        } catch {
            print("Failed to fetch access token: \(error.localizedDescription)")
            throw error
        }
    }

    func fetchGitHubUserProfile() async throws -> GitHubUserProfile {
        let accessToken = try KeychainService.shared.retrieveToken()

        guard let token = accessToken else {
            throw URLError(.userAuthenticationRequired)
        }

        // Validate the token
        let isValid = try await validateToken(token)
        if !isValid {
            try KeychainService.shared.deleteToken()
            throw URLError(.userAuthenticationRequired)
        }

        let endpoint = "/user"
        let headers = ["Authorization": "token \(token)"]
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

enum SortOption {
    case stars
    case forks
    case updated
}

enum OrderOption {
    case ascending
    case descending
}
