//
//  profileMainViewController.swift
//  FashionRaffle
//
//  Created by Mac on 5/6/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorageUI
import SVProgressHUD
import PassKit



class profileMainViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileBackground: UIImageView!
    @IBOutlet weak var bio: UITextView!
    @IBOutlet weak var infoVE: UIVisualEffectView!
    @IBOutlet weak var brandsContainerView: UIView!
    @IBOutlet weak var Controller: UISegmentedControl!
    @IBOutlet weak var userPostContainerView: UIView!
    @IBOutlet weak var userRaffleContainerView: UIView!
    @IBOutlet var editProfileButton: UIBarButtonItem!
    
    @IBOutlet var scrollContentsView: UIView!
    @IBOutlet var profileScrollView: UIScrollView!
    var fingArray = [String]()
    var ferArray = [String]()
    var chooseImage : Bool = true
    
    var isCurrentUser : Bool = true
    private var embeddedPostsVC : UserPostsViewController!
    
    var selectedUser = Profile.currentUser {
        willSet(newValue) {
            guard let currentUser = Profile.currentUser else {
                print("No current User, function won't work")
                return
            }
            if newValue!.userID != currentUser.userID {
                isCurrentUser = false
            }
            else {
                isCurrentUser = true
            }
        }
    }
    
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followerButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isCurrentUser == true {
            selectedUser = Profile.currentUser
        }
        UserInfoView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
        infoVE.alpha = 0.5
        
        UserImagesView()
        profileImageView()
        backgroundImageView()
        
        if isCurrentUser == true {
            self.navigationItem.rightBarButtonItem = editProfileButton
        }
        else {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        self.Controller.selectedSegmentIndex = 0
        brandsContainerView.isHidden = true
        userPostContainerView.isHidden = false
        userRaffleContainerView.isHidden = true
        // Do any additional setup after loading the view.
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let postsVC = segue.destination as? UserPostsViewController, segue.identifier == "userPostsEmbedSegue" {
            self.embeddedPostsVC = postsVC
            
        }
    }
    
    func UserImagesView() {
        
        if let nowUser = selectedUser {
            
            if isCurrentUser == true {
                // is CurrentUser
                self.profileImage.isUserInteractionEnabled = true
                self.profileBackground.isUserInteractionEnabled = true
            }
            else {
                // Not currentUser
                self.profileImage.isUserInteractionEnabled = false
                self.profileBackground.isUserInteractionEnabled = false
            }
            
            let defaultProfile = UIImage(named: "UserIcon")
            let defaultBackGround = UIImage(named: "background")
            if let profileUrl = nowUser.profilePicUrl {
                self.profileImage.setImage(url: profileUrl, placeholder: defaultProfile)
            }
            else {
                self.profileImage.image = defaultProfile
            }
            if let backgroundUrl = nowUser.backgroundPictureUrl {
                self.profileBackground.setImage(url: backgroundUrl)
            }
            else {
                self.profileBackground.image = defaultBackGround
            }
        }
        
    }
    
    func UserInfoView() {
        
        if let user = selectedUser {
            self.embeddedPostsVC.selectedUserID = user.userID
            navigationItem.title = user.username
            if let fers = user.followers {
                self.ferArray = fers
            }
            else {
                self.followerButton.isUserInteractionEnabled = false
            }
            self.followerButton.setTitle("Followers: " + String(self.ferArray.count), for: .normal)
            
            if let fings = user.following {
                self.fingArray = fings
            }
            else {
                self.followingButton.isUserInteractionEnabled = false
            }
            self.followingButton.setTitle("Followings: " + String(self.fingArray.count), for: .normal)
            
            var bioTemp : String = ""
            var webTemp : String = ""
            
            if let bio = user.bio {
                bioTemp = bio
            }
            if let web = user.website {
                webTemp = web
            }
            if bioTemp == "" && webTemp == "" {
                //nil
                self.bio.isHidden = true
            }
            else {
                self.bio.isHidden = false
                self.bio.text = bioTemp + "\n" + webTemp
            }
        }
        
        
        
    }
    
    @IBAction func followerTapped(_ sender: Any) {
        
        userId = (Profile.currentUser?.userID)!

        category = "followers"
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersVCTableViewController
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    @IBAction func followingTapped(_ sender: Any) {
        userId = (Profile.currentUser?.userID)!
        category = "followings"
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersVCTableViewController
        self.navigationController?.pushViewController(followers, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func changeView(_ sender: Any) {
        if Controller.selectedSegmentIndex == 0{
            userPostContainerView.isHidden = false
            brandsContainerView.isHidden = true
            userRaffleContainerView.isHidden = true
        }
        if Controller.selectedSegmentIndex == 1{
            userPostContainerView.isHidden = true
            brandsContainerView.isHidden = false
            userRaffleContainerView.isHidden = true
        }
        if Controller.selectedSegmentIndex == 2{
            userPostContainerView.isHidden = true
            brandsContainerView.isHidden = true
            userRaffleContainerView.isHidden = false
        }
        
    }
    func profileImageView() {
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        profileImage.layer.backgroundColor = UIColor.white.cgColor
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.white.cgColor
        
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        
        
    }
    
    func uploadProfileImage(){
        
        let profileImageData = UIImageJPEGRepresentation(self.profileImage.image!, 0.7)
        API.userAPI.uploadCurrentUserProfileImage(imageData: profileImageData!, onSuccess: {
            print("Upload Success")
        })

    }
    func uploadBackgroundImage(){
        
        let backgroundImageData = UIImageJPEGRepresentation(self.profileBackground.image!, 0.7)
        API.userAPI.uploadCurrentUserBackgroundImage(imageData: backgroundImageData!, onSuccess: {
            print("Upload Success")
        })

    }

    func backgroundImageView() {
        
        
        profileBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectBackgroundImageView)))
        profileBackground.contentMode = .scaleAspectFill
        profileBackground.alpha = 1
        
    }

    
    

}
