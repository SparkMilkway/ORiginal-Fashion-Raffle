//
//  newMessageTableViewCell.swift
//  FashionRaffle
//
//  Created by Mac on 6/25/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class newMessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImg: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var selectButton: UIButton!
    
    var selectedUser : Profile? {
        didSet{
            updateCell()
        }
    }
    
    func updateCell() {
        if let user = selectedUser {
            
            
            if let url = user.profilePicUrl {
                self.profileImg.setImage(url: url)
            }
            else{
                self.profileImg.image = #imageLiteral(resourceName: "UserIcon")
            }
            userName.text = user.username
            
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
