//
//  settingTableViewController.swift
//  FashionRaffle
//
//  Created by Mac on 5/26/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI
import SVProgressHUD
import Cache
import PassKit
import Imaginary
import Foundation


class settingTableViewController: UITableViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var Website: UITextField!
    
    @IBOutlet weak var Bio: UITextView!
    
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var addNews: UIButton!
    @IBOutlet weak var emailLogoutButton: UIButton!
    
    @IBAction func emailLogout(_ sender: Any) {
        SettingsLauncher.showAlertsWithOptions(title: "", message: "Are you sure to sign out?", controller: self, yesHandler: {
            UIAlertAction in
            try! FIRAuth.auth()?.signOut()
            self.logOut()
            
        }, cancelHandler: nil)
    }
    
    @IBOutlet weak var fbLogoutButton: FBSDKLoginButton! = {
        let button = FBSDKLoginButton()
        return button
    }()
    
    @IBAction func uploadProfile(_ sender: Any) {
        
        Profile.currentUser?.bio = self.Bio.text!
        Profile.currentUser?.website = self.Website.text!
        Profile.currentUser?.username = self.username.text!
        Profile.currentUser?.sync()
        SettingsLauncher.showAlerts(title: "Profile upload", message: "Success", handler: nil, controller: self)
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fbLogoutButton.layer.cornerRadius = 5
        self.emailLogoutButton.layer.cornerRadius = 5
        self.emailLogoutButton.layer.borderWidth = 1
        self.emailLogoutButton.layer.borderColor = UIColor.black.cgColor
        if FBSDKAccessToken.current() == nil{
            self.fbLogoutButton.isHidden = true
            self.emailLogoutButton.isHidden = false
        }
        else {
            self.fbLogoutButton.isHidden = false
            self.emailLogoutButton.isHidden = true
        }

        tableView.allowsSelection = false
        navigationController?.navigationBar.backgroundColor = UIColor.white
        
        let username = Profile.currentUser?.username
        self.email.text = Profile.currentUser?.email
        
        
        self.username.text = username
        if let Bio = Profile.currentUser?.bio {
            self.Bio.text = Bio
        }
        if let web = Profile.currentUser?.website{
            self.Website.text = web
        }
        
        if Profile.currentUser?.editor == true {
            print("Is Editor")
            self.title = "Editor Profile"
            
            self.addNews.isHidden = false
            self.addNews.tintColor = UIColor.black
        }
        else {
            print("Not Editor")
            self.title = "User Profile"
            self.addNews.isHidden = true
            self.addNews.tintColor = self.navigationController?.navigationBar.tintColor
        }

        

    }
    
    func logOut() {
        Profile.currentUser = nil
        let cache = HybridCache(name: "UserCache")
        let syncCache = SyncHybridCache(cache)
        syncCache.remove("UserProfile")
        print("Cache Removed")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        self.present(loginVC, animated: true, completion: {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = loginVC
            
            print("Logged Out!")
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        try! FIRAuth.auth()?.signOut()
        self.logOut()
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }


    
    
   
}
