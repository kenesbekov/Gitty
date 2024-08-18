import Foundation

protocol TokenValidator: AnyObject {
    func validate(_ token: String) async throws -> Bool
}
