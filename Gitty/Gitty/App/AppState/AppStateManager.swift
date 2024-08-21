import Foundation

@MainActor
protocol AppStateManager: ObservableObject, Sendable {
    func logout()
}
