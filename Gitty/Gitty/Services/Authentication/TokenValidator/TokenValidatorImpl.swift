import Foundation

final class TokenValidatorImpl: TokenValidator {
    private let networkClient: NetworkClient = DependencyContainer.shared.resolve()

    func validate(_ token: String) async throws -> Bool {
        let endpoint = "/user"

        do {
            let _: UserProfile = try await networkClient.request(endpoint)
            return true
        } catch {
            return false
        }
    }
}
