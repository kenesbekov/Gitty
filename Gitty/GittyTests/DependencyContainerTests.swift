import Foundation
import Testing
@testable import Gitty

@Suite
struct DependencyContainerTests {
    var dependencyContainer: DependencyContainer!

    struct MockService {
        let id = UUID()
    }

    init() {
        dependencyContainer = DependencyContainer.shared
    }

    @Test("Service can be registered and resolved correctly")
    func serviceRegistrationAndResolution() {
        let mockService = MockService()
        dependencyContainer.register(mockService, forType: MockService.self)

        let resolvedService: MockService = dependencyContainer.resolve()

        #expect(resolvedService.id == mockService.id)
    }

    @Test("Resolving an unregistered service throws an error")
    func UnregisteredServiceResolution() {
        do {
            let _: MockService = try dependencyContainer.resolveWithThrowing()
        } catch DependencyError.serviceNotFound(let type) {
            #expect(type == "No registered service for type MockService")
        } catch {}
    }

    @Test("Previously registered service can be replaced")
    func serviceReplacement() {
        let firstMockService = MockService()
        let secondMockService = MockService()

        dependencyContainer.register(firstMockService, forType: MockService.self)
        dependencyContainer.register(secondMockService, forType: MockService.self)

        let resolvedService: MockService = dependencyContainer.resolve()

        #expect(resolvedService.id == secondMockService.id)
    }
}

// MARK: - Mock Services

struct AnotherMockService {
    let id = UUID()
}
