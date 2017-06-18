//
//  followerVCTableViewCell.swift
//  FashionRaffle
//
//  Created by Mac on 5/26/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Foundation
import Firebase

class followerVCTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var userImg: UIImageView!
    
    @IBOutlet weak var userID: UILabel!
    
    @IBOutlet weak var actionButton: UIButton!
    
    
    @IBOutlet var viewProfile: UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBAction func actionButton(_ sender: Any) {
        
        let following = self.actionButton.titleLabel?.text
        if following == "Following" {
            print("unfollow")
            print(userID.text!)
            if let index = Profile.currentUser?.following?.index(of: userID.text!) {
                Profile.currentUser?.following?.remove(at: index)
            }
            
            self.actionButton.setTitle("+ Follow", for: .normal)
        } else {
            
            Profile.currentUser?.following?.append(userID.text!)
            self.actionButton.setTitle("Following", for: .normal)
            
            print("follow")
        }
        Profile.currentUser?.sync(onSuccess: {}, onError: {
            error in
            print(error.localizedDescription)
        })

        
    }
    
}
