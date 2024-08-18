import Foundation
import Security

enum KeychainError: Error {
    case unexpectedData
    case keychainError(status: OSStatus)
}


