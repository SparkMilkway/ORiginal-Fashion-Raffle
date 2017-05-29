//
//  userPostsCollectionViewCell.swift
//  FashionRaffle
//
//  Created by Mac on 5/8/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class userPostsCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var userPostsImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // alignment
        let width = UIScreen.main.bounds.width
        userPostsImage.frame = CGRect(x: 0, y: 0, width: width / 3, height: width / 3)
    }

    
}
