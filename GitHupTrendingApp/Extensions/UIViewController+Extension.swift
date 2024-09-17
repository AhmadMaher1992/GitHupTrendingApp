//
//  UIViewController.swift
//  GitHupTrendingApp
//
//  Created by Ahmad Eisa on 16/09/2024.
//

import UIKit


extension UIViewController {
    
    func showToast(message: String) {
         let toastContainer = UIView(frame: CGRect())
         toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.8)
         toastContainer.alpha = 0.0
         toastContainer.layer.cornerRadius = 25;
         toastContainer.clipsToBounds  =  true
         
         let toastLabel = UILabel(frame: CGRect())
         toastLabel.textColor = UIColor.white
         toastLabel.textAlignment = .center;
         toastLabel.font.withSize(12.0)
         toastLabel.text = message
         toastLabel.clipsToBounds  =  true
         toastLabel.numberOfLines = 0
         
         toastContainer.addSubview(toastLabel)
         self.view.addSubview(toastContainer)
         
         toastLabel.translatesAutoresizingMaskIntoConstraints = false
         toastContainer.translatesAutoresizingMaskIntoConstraints = false
         
         let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
         let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
         let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
         let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
         toastContainer.addConstraints([a1, a2, a3, a4])
         
         let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 65)
         let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -65)
         let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -90)
         self.view.addConstraints([c1, c2, c3])
         
         UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
             toastContainer.alpha = 1.0
         }, completion: { _ in
             UIView.animate(withDuration: 0.5, delay: 1.0, options: .curveEaseOut, animations: {
                 toastContainer.alpha = 0.0
             }, completion: {_ in
                 toastContainer.removeFromSuperview()
             })
         })
     }
    
    
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


@available(iOS 9.0, *)
extension UIViewController {
    
    public func hideKeyboardWhenTappedAround()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        view.endEditing(true)
    }
}
