import Foundation

final class DependencyContainer {
    static let shared = DependencyContainer()

    private init() {}

    private var services: [String: Any] = [:]

    func register<T>(_ service: T, forType type: T.Type) {
        services[String(describing: type)] = service
    }

    func resolve<T>() -> T {
        guard let service = services[String(describing: T.self)] as? T else {
            fatalError("No registered service for type \(T.self)")
        }
        return service
    }
}
