import Foundation

protocol KeychainManager: AnyObject, Sendable {
    func saveToken(_ token: String) throws(KeychainError)
    func retrieveToken() throws(KeychainError) -> String?
    func deleteToken() throws(KeychainError)
}
