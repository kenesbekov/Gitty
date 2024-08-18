//
//  HomeView.swift
//  Gitty
//
//  Created by Adam Kenesbekov on 17.08.2024.
//


import SwiftUI

struct TabBarView: View {
    @StateObject private var repositoriesViewModel: RepositoriesViewModel

    let api: GitHubAPI
    let repositoryHistory: RepositoryHistory
    let userHistory: UserHistory

    init(api: GitHubAPI, repositoryHistory: RepositoryHistory, userHistory: UserHistory) {
        self.api = api
        self.repositoryHistory = repositoryHistory
        self.userHistory = userHistory
        
        _repositoriesViewModel = StateObject(wrappedValue: RepositoriesViewModel(apiService: api, history: repositoryHistory))
    }

    @EnvironmentObject private var appStateManager: AppStateManager

    var body: some View {
        TabView {
            RepositoriesView(viewModel: repositoriesViewModel)
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
