//
//  HomeView.swift
//  Gitty
//
//  Created by Adam Kenesbekov on 17.08.2024.
//


import SwiftUI

struct TabBarView: View {
    let api: GitHubAPI
    let repositoryHistory: RepositoryHistory
    let userHistory: UserHistory

    @EnvironmentObject private var appStateManager: AppStateManager

    var body: some View {
        TabView {
            RepositoriesView(api: api, history: repositoryHistory)
                .environmentObject(appStateManager)
                .tabItem {
                    Label("Repos", systemImage: "square.stack")
                }

            UsersView(api: api, history: userHistory)
                .tabItem {
                    Label("Users", systemImage: "person.circle")
                }
        }
    }
}
