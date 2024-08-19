import Foundation

protocol OAuthHandler: AnyObject, Sendable {
    func handleOAuthCallback(url: URL, appStateManager: AppStateManager)
}
