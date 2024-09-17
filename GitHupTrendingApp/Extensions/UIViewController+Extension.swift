//
//  UIViewController.swift
//  GitHupTrendingApp
//
//  Created by Ahmad Eisa on 16/09/2024.
//

import UIKit


extension UIViewController {
    
    func presentViewController( storyboard: String , viewController: String){
        let storyboard = UIStoryboard.init(name: storyboard, bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: viewController)
        present(controller, animated: true, completion: nil)
    }
    
    
     func showAlert(message: String) {
        let alert = UIAlertController(title: "Favorites", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func simpleAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    //for table view
    func showNoDataViewOnTableView(tableview: UITableView, forItemsCount count: Int, title: String, details: String = "", type: NoDataViewType = .standardType, backGroundColor: UIColor) {
        if count == 0 {
            let noDataView  = NoDataView(frame: CGRect(x: 0, y: 0, width: tableview.bounds.size.width, height: tableview.bounds.size.height))
            noDataView.setViewDetails(title, details, type, backGroundColor)
            tableview.backgroundView  = noDataView
            tableview.separatorStyle  = .none
        } else {
            tableview.backgroundView = nil
        }
    }
}
