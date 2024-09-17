//
//  UISearchBar+Extension.swift
//  GitHupTrendingApp
//
//  Created by Ahmad Eisa on 17/09/2024.
//

import Combine
import UIKit

extension UISearchBar {
    var textPublisher: AnyPublisher<String, Never> {
        NotificationCenter.default
            .publisher(for: UISearchTextField.textDidChangeNotification, object: self.searchTextField)
            .compactMap { ($0.object as? UISearchTextField)?.text }
            .eraseToAnyPublisher()
    }
}

