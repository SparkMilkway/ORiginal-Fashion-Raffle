//
//  profileMainViewController.swift
//  FashionRaffle
//
//  Created by Mac on 5/6/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import UIKit
import Firebase
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
    
    var chooseImage : Bool!
    
    var fingArray = [String]()
    var ferArray = [String]()
    
    @IBOutlet weak var followingButton: UIButton!
    
    @IBOutlet weak var followerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        
        infoVE.alpha = 0.5
        
        
        if let profileUrl = Profile.currentUser?.profilePicUrl {
            self.profileImage.setImage(url: profileUrl)
        }
        else {
            self.profileImage.image = UIImage(named: "UserIcon")
        }
        
        if let backgroundUrl = Profile.currentUser?.backgroundPictureUrl {
            self.profileBackground.setImage(url: backgroundUrl)
        }
        else {
            self.profileBackground.image = UIImage(named: "background")
        }
        
        if let fingArray = Profile.currentUser?.following{
            followingArray = fingArray
            self.fingArray = fingArray

        }
        else {
            self.followingButton.isUserInteractionEnabled = false
        }
        self.followingButton.setTitle("Following: " + String(self.fingArray.count), for: .normal)
        
        if let ferArray = Profile.currentUser?.followers{
            followerArray = ferArray
            self.ferArray = ferArray
            
        }
        else {
            self.followerButton.isUserInteractionEnabled = false
        }
        self.followerButton.setTitle("Followers: " + String(self.ferArray.count), for: .normal)
        
        if let bio = Profile.currentUser?.bio{
            if let web = Profile.currentUser?.website{
                self.bio.text = bio + "\n" + web
            }
            else{
                self.bio.text = bio
            }
        }else {
            if let web = Profile.currentUser?.website{
                self.bio.text = web
            }
            else{
                self.bio.isHidden = true
            }
        }

        
        self.Controller.selectedSegmentIndex = 0
        brandsContainerView.isHidden = true
        userPostContainerView.isHidden = false
        userRaffleContainerView.isHidden = true


        
        
        profileImageView()
        backgroundImageView()

        // Do any additional setup after loading the view.
        
        
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = Profile.currentUser?.username
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
        profileImage.isUserInteractionEnabled = true
        
        
    }
    
    func uploadProfileImage(){
        
        let profileImageData = UIImageJPEGRepresentation(self.profileImage.image!, 0.7)
        API.storageAPI.uploadCurrentUserProfileImage(imageData: profileImageData!, onSuccess: {
            print("Upload Success")
        })

    }
    func uploadBackgroundImage(){
        
        let backgroundImageData = UIImageJPEGRepresentation(self.profileBackground.image!, 0.7)
        API.storageAPI.uploadCurrentUserBackgroundImage(imageData: backgroundImageData!, onSuccess: {
            print("Upload Success")
        })

    }
    
    
    
    func backgroundImageView() {
        
        
        profileBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectBackgroundImageView)))
        profileBackground.isUserInteractionEnabled = true
        profileBackground.contentMode = .scaleAspectFill
        profileBackground.alpha = 0.9
        
    }

    
    

}
