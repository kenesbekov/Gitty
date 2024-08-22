import Foundation

protocol AccessTokenProvider: AnyObject, Sendable {
    func get(for authorizationCode: String) async throws
}
