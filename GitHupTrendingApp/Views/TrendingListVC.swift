//
//  ViewController.swift
//  GitHupTrendingApp
//
//  Created by Ahmad Eisa on 16/09/2024.
//

import UIKit

class TrendingListVC: UIViewController {
    
    //------------------------------------------
    // MARK: - properties
    //------------------------------------------
    
    private let viewModel = TrendingListViewModel()
    private var refreshControl: UIRefreshControl!
    private let searchController = UISearchController(searchResultsController: nil)
    var timeframe: Timeframe = .day // Set a default value
    
    
    //------------------------------------------
    // MARK: -IBOutlets
    //------------------------------------------
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: CustomSegment! {
        
        didSet
        {
            
            segmentedControl.backgroundColor = AppColors.disabled_Btn_Color
            segmentedControl.thumbColor = AppColors.shadow_Steel_Color
            segmentedControl.font = UIFont(name: "Avenir-Black", size: 12)
            segmentedControl.selectedLabelColor = .white
            segmentedControl.unselectedLabelColor = .black
            segmentedControl.padding = 0
            segmentedControl.selectedIndex = 0
            segmentedControl.addTarget(self, action: #selector(timeframeChanged(_:)), for: .valueChanged)
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
 
    
    
    //------------------------------------------
    // MARK: - Life Cycle
    //------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupSearchController()
        setupTableView()
        setupRefreshControl()
        dataBinding()
        self.hideKeyboardWhenTappedAround()
    }
    
    
    //------------------------------------------
    // MARK: - Helpers
    //------------------------------------------
    
    func dataBinding() {
        viewModel.$repositories
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }// to avoid retain cycle
                self.tableView.reloadData()
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                guard let self = self else { return }
                if let message = errorMessage {
                    self.showError(message: message)
                }
                self.refreshControl.endRefreshing()
                self.spinner.stopAnimating()
            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                guard let self = self else { return }
                self.showHUD(isLoading) // Show HUD during initial load and when switching segments

            }
            .store(in: &viewModel.cancellables)
        
        viewModel.$isPaginating
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isPaginating in
                guard let self = self else { return }
                if isPaginating {
                    self.spinner.startAnimating() // Show spinner during pagination
                } else {
                    self.spinner.stopAnimating()
                }
            }
            .store(in: &viewModel.cancellables)
        
