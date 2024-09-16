//
//  UILabel+Extensions.swift
//  GitHupTrendingApp
//
//  Created by Ahmad Eisa on 17/09/2024.
//

import UIKit

extension UILabel {
    // Function to set URL with bottom border but no underline
    func setURLWithBottomBorder(url: String, font: UIFont = UIFont.systemFont(ofSize: 16), textColor: UIColor = .black) {
        // Set the attributed text with color but no underline
        let attributedString = NSMutableAttributedString(string: url)
        attributedString.addAttributes([.font: font], range: NSRange(location: 0, length: url.count))
        attributedString.addAttributes([.foregroundColor: textColor], range: NSRange(location: 0, length: url.count))
        
        self.attributedText = attributedString
        
        // Add a black bottom border
        addBottomBorder(borderColor: .black, borderWidth: 2.0)
    }
    
    // Helper function to add a black bottom border to the label
    private func addBottomBorder(borderColor: UIColor, borderWidth: CGFloat) {
        // Remove existing border if already added
        self.subviews.filter { $0.tag == 9999 }.forEach { $0.removeFromSuperview() }

        let bottomLine = UIView()
        bottomLine.tag = 9999 // Unique tag to identify the line
        bottomLine.translatesAutoresizingMaskIntoConstraints = false
        bottomLine.backgroundColor = borderColor
        self.addSubview(bottomLine)
        
        // Set constraints for the bottom border
        NSLayoutConstraint.activate([
            bottomLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            bottomLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            bottomLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomLine.heightAnchor.constraint(equalToConstant: borderWidth)
        ])
    }
    
    // Function to set URL with underline (no bottom border)
        func setURLWithUnderline(url: String, font: UIFont = UIFont.systemFont(ofSize: 16), textColor: UIColor = .blue) {
            // Set the attributed text with underline and color
            let attributedString = NSMutableAttributedString(string: url)
            attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: url.count))
            attributedString.addAttributes([.font: font], range: NSRange(location: 0, length: url.count))
            attributedString.addAttributes([.foregroundColor: textColor], range: NSRange(location: 0, length: url.count))
            
            self.attributedText = attributedString
        }
}
