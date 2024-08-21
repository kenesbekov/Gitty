import Testing
@testable import Gitty

struct KeychainManagerTests {
    let token = "sampleToken"
    let keychainManager = KeychainManagerImpl()

    @Test("Save and retrieve token")
    func saveAndRetrieveToken() {
        try? keychainManager.saveToken(token)

        let retrievedToken = try? keychainManager.retrieveToken()
        #expect(retrievedToken == token)
    }

    @Test("Delete token")
    func deleteToken() {
        try? keychainManager.saveToken(token)
        try? keychainManager.deleteToken()

        let retrievedToken = try? keychainManager.retrieveToken()

        #expect(retrievedToken == nil)
    }
}
