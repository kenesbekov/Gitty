import XCTest
@testable import Gitty

class GitHubAPITests: XCTestCase {
    var api: GitHubAPI!

    override func setUp() {
        super.setUp()
        api = GitHubAPIImpl()
    }

    func testFetchAccessToken() {
        let expectation = self.expectation(description: "Fetch access token")
        api.fetchAccessToken(authorizationCode: "test_code") { result in
            switch result {
            case .success(let token):
                XCTAssertFalse(token.isEmpty)
            case .failure(let error):
                XCTFail("Error fetching access token: \(error)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    // Add more tests as needed
}
