//
//  HomeView.swift
//  Gitty
//
//  Created by Adam Kenesbekov on 17.08.2024.
//


import SwiftUI

struct HomeView: View {
    let api: GitHubAPI
    let repositoryHistory: RepositoryHistory
    let userHistory: UserHistory

    @EnvironmentObject private var appRouter: AppRouter

    var body: some View {
        TabView {
            RepositorySearchView(api: api, history: repositoryHistory)
                .tabItem {
                    Label("Repositories", systemImage: "archivebox")
                }

            UserSearchView(api: api, history: userHistory)
                .tabItem {
                    Label("Users", systemImage: "person.3")
                }
        }
    }
}
