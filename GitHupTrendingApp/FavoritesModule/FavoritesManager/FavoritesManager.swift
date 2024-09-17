//
//  FavoritesManager.swift
//  GitHupTrendingApp
//
//  Created by Ahmad Eisa on 17/09/2024.
//

import Foundation

class FavoritesManager {
    static let shared = FavoritesManager()
    private let favoritesKey = "FavoriteRepositories"
    
    private init() {}

    func addToFavorites(_ repository: GithupRepo) {
        var favorites = getFavorites()
        favorites.append(repository)
        saveFavorites(favorites)
    }

    func isFavorite(_ repository: GithupRepo) -> Bool {
        return getFavorites().contains(where: { $0.id == repository.id })
    }

    func getFavorites() -> [GithupRepo] {
        if let data = UserDefaults.standard.data(forKey: favoritesKey),
           let favorites = try? JSONDecoder().decode([GithupRepo].self, from: data) {
            return favorites
        }
        return []
    }

    func saveFavorites(_ repositories: [GithupRepo]) {
        if let data = try? JSONEncoder().encode(repositories) {
            UserDefaults.standard.set(data, forKey: favoritesKey)
        }
    }

    func removeFavorite(_ repository: GithupRepo) {
        var favorites = getFavorites()
        favorites.removeAll { $0.id == repository.id }
        saveFavorites(favorites)
    }
}

