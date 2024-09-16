//
//  JGProgressHUD+Extension.swift
//  GitHupTrendingApp
//
//  Created by Ahmad Eisa on 16/09/2024.
//

import UIKit
import JGProgressHUD
extension UIViewController{

    static let hud = JGProgressHUD(style: .dark)

    func showHUD(_ show: Bool , withText text: String? = "Loading..."){
        view.endEditing(true)

        UIViewController.hud.textLabel.text = text
        if show{
            UIViewController.hud.show(in: view)
        }else{
            UIViewController.hud.dismiss()
        }

    }
}
