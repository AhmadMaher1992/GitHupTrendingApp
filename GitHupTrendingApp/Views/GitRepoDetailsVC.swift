//
//  GitRepoDetailsVC.swift
//  GitHupTrendingApp
//
//  Created by Ahmad Eisa on 17/09/2024.
//

import UIKit
import SafariServices

class GitRepoDetailsVC: UIViewController {
    
    //------------------------------------------
    // MARK: - properties
    //------------------------------------------
     var repository: GithupRepo!
    
    
    //------------------------------------------
    // MARK: -IBOutlets
    //------------------------------------------
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ownerLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var forksLbl: UILabel!
    @IBOutlet weak var starsNoLbl: UILabel!
    @IBOutlet weak var createdAtLbl: UILabel!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var htmlUrlLbl: UILabel!
    
    @IBOutlet weak var containerView: UIView!{
        didSet{
            self.containerView.layer.cornerRadius = 10
        }
    }
 
    
   
    //------------------------------------------
    // MARK: - Life Cycle
    //------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(GitRepoDetailsVC.githubLinkButtonTapped))
        htmlUrlLbl.isUserInteractionEnabled = true
        htmlUrlLbl.addGestureRecognizer(tap)
        updateUI_WithData()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let touch = touches.first
        if touch?.view == self.view {
            self.dismiss(animated: true, completion: nil)
        }else{
            return
        }
        
    }
    
    //------------------------------------------
    // MARK: - Helpers
    //------------------------------------------
    
    private func updateUI_WithData(){
        nameLabel.text = repository.name ?? ""
        ownerLbl.text = repository.owner?.login ?? ""
        descriptionLbl.text = repository.description ?? "No description available"
        if let forks = repository.forks  {
            self.updateLabelsWithImages(lbl:forksLbl ,stringMsg: " \(forks) ",imageName: AppImages.fork_Img)
        }
        
        if let date = repository.created_at  {
            self.updateLabelsWithImages(lbl: createdAtLbl ,stringMsg: " \(date) ",imageName: AppImages.createdAt_Img)
        }
        
        if let language = repository.language {
            languageLbl.text = language
        }
        
        if let stargazers_count = repository.stargazers_count {
            starsNoLbl.text = "⭐ \(stargazers_count)"
        }
        if let  html_url = repository.html_url{
            htmlUrlLbl.setURLWithUnderline(url: html_url, font: UIFont.systemFont(ofSize: 16), textColor: .blue)
        }
        
        if let urlString = repository.owner?.avatar_url {
            self.avatarImageView.setImage(with: urlString)
        }
        
    }
    
    @objc private func githubLinkButtonTapped() {
        if let url = URL(string: repository.html_url ?? "") {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true)
        }
    }
    
    func updateLabelsWithImages(lbl: UILabel ,stringMsg: String ,imageName: String){
        // Set up label with text and image
        // let text = "This is a label with an image "
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = UIImage(named: imageName ) // Replace with your image name
        
        // Adjust image size
        let imageOffsetY: CGFloat = -5.0 // Adjust as needed
        imageAttachment.bounds = CGRect(x: 0, y: imageOffsetY, width: 20, height: 20) // Adjust size as needed
        
        // Create attributed string with image
        let imageString = NSAttributedString(attachment: imageAttachment)
        
        // Combine text and image
        let fullString = NSMutableAttributedString(string: stringMsg)
        fullString.append(imageString)
        
        // Set the label's attributed text
        lbl.attributedText = fullString
    }
    
    //------------------------------------------
    // MARK: -IBActions
    //------------------------------------------
    @IBAction func dismissBtnClicked(_ sender: Any) {
    
        self.dismiss(animated: true)
        
    }
    
    
    
    
}
