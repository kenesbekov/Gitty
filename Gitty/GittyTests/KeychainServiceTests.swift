import XCTest
@testable import Gitty

final class KeychainServiceTests: XCTestCase {
    
    func testSaveToken() {
        let keychainService = KeychainService.shared
        let token = "sampleToken"
        
        XCTAssertNoThrow(try keychainService.saveToken(token))
        
        let retrievedToken = try? keychainService.retrieveToken()
        XCTAssertEqual(retrievedToken, token)
    }
    
    func testRetrieveToken() {
        let keychainService = KeychainService.shared
        let token = "sampleToken"
        
        try? keychainService.saveToken(token)
        
        let retrievedToken = try? keychainService.retrieveToken()
        XCTAssertEqual(retrievedToken, token)
    }
    
    func testDeleteToken() {
        let keychainService = KeychainService.shared
        let token = "sampleToken"
        
        try? keychainService.saveToken(token)
        try? keychainService.deleteToken()
        
        let retrievedToken = try? keychainService.retrieveToken()
        XCTAssertNil(retrievedToken)
    }
}
