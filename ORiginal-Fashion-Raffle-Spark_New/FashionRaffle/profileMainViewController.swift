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
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var following: UILabel!
    
    @IBOutlet weak var followers: UILabel!
    
    @IBOutlet weak var brandsContainerView: UIView!

    @IBOutlet weak var Controller: UISegmentedControl!
    
    @IBOutlet weak var userPostContainerView: UIView!
    
    @IBOutlet weak var userRaffleContainerView: UIView!
    
    var chooseImage : Bool!
    
    var userProfile: Profile?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        let username = Profile.currentUser?.username
        
        self.userName!.text = username
        
        self.userName.isHidden = true
        
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
        
        self.Controller.selectedSegmentIndex = 0
        brandsContainerView.isHidden = true
        userPostContainerView.isHidden = false
        userRaffleContainerView.isHidden = true


        
        
        profileImageView()
        backgroundImageView()

        // Do any additional setup after loading the view.
        
        
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
        SettingsLauncher.showLoading(Status: "Uploading Profile Picture...")
        let userID = Profile.currentUser?.userID
        let profileImageData = UIImageJPEGRepresentation(self.profileImage.image!, 0.7)
        let profilePath = "UserInfo/\(userID!)/profilePic/profileImage.jpg"
        SettingsLauncher.uploadDatatoStorage(data: profileImageData!, itemStoragePath: profilePath, contentType: "image/jpeg", completion: {
            metadata, error in
            guard let meta = metadata else{
                print("Upload Error")
                return
            }
            let url = meta.downloadURL()
            Profile.currentUser?.profilePicUrl = url
            Profile.currentUser?.sync()
            SettingsLauncher.dismissLoading()
            
        })
        
        

        
    }
    func uploadBackgroundImage(){
        SettingsLauncher.showLoading(Status: "Uploading Background Picture...")
        let userID = Profile.currentUser?.userID
        let backgroundImageData = UIImageJPEGRepresentation(self.profileBackground.image!, 0.7)
        let backgroundPath = "UserInfo/\(userID!)/backgroundPic/backgroundImage.jpg"
        
        SettingsLauncher.uploadDatatoStorage(data: backgroundImageData!, itemStoragePath: backgroundPath, contentType: "image/jpeg", completion: {
            metadata, error in
            guard let meta = metadata else{
                print("Upload Error")
                return
            }
            let url = meta.downloadURL()
            Profile.currentUser?.backgroundPictureUrl = url
            Profile.currentUser?.sync()
            SettingsLauncher.dismissLoading()
            
            
        })

    }
    
    
    
    func backgroundImageView() {
        
        
        profileBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectBackgroundImageView)))
        profileBackground.isUserInteractionEnabled = true
        profileBackground.contentMode = .scaleAspectFill
        profileBackground.alpha = 0.8
        
    }

    
    

}
