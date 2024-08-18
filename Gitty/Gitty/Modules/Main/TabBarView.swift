import SwiftUI

struct TabBarView: View {
    @EnvironmentObject private var appStateManager: AppStateManager

    var body: some View {
        TabView {
            RepositoriesView()
                .environmentObject(appStateManager)
                .tabItem {
                    Label("Repos", systemImage: "square.stack")
                }

            UsersView()
                .tabItem {
                    Label("Users", systemImage: "person.2.fill")
                }
        }
    }
}
