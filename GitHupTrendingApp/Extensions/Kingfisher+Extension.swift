//
//  Kingfisher+Extension.swift
//  GitHupTrendingApp
//
//  Created by Ahmad Eisa on 16/09/2024.
//

import UIKit
import Kingfisher

extension UIImageView {
    func setImage(with urlString: String?, placeholder: UIImage? = UIImage(systemName: AppImages.placeholder)?.withRenderingMode(.alwaysOriginal)) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            self.image = placeholder
            return
        }
        
        let options: KingfisherOptionsInfo = [.transition(.fade(0.2))]
        self.kf.indicatorType = .activity
        self.kf.setImage(with: url, placeholder: placeholder, options: options)
    }
}

