//
//  UITableView+Extension.swift
//  GitHupTrendingApp
//
//  Created by Ahmad Eisa on 16/09/2024.
//

import UIKit


extension UITableView{

    func registerCell<cell: UITableViewCell>(cellClass: cell.Type){
        
        self.register(UINib(nibName: String(describing: cell.self), bundle: nil), forCellReuseIdentifier: String(describing: cell.self))
    }


    func dequeueCell<Cell: UITableViewCell>() -> Cell{

        guard let cell = self.dequeueReusableCell(withIdentifier: String(describing: Cell.self)) as? Cell else{
            fatalError("cand dequeue cell")
        }

        return cell
    }


}
