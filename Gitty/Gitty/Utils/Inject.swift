import SwiftUI

@propertyWrapper
struct Inject<T> {
    private var value: T

    init() {
        self.value = DependencyContainer.shared.resolve()
    }

    var wrappedValue: T {
        get { value }
        mutating set { value = newValue }
    }
}
