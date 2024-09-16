//
//  UINavigationBar+Extension.swift
//  GitHupTrendingApp
//
//  Created by Ahmad Eisa on 16/09/2024.
//

import UIKit

extension UINavigationBar {
    func setupGitHubStyle() {
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            
            // GitHub-like dark gray background
            appearance.backgroundColor = AppColors.shadow_Steel_Color // GitHub dark theme color
            
            // Set title and large title text attributes
            appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
            // Set bar button item tint color
            UINavigationBar.appearance().tintColor = .white
            
            // Apply appearance settings
            self.standardAppearance = appearance
            self.scrollEdgeAppearance = appearance
            self.compactAppearance = appearance

            // Remove the back button text
            let backButtonAppearance = UIBarButtonItemAppearance()
            backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear, .font: UIFont(name: "Arial", size: 20)!]
            
            self.standardAppearance.backButtonAppearance = backButtonAppearance
            self.compactAppearance?.backButtonAppearance = backButtonAppearance
            self.scrollEdgeAppearance?.backButtonAppearance = backButtonAppearance
            
        } else {
            // iOS 12 and earlier
            UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000.0, vertical: 0.0), for: .default)
            
            // GitHub-like dark gray background for older versions
            UINavigationBar.appearance().barTintColor = UIColor(red: 36/255, green: 41/255, blue: 46/255, alpha: 1)
            
            // Set bar button item tint color
            UINavigationBar.appearance().tintColor = .white
        }
    }
}

