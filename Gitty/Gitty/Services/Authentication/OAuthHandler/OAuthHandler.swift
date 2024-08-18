import Foundation

protocol OAuthHandler {
    func handleOAuthCallback(url: URL, appStateManager: AppStateManager)
}
