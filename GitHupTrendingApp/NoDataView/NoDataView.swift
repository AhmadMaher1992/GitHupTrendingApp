//
//  NoDataView.swift
//  GitHupTrendingApp
//
//  Created by Ahmad Eisa on 16/09/2024.
//

import Foundation
import UIKit

enum NoDataViewType {
    case standardType
    case searchType
}


class NoDataView : UIView {

    static let identifier = "NoDataView"
    
    /// `No Data View Outlets`
    @IBOutlet weak var noDataView           : UIView!
    @IBOutlet weak var noDataViewImage      : UIImageView!
    @IBOutlet weak var noDataViewTitle      : UILabel!
    @IBOutlet weak var noDataViewDescription: UILabel!

    override init(frame: CGRect)
    {
        super.init(frame: frame)
        commitInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commitInit()
    }
    
    
    func commitInit ()
    {
        let viewFromXib = Bundle.main.loadNibNamed(NoDataView.identifier, owner: self, options: nil)?.first as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
        
    }
   // E3000F
    func setViewDetails(_ title : String , _ details : String = "", _ type: NoDataViewType = .standardType, _ backGroundColor: UIColor) {
        self.noDataViewTitle.text       = title
        self.noDataViewDescription.text = details
        self.noDataView.backgroundColor = backGroundColor
        
        if type == .standardType
        {
            noDataViewImage.image = UIImage(named: AppImages.noInternet_Img)
        }
        else
        {
            noDataViewImage.image = UIImage(named: AppImages.noSearchResult_Img)
        }
       
        
    }
    
}
