import Foundation

protocol TokenValidator: AnyObject, Sendable {
    func validate(_ token: String) async throws -> Bool
}
