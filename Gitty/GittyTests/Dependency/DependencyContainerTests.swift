import Foundation
import Testing
@testable import Gitty

struct DependencyContainerTests {
    let dependencyContainer: DependencyContainer

    struct MockService {
        let id = UUID()
    }

    init() {
        dependencyContainer = DependencyContainer.shared
    }

    @Test("Ensure that a service can be registered and resolved correctly")
    func testServiceRegistrationAndResolution() {
        let mockService = MockService()
        dependencyContainer.register(mockService, forType: MockService.self)

        let resolvedService: MockService = dependencyContainer.resolve()

        #expect(resolvedService.id == mockService.id)
    }

    @Test("Ensure that resolving an unregistered service throws an error")
    func testUnregisteredServiceResolution() {
        do {
            let _: MockService = try dependencyContainer.resolveWithThrowing()
        } catch DependencyError.serviceNotFound(let type) {
            #expect(type == "No registered service for type MockService")
        } catch {} // seems like swift 6.0 bug, can't write without catch {}
    }

    @Test("Ensure that a previously registered service can be replaced")
    func testServiceReplacement() {
        let firstMockService = MockService()
        let secondMockService = MockService()

        dependencyContainer.register(firstMockService, forType: MockService.self)
        dependencyContainer.register(secondMockService, forType: MockService.self)

        let resolvedService: MockService = dependencyContainer.resolve()

        #expect(resolvedService.id == secondMockService.id)
    }
}
