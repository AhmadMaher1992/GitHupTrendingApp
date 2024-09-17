//
//  FavoritesVC.swift
//  GitHupTrendingApp
//
//  Created by Ahmad Eisa on 17/09/2024.
//

import UIKit

class FavoritesVC: UIViewController {

    //------------------------------------------
    // MARK: - properties
    //------------------------------------------
    var favorites: [GithupRepo] = []
    var filteredFavorites: [GithupRepo] = [] // New array to store filtered results
    private var refreshControl: UIRefreshControl!
    private let searchController = UISearchController(searchResultsController: nil)
    
    
    //------------------------------------------
    // MARK: -IBOutlets
    //------------------------------------------
    
    @IBOutlet weak var tableView: UITableView!
    
    //------------------------------------------
    // MARK: - Life Cycle
    //------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewSetup()
        loadFavorites()
        setupNavigationBar()
        setupRefreshControl()
        setupSearchController()
    }


    //------------------------------------------
    // MARK: - Helpers
    //------------------------------------------
    func setupNavigationBar() {
        // Set the navigation bar's tint color to white
        navigationController?.navigationBar.tintColor = .white
        // Optionally, customize the back button title (remove text or change it)
        navigationItem.title = "Favourites Repositories"
        navigationItem.backButtonTitle = "" // This removes the 'Back' text next to the arrow
        
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Repositories"
        searchController.searchBar.barTintColor = .white
        
        let searchBar = searchController.searchBar
        searchBar.tintColor = .white
        
        if let searchTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            searchTextField.textColor = .white
            searchTextField.backgroundColor = AppColors.SpanichWhite
            searchTextField.attributedPlaceholder = NSAttributedString(
                string: "Search GitHub Repositories",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
            searchTextField.layer.cornerRadius = 8.0
            searchTextField.clipsToBounds = true
            searchTextField.leftView?.tintColor = .lightGray
        }
        
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = AppColors.magnolia_Color
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [
            NSAttributedString.Key.foregroundColor: AppColors.disable_btn_title_Color
        ]
        
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false // This ensures the search bar is always visible
        
        definesPresentationContext = true
        navigationItem.titleView?.layoutIfNeeded()
    }

    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshData() {

        loadFavorites()
        refreshControl.endRefreshing()  // Ensure refreshing stops once the data is reloaded
    }
    func loadFavorites() {
        DispatchQueue.main.async {
            self.favorites = FavoritesManager.shared.getFavorites()
            self.tableView.reloadData()

            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
        }
    }

    
    func tableViewSetup(){
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.registerCell(cellClass: RepositoryCell.self)
    }
    
    // Check if the repository is already in favorites, if not, add it.
    private func toggleFavorite(for repository: GithupRepo, indexPath: IndexPath) {
        if FavoritesManager.shared.isFavorite(repository) {
            // Remove from favorites manager
            FavoritesManager.shared.removeFavorite(repository)
            
            // Remove from the correct array (filtered or full favorites list)
            if isSearching() {
                // Remove from filteredFavorites
                if let index = filteredFavorites.firstIndex(where: { $0.id == repository.id }) {
                    filteredFavorites.remove(at: index)
                }
                
                // Also remove from the main favorites array
                if let index = favorites.firstIndex(where: { $0.id == repository.id }) {
                    favorites.remove(at: index)
                }
            } else {
                // Remove from the main favorites array when not searching
                favorites.remove(at: indexPath.row)
            }
            
            // Reload table data after deletion
            tableView.reloadData()
        }
    }

    private func isSearching() -> Bool {
        return !(searchController.searchBar.text?.isEmpty ?? true)
    }
}


//------------------------------------------
// MARK: - UITableViewDataSource
//------------------------------------------
extension FavoritesVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           let dataCount = isSearching() ? filteredFavorites.count : favorites.count
        let text = isSearching() ? TMText.No_Search_Result : TMText.No_Data_Found
        let type: NoDataViewType  = isSearching() ? .searchType : .standardType
        self.showNoDataViewOnTableView(tableview: self.tableView, forItemsCount:  dataCount , title: text, type:  type, backGroundColor:  AppColors.ofWhite_Color)
           return dataCount
       }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell: RepositoryCell = tableView.dequeueCell()
            let repository = isSearching() ? filteredFavorites[safe: indexPath.row] : favorites[safe: indexPath.row]
            if let repository = repository {
                cell.configure(with: repository)
                // Handle favorite button action
                cell.onFavoriteTapped = { [weak self] repo in
                    guard let self = self else { return } // to avoid retain cycle
                    self.toggleFavorite(for: repo ,indexPath: indexPath)
                }
            }
            return cell
        }
    
    
}

//------------------------------------------
// MARK: - UITableViewDelegate
//------------------------------------------
extension FavoritesVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Handle repository selection
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let repository: GithupRepo
            
            if isSearching() {
                // Use the filtered list during search
                repository = filteredFavorites[indexPath.row]
                
                // Remove from filteredFavorites
                filteredFavorites.remove(at: indexPath.row)
                
                // Also remove from the full favorites list
                if let index = favorites.firstIndex(where: { $0.id == repository.id }) {
                    favorites.remove(at: index)
                }
            } else {
                // Use the full favorites list when not searching
                repository = favorites[indexPath.row]
                favorites.remove(at: indexPath.row)
            }
            
            // Remove from favorites manager and update the table view
            FavoritesManager.shared.removeFavorite(repository)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

}


extension FavoritesVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
            guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
                filteredFavorites = favorites // If no search text, show all favorites
                tableView.reloadData()
                return
            }
            
            // Filter favorites based on the search text
            filteredFavorites = favorites.filter { repository in
                return repository.name?.lowercased().contains(searchText.lowercased()) ?? false ||
                       repository.owner?.login?.lowercased().contains(searchText.lowercased()) ?? false
            }
            
            tableView.reloadData()
        }
    
    
}
