//
//  photoTagTableViewCell.swift
//  FashionRaffle
//
//  Created by Mac on 2016/12/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit



class photoTagTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var categoryTag: UILabel!
    
    @IBOutlet weak var brandLabel: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   

}
