//
//  HomeView.swift
//  Gitty
//
//  Created by Adam Kenesbekov on 17.08.2024.
//


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
