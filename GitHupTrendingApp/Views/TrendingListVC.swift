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
    
    
    
    //------------------------------------------
    // MARK: -IBOutlets
    //------------------------------------------
    
    
    
    
    
    //------------------------------------------
    // MARK: - Life Cycle
    //------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupSearchController()
    }
    
    
    //------------------------------------------
    // MARK: - Helpers
    //------------------------------------------
    
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


    @objc func favoritesButtonTapped() {
        print("Favorites button tapped")
        
        
    }
    
    
}


//------------------------------------------
// MARK: - UISearchResultsUpdating
//------------------------------------------
extension TrendingListVC: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
            // Implement search logic here
            // For example, filter the repositories based on searchController.searchBar.text
        }
    
    
    
}

enum Timeframe {
    case day, week, month
}
