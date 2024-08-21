import Foundation

enum DependencyError: Error {
    case serviceNotFound(type: String)
}
