import Foundation

@MainActor
protocol AppStateManager: ObservableObject {
    func logout()
}
