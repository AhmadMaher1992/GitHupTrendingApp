//
//  BaseVC.swift
//  GitHupTrendingApp
//
//  Created by Ahmad Eisa on 17/09/2024.
//

import UIKit

class BaseVC: UIViewController {
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Monitor the network status
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(checkInternetStatus),
                                               name: .internetDisconnected,
                                               object: nil)
        
        loadData()
        
    }
    
    func loadData() {
            if Reachability.shared.isConnected {
                // Fetch data from the internet
            } else {
                // Show offline view controller
                showOfflineView()
            }
        }

        @objc func checkInternetStatus() {
            if !Reachability.shared.isConnected {
                showOfflineView()
            }
        }

        func showOfflineView() {
            let noInternetVC = NoInternetViewController()
            noInternetVC.modalPresentationStyle = .fullScreen
            present(noInternetVC, animated: true, completion: nil)
        }
    //remove observer at deinitialization
    deinit {
         NotificationCenter.default.removeObserver(self)
     }
}
