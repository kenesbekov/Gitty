import XCTest
@testable import Gitty

class OAuthFlowTests: XCTestCase {
    var api: GitHubAPI!
    var history: RepositoryHistory!

    override func setUp() {
        super.setUp()
        api = GitHubAPIImpl()
        history = RepositoryHistoryImpl()
    }

    func testOAuthFlow() {
        // Simulate OAuth flow and validate
    }
    
    // Add more tests as needed
}
