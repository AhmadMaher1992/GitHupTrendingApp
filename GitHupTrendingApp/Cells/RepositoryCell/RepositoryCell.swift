//
//  RepositoryCell.swift
//  GitHupTrendingApp
//
//  Created by Ahmad Eisa on 16/09/2024.
//

import UIKit

protocol RepositoryCellDelegate: AnyObject {
    func onFavoriteTapped(repository: GithupRepo)
    
}


class RepositoryCell: UITableViewCell {
    
    //------------------------------------------
    // MARK: - properties
    //------------------------------------------
    var repository: GithupRepo?
    weak var delegate: RepositoryCellDelegate?
    var onFavoriteTapped: ((GithupRepo) -> Void)?
    
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
    
    // i use two way to handle favourites (closure and protocol)
    @IBAction func favouriteRepoBtnAction(_ sender: UIButton) {
        if let repo = repository {
            delegate?.onFavoriteTapped(repository: repo)
            onFavoriteTapped?(repo) // Trigger the favorite action callback
            updateFavoriteButtonImage() // Update the button image after the action
           
        }
        
    }
    
    private func updateFavoriteButtonImage() {
        if let repo = repository {
            let isFavorite = FavoritesManager.shared.isFavorite(repo)
            let imageName = isFavorite ? AppImages.filledStar : AppImages.emptyStar // Change to your actual image names
            favouriteRepoBtn.setImage(UIImage(named: imageName), for: .normal)
        }
    }

    
    //------------------------------------------
    // MARK: - configure
    //------------------------------------------
    
    func configure(with repository: GithupRepo) {
        self.repository = repository
        titleLabel.text = repository.owner?.login ?? ""
        nameLabel.text = repository.name ?? ""
        descriptionLabel.text = repository.description ?? "No description available"
        
        
        if let stargazers_count = repository.stargazers_count {
            starsLabel.text = "⭐ \(stargazers_count)"
        }
        
        if let urlString = repository.owner?.avatar_url {
            self.avatarImageView.setImage(with: urlString)
        }
        //check favourites REPO
        if FavoritesManager.shared.isFavorite(repository) {
            self.favouriteRepoBtn.setImage( UIImage(named: AppImages.filledStar) , for: .normal)
        } else {
            self.favouriteRepoBtn.setImage( UIImage(named: AppImages.emptyStar) , for: .normal)
        }
    }
    
}