        fetchRepositories() // Initial fetch
    }

    
   



    // handle segment actions
    
    @objc
    func timeframeChanged(_ sender: AnyObject?)
    {
        switch segmentedControl.selectedIndex
        {
        case 0 : timeframe = .day
        case 1: timeframe = .week
        case 2 : timeframe = .month
        default:
            break
        }
        resetPagination() // Reset pagination before fetching new data
        // Ensure the HUD is shown when switching segments
            viewModel.isInitialLoad = true
        fetchRepositories(timeframe: timeframe)
    }
    
    
    private func setupNavigationBar() {
        navigationItem.title = "Trending Repositories"
        // Set up the GitHub-style navigation bar
            navigationController?.navigationBar.setupGitHubStyle()
        setupFavoritesButton()
    }
    
    func setupFavoritesButton() {
        if let originalImage = UIImage(named: AppImages.filledStar)?.withRenderingMode(.alwaysOriginal) {
            // Resize the image to the desired size
            let resizedImage = resizeImage(image: originalImage, targetSize: CGSize(width: 24, height: 24))

            // Create the favorites button with the resized image
            let favoritesButton = UIBarButtonItem(image: resizedImage, style: .plain, target: self, action: #selector(favoritesButtonTapped))
            self.navigationItem.rightBarButtonItem = favoritesButton
        }
    }

    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: targetSize))
        }
        return resizedImage.withRenderingMode(.alwaysOriginal)  // Ensure it keeps its original colors
    }

    
    private func setupSearchController() {
        // Configure the search results updater and presentation settings
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Repositories"
        searchController.searchBar.barTintColor = .white
        
        // Customize the search bar appearance safely using public APIs
        let searchBar = searchController.searchBar
        searchBar.tintColor = .white // Sets the tint color for the cancel button and cursor
        
        // Access the search bar's text field safely
        if let searchTextField = searchController.searchBar.value(forKey: "searchField") as? UITextField{
            // Set text color and background color
            searchTextField.textColor = .white
            searchTextField.backgroundColor = AppColors.SpanichWhite
            
            // Customize the placeholder with attributed string
            searchTextField.attributedPlaceholder = NSAttributedString(
                string: "Search GitHub Repositories",
                attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
            )
            
            // Add corner radius to the text field
            searchTextField.layer.cornerRadius = 8.0
            searchTextField.clipsToBounds = true
            
            // Add padding for better spacing inside the text field
            searchTextField.leftView?.tintColor = .lightGray // Customize the search icon color
        }
        
        // Customize the appearance of the cancel button
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = AppColors.magnolia_Color
        
        // Apply global styles for text fields inside the search bar
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [
            NSAttributedString.Key.foregroundColor: AppColors.disable_btn_title_Color
        ]
        
        // Accessibility improvements
        searchBar.isAccessibilityElement = true
        searchBar.accessibilityTraits = .searchField
        searchBar.accessibilityLabel = "Search GitHub Repositories"
        
        // Add the search controller to the navigation bar
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        // Force layout updates for the search bar inside the navigation bar
        navigationItem.titleView?.layoutIfNeeded()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCell(cellClass: RepositoryCell.self)
        tableView.estimatedRowHeight = 100  // Provide an estimated row height
        tableView.rowHeight = UITableView.automaticDimension
    }
   
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshData() {

        resetPagination() // Reset pagination before fetching new data
        fetchRepositories(timeframe: timeframe)
    }
    
    // Function to reset pagination
    private func resetPagination() {
        viewModel.repositories.removeAll() // Clear current repositories
        viewModel.currentPage = 1 // Reset page counter
        viewModel.canLoadMorePages = true // Reset pagination flag
        
    }
    
    // Pagination logic
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        if offsetY > contentHeight - frameHeight * 2, !viewModel.isPaginating {
            // Load more repositories when reaching the bottom
            viewModel.fetchRepositories(timeframe: timeframe) {
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing() // Ensure UI updates on the main thread
                    self.spinner.stopAnimating()
                }
            }
        }
    }
   

    private func fetchRepositories(timeframe: Timeframe? = nil) {
        let selectedTimeframe = timeframe ?? .day
        print("DEBUG:☑️ URL String ☑️ \(selectedTimeframe)")
        viewModel.fetchRepositories(timeframe: selectedTimeframe, searchQuery: searchController.searchBar.text) {
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing() // Ensure UI updates on the main thread.
                self.spinner.stopAnimating()
            }
        }
    }

    @objc func favoritesButtonTapped() {
        print("DEBUG:☑️ Favorites button tapped ☑️")
        let vc = FavoritesVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}

//------------------------------------------
// MARK: - UITableViewDataSource
//------------------------------------------
extension TrendingListVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return viewModel.repositories.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell: RepositoryCell = tableView.dequeueCell()
        cell.delegate = self
        let repository = viewModel.repositories[indexPath.row]
        cell.configure(with: repository)
        return cell
    }
    
    
    
    
}

//------------------------------------------
// MARK: - UITableViewDelegate
//------------------------------------------
extension TrendingListVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Assuming you're inside the table view's didSelectRow method or some other action where you're presenting the view controller
        let repository = viewModel.repositories[indexPath.row] // Get the repository object

        // Instantiate GitRepoDetailsVC from the Main storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyboard.instantiateViewController(withIdentifier: "GitRepoDetailsVC") as? GitRepoDetailsVC {
            
            // Pass the repository object to the GitRepoDetailsVC
            detailVC.repository = repository
            
            // Present the view controller modally
            present(detailVC, animated: true, completion: nil)
        }


    }
    
}
extension TrendingListVC {
    
    private func showError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
//------------------------------------------
// MARK: - UISearchResultsUpdating
//------------------------------------------
extension TrendingListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        // Implement search logic here
        resetPagination() // Reset pagination before performing the search
        fetchRepositories(timeframe: timeframe) // Fetch repositories based on the search query
    }
    
    
    
}

//------------------------------------------
// MARK: - Handle Favourites Selection
//------------------------------------------
extension TrendingListVC: RepositoryCellDelegate {
    
    
    func onFavoriteTapped(repository: GithupRepo) {
        if FavoritesManager.shared.isFavorite(repository) {
            self.showToast(message: "This repository is removed From favorites.")
            FavoritesManager.shared.removeFavorite(repository)
        } else {
            FavoritesManager.shared.addToFavorites(repository)
            self.showToast(message: "Repository added to favorites!")
        }
    }
    
    
    
    
}

enum Timeframe {
    case day, week, month
}


