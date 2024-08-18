import SwiftUI

struct LoginView: View {
    private var authorizationURL: URL? {
        var components = URLComponents(string: "https://github.com/login/oauth/authorize")
        components?.queryItems = [
            URLQueryItem(name: "client_id", value: Constants.clientID),
            URLQueryItem(name: "redirect_uri", value: Constants.redirectURI)
        ]
        return components?.url
    }

    var body: some View {
        VStack {
            Spacer()

            ZStack {
                RadialGradient(
                    colors: [Color.accentColor, Color.clear],
                    center: .center,
                    startRadius: 0,
                    endRadius: 120
                )
                .frame(height: 240)
                .clipShape(.circle)

                Image(systemName: "person.3")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60)
                    .padding(.bottom, 20)
            }

            Text("Welcome to Gitty!")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)

            Text("Log in with your GitHub account to get started.")
                .font(.headline)
                .padding(.horizontal, 40)
                .multilineTextAlignment(.center)
                .padding(.bottom, 40)

            Button(action: initiateGitHubLogin) {
                Text("Login with GitHub")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(20)
                    .shadow(radius: 10)
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 20)

            Spacer()
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }

    private func initiateGitHubLogin() {
        guard let url = authorizationURL else {
            print("Invalid URL")
            return
        }
        UIApplication.shared.open(url)
    }
}

#Preview {
    LoginView()
}
