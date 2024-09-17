//
//  FavoritesViewModel.swift
//  GitHupTrendingApp
//
//  Created by Ahmad Eisa on 17/09/2024.
//

//import Foundation
//import Combine
//
//class FavoritesViewModel {
//    // Published properties to allow binding with the ViewController
//    @Published var favorites: [GithupRepo] = []
//    @Published var filteredFavorites: [GithupRepo] = []
//    @Published var isSearching: Bool = false
//    var searchText: String = ""
//    private var cancellables = Set<AnyCancellable>()
//    
//    init() {
//        loadFavorites()
//    }
//
//    func loadFavorites() {
//        favorites = FavoritesManager.shared.getFavorites()
//        filteredFavorites = favorites
//    }
//
//    // Filter repositories based on the search text
//    func filterFavorites(searchText: String?) {
//        guard let searchText = searchText, !searchText.isEmpty else {
//            // If search text is empty, show all favorites
//            filteredFavorites = favorites
//            return
//        }
//        filteredFavorites = favorites.filter { repository in
//            return repository.name?.lowercased().contains(searchText.lowercased()) ?? false ||
//                   repository.owner?.login?.lowercased().contains(searchText.lowercased()) ?? false
//        }
//    }
//
//    // Toggle the favorite status of a repository
//    func toggleFavorite(for repository: GithupRepo) {
//        if FavoritesManager.shared.isFavorite(repository) {
//            FavoritesManager.shared.removeFavorite(repository)
//            // Remove the repository from the main list and filtered list
//            favorites.removeAll { $0.id == repository.id }
//            filteredFavorites.removeAll { $0.id == repository.id }
//        }
//    }
//}

import Foundation
import Combine

class FavoritesViewModel {
    @Published var favorites: [GithupRepo] = []         // All favorites
    @Published var filteredFavorites: [GithupRepo] = []  // Filtered list based on search text
    @Published var isSearching: Bool = false             // Flag for search state
    @Published var noDataText: String = ""               // Text for 'No Data' view
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadFavorites()  // Load favorites on initialization
    }
    
    // Load favorites from the FavoritesManager
    func loadFavorites() {
        favorites = FavoritesManager.shared.getFavorites()
        updateFilteredFavorites()  // Filter the results initially
        updateNoDataText()  // Update the 'No Data' view text
    }
    
    // Filter favorites based on search text
    func filterFavorites(searchText: String?) {
        guard let searchText = searchText, !searchText.isEmpty else {
            updateFilteredFavorites()  // Show all favorites if no search text
            updateNoDataText()  // Update 'No Data' text
            return
        }
        
        isSearching = true
        filteredFavorites = favorites.filter { repository in
            repository.name?.lowercased().contains(searchText.lowercased()) ?? false ||
            repository.owner?.login?.lowercased().contains(searchText.lowercased()) ?? false
        }
        updateNoDataText()  // Update 'No Data' view based on filtered result
    }
    
    // Update filteredFavorites based on the current favorites
    private func updateFilteredFavorites() {
        filteredFavorites = isSearching ? filteredFavorites : favorites
    }
    
    // Update the 'No Data' text
    private func updateNoDataText() {
        if filteredFavorites.isEmpty {
            noDataText = isSearching ? TMText.No_Search_Result : TMText.No_Data_Found
        } else {
            noDataText = ""
        }
    }

    // Toggle favorite (add/remove)
    func toggleFavorite(for repository: GithupRepo) {
        if FavoritesManager.shared.isFavorite(repository) {
            FavoritesManager.shared.removeFavorite(repository)
            favorites.removeAll { $0.id == repository.id }
        } else {
            FavoritesManager.shared.addToFavorites(repository)
            favorites.append(repository)
        }
        updateFilteredFavorites()
        updateNoDataText()
    }
    
    // Remove favorite directly
    func removeFavorite(at index: Int, isFiltered: Bool) {
        let repoToRemove = isFiltered ? filteredFavorites[index] : favorites[index]
        FavoritesManager.shared.removeFavorite(repoToRemove)
        favorites.removeAll { $0.id == repoToRemove.id }
        filteredFavorites.removeAll { $0.id == repoToRemove.id }
        updateNoDataText()  // Update no data view after deletion
    }
}
