import Testing
@testable import Gitty

struct KeychainServiceTests {
    let token = "sampleToken"
    let keychainService = KeychainService.shared

    func testSaveAndRetrieveToken() {
        try? keychainService.saveToken(token)

        let retrievedToken = try? keychainService.retrieveToken()
        #expect(retrievedToken == token)
    }

    func testDeleteToken() {
        try? keychainService.saveToken(token)
        try? keychainService.deleteToken()

        let retrievedToken = try? keychainService.retrieveToken()

        #expect(retrievedToken == nil)
    }
}
