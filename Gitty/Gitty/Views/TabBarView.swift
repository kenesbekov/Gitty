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

    init(api: GitHubAPI, repositoryHistory: RepositoryHistory, userHistory: UserHistory) {
        self.api = api
        self.repositoryHistory = repositoryHistory
        self.userHistory = userHistory
    }

    @EnvironmentObject private var appStateManager: AppStateManager

    var body: some View {
        TabView {
            RepositoriesView()
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
