import Foundation

final class Atomic<Value>: @unchecked Sendable {
    var value: Value {
        lock.critical { _value }
    }

    private let lock = UnfairLock()

    private var _value: Value

    init(with value: Value) {
        self._value = value
    }

    func update(with value: Value) {
        lock.critical { _value = value }
    }
}
