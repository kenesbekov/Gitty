import SwiftUI

struct TabBarView: View {
    @EnvironmentObject private var appStateManager: AppStateManager

    var body: some View {
        TabView {
            RepositoriesView()
                .tabItem {
                    Label("Repos", systemImage: "square.stack")
                }

            UsersView()
                .tabItem {
                    Label("Users", systemImage: "person.circle")
                }
        }
    }
}
