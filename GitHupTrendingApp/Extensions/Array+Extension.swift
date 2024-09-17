//
//  Array+Extension.swift
//  GitHupTrendingApp
//
//  Created by Ahmad Eisa on 17/09/2024.
//

import Foundation
import UIKit

extension Array {
  /// Returns the element at the specified index iff it is within bounds, otherwise nil.
  subscript(safe index: Int) -> Element? {
    return indices.contains(index) ? self[index] : nil  /// Returns the element at the specified index iff it is within bounds, otherwise nil.
  }
}

