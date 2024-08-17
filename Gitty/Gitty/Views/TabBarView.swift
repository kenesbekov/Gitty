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

    var body: some View {
        TabView {
            RepositoriesView(api: api, history: repositoryHistory)
                .tabItem {
                    Label("Repositories", systemImage: "square.stack")
                }

            UsersView(api: api, history: userHistory)
                .tabItem {
                    Label("Users", systemImage: "person.circle")
                }
        }
    }
}
