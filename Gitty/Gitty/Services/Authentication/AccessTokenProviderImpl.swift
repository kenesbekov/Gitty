//
//  AccessTokenProviderImpl.swift
//  Gitty
//
//  Created by Adam Kenesbekov on 18.08.2024.
//

import Foundation

final class AccessTokenProviderImpl: AccessTokenProvider {
    private let clientID = "Ov23liKBw7Yddbu1ty8g"
    private let clientSecret = "cc04f9881b71ba8d8557c53141583a53c8527180"
    private let redirectURI = "gitty://oauth-callback"

    @Injected private var networkClient: NetworkClient

    func get(for authorizationCode: String) async throws {
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

        let headers = ["Content-Type": "application/x-www-form-urlencoded"]

        do {
            let response: OAuthTokenResponse = try await networkClient.fetch(
                endpoint,
                method: "POST",
                body: body,
                headers: headers,
                isOAuthRequest: true
            )
            try KeychainService.shared.saveToken(response.accessToken)
        } catch {
            print("Failed to fetch access token: \(error.localizedDescription)")
            throw error
        }
    }
}
