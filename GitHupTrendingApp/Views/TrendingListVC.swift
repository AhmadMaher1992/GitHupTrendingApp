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
            segmentedControl.thumbColor = AppColors.nav_Bar_COLOR
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
        
    }
    
    
    //------------------------------------------
    // MARK: - Helpers
    //------------------------------------------
    
    
    
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
    
    
    
}

enum Timeframe {
    case day, week, month
}
