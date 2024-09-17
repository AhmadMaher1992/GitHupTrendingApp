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
           
    }


    //------------------------------------------
    // MARK: - Helpers
    //------------------------------------------
    func setupNavigationBar() {
        // Set the navigation bar's tint color to white
           navigationController?.navigationBar.tintColor = .white
           // Optionally, customize the back button title (remove text or change it)
           navigationItem.backButtonTitle = "" // This removes the 'Back' text next to the arrow
        
    }
    func loadFavorites() {
          favorites = FavoritesManager.shared.getFavorites()
          tableView.reloadData()
      }
    
    func tableViewSetup(){
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.registerCell(cellClass: RepositoryCell.self)
    }
    
    // Check if the repository is already in favorites, if not, add it.
    private func toggleFavorite(for repository: GithupRepo ,indexPath: IndexPath) {
        if FavoritesManager.shared.isFavorite(repository) {
            //self.showAlert(message: "This repository is removed From favorites.")
            favorites.remove(at: indexPath.row)
            FavoritesManager.shared.removeFavorite(repository)
            self.tableView.reloadData()
        }
    }
}


//------------------------------------------
// MARK: - UITableViewDataSource
//------------------------------------------
extension FavoritesVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.showNoDataViewOnTableView(tableview: self.tableView, forItemsCount: favorites.count, title: TMText.No_Data_Found, backGroundColor: AppColors.ofWhite_Color)
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: RepositoryCell = tableView.dequeueCell()
        if let repository = favorites[safe: indexPath.row] {
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
            let repository = favorites[indexPath.row]
            FavoritesManager.shared.removeFavorite(repository)
            favorites.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

