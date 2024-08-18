import SwiftUI

struct LoginView: View {
    private let clientID = "Ov23liKBw7Yddbu1ty8g"
    private let redirectURI = "gitty://oauth-callback"

    var body: some View {
        VStack {
            Text("Welcome to Gitty!")
                .font(.largeTitle)
                .padding()

            Button("Login with GitHub") {
                initiateGitHubLogin()
            }
            .padding()
        }
    }

    private func initiateGitHubLogin() {
        if let url = URL(string: "https://github.com/login/oauth/authorize?client_id=\(clientID)&redirect_uri=\(redirectURI)") {
            UIApplication.shared.open(url)
        }
    }
}
