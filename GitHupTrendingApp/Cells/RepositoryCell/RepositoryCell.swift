//
//  RepositoryCell.swift
//  GitHupTrendingApp
//
//  Created by Ahmad Eisa on 16/09/2024.
//

import UIKit

protocol RepositoryCellDelegate: AnyObject {
    func handleGitRepoFavorited(gitRepod: GithupRepo)
    
}


class RepositoryCell: UITableViewCell {
    
    
    //------------------------------------------
    // MARK: -IBOutlets
    //------------------------------------------
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!
    @IBOutlet weak var favouriteRepoBtn: UIButton!
    
    
    //------------------------------------------
    // MARK: - awakeFromNib
    //------------------------------------------
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    
    //------------------------------------------
    // MARK: -IBActions
    //------------------------------------------
    
    
    @IBAction func favouriteRepoBtnAction(_ sender: UIButton) {
        
        
    }
    
    
    
    //------------------------------------------
    // MARK: - configure
    //------------------------------------------
    
    func configure(with repository: GithupRepo) {
        
        titleLabel.text = repository.owner?.login ?? ""
        nameLabel.text = repository.name ?? ""
        descriptionLabel.text = repository.description ?? "No description available"
        
        
        if let stargazers_count = repository.stargazers_count {
            starsLabel.text = "⭐ \(stargazers_count)"
        }
        
        if let urlString = repository.owner?.avatar_url {
            self.avatarImageView.setImage(with: urlString)
        }
    }
    
}
