import Foundation

protocol AccessTokenProvider: AnyObject {
    func get(for authorizationCode: String) async throws
}
