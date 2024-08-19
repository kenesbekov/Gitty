import Foundation
import Security

final class KeychainService: Sendable {
    static let shared = KeychainService()

    private let service = "com.kenesbekov.adam.gitty"
    private let account = "accessToken"

    private init() {}

    func saveToken(_ token: String) throws(KeychainError) {
        let data = token.data(using: .utf8)!

        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]

        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw .keychainError(status: status)
        }
    }

    func retrieveToken() throws(KeychainError) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status != errSecItemNotFound else {
            return nil
        }

        guard status == errSecSuccess else {
            throw .keychainError(status: status)
        }

        guard let data = dataTypeRef as? Data,
              let token = String(data: data, encoding: .utf8) else {
            throw .unexpectedData
        }

        return token
    }

    func deleteToken() throws(KeychainError) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]

        let status = SecItemDelete(query as CFDictionary)

        guard status == errSecSuccess || status == errSecItemNotFound else {
            throw .keychainError(status: status)
        }
    }
}
