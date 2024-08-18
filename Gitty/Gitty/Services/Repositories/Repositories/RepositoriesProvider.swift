//
//  RepositoriesProvider.swift
//  Gitty
//
//  Created by Adam Kenesbekov on 18.08.2024.
//


protocol RepositoriesProvider: AnyObject {
    func get(
        matching query: String,
        sort: SortKind,
        order: OrderKind,
        page: Int,
        perPage: Int
    ) async throws -> [Repository]

    func get(
        userLogin: String,
        page: Int,
        perPage: Int
    ) async throws -> [Repository]
}
