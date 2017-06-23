//
//  PostsFeedReusableCell.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 6/3/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import UIKit
import Imaginary

class PostPoolCell: UITableViewCell {
    
    @IBOutlet weak var captionLabel:UILabel!
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var viewProfile: UIButton!
    
    var homeTableViewController: UITableViewController?
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let currentPost = post {
            let fetchUserID = currentPost.creatorID
            timeStamp.text = currentPost.timestamp
            if let caption = currentPost.caption {
                self.captionLabel.text = caption
            }

            API.userAPI.fetchUserProfilePicUrl(withID: fetchUserID, completion: {
                profileurl in
                if let url = profileurl {
                    self.profileImage.setImage(url: url)
                }
                else {
                    self.profileImage.image = UIImage(named: "UserIcon")
                }
            })
            API.userAPI.fetchUserName(withID: fetchUserID, completion: {
                fetchName in
                self.userNameLabel.text = fetchName
                
            })
            self.loadingIndicator.startAnimating()
            imgView.setImage(url: currentPost.imageUrl) {
                _ in
                self.loadingIndicator.stopAnimating()
            }
            
        }
    }

    // View Profile Button
    @IBAction func profileDidTouch(_ sender: Any) {
        

        Config.showPlainLoading(withStatus: nil)
        let userID = post?.creatorID
        let profileViewController = UIStoryboard(name: "Profile", bundle: nil).instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileCollectionViewController
        profileViewController.isProfilePage = false
        if userID == Profile.currentUser?.userID {
            
            profileViewController.isCurrentUser = true
            profileViewController.selectedUser = Profile.currentUser
            Config.dismissPlainLoading()
            self.homeTableViewController?.navigationController?.pushViewController(profileViewController, animated: true)
        }
        else {
            API.userAPI.fetchUserInfo(withID: userID!, completion: {
                fetchProfile in
                profileViewController.isCurrentUser = false
                profileViewController.selectedUser = fetchProfile!
                
                Config.dismissPlainLoading()
                self.homeTableViewController?.navigationController?.pushViewController(profileViewController, animated: true)
            })
        }
        
        
    }
    
    // Comment Button
    @IBAction func commentDidTap(_ sender: Any) {
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        captionLabel.text = ""
        userNameLabel.text = ""
    }
    
    
}
