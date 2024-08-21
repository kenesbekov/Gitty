import Foundation

enum DependencyError: Error {
    case serviceNotFound(type: String)
}

final class DependencyContainer: Sendable {
    static let shared = DependencyContainer()

    private init() {}

    private let services = Atomic<[String: Any]>(with: [:])

    func register<T>(_ service: T, forType type: T.Type) {
        let newServices = services.value
        var updatedServices = newServices
        updatedServices[String(describing: type)] = service

        services.update(with: updatedServices)
    }

    func resolve<T>() -> T {
        guard let service = services.value[String(describing: T.self)] as? T else {
            fatalError("No registered service for type \(T.self)")
        }

        return service
    }

    func resolveWithThrowing<T>() throws(DependencyError) -> T {
        guard let service = services.value[String(describing: T.self)] as? T else {
            throw .serviceNotFound(type: "No registered service for type \(T.self)")
        }

        return service
    }
}
