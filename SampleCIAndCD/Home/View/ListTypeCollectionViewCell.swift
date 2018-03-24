//
//  ListTypeCollectionViewCell.swift
//  SampleCIAndCD
//
//  Created by Santhosh Nampally on 24/03/18.
//  Copyright © 2018 Santhosh Nampally. All rights reserved.
//

import UIKit
import SDWebImage

class ListTypeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var userImgVw: UIImageView!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var detailLbl: UILabel!
    
    var userDetails:UserData!{
        didSet{
            detailLbl.text = userDetails.details
            firstNameLbl.text = userDetails.firstName
            userImgVw.sd_setImage(with: URL(string:userDetails.imageUrl!))
        }
    }
    
}
