import Foundation

protocol AuthorizationURLProvider: AnyObject, Sendable {
    func get() -> URL?
}
