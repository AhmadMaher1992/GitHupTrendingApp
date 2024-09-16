//
//  GitRepositoriesResponse.swift
//  GitHupTrendingApp
//
//  Created by Ahmad Eisa on 16/09/2024.
//

import Foundation

struct GithupRepo: Codable {
    let id: Int?
    let name: String?
    let owner: Owner?
    let description: String?
    let stargazers_count: Int?
    let language: String?
    let forks: Int?
    let created_at: String?
    let html_url: String?

   
}
struct Owner: Codable {
    let login: String?
    let avatar_url: String?
}
struct GitRepositoriesResponse: Codable {
    let items: [GithupRepo]?
}

