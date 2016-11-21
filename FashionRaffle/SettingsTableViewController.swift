//
//  SettingsTableViewController.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 11/20/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorageUI

class SettingTableViewController: UITableViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    
    let ref = FIRDatabase.database().reference()
    let storageRef = FIRStorage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView()

        
        uploadProfileImage()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func profileImageView() {
        profileImage.image = UIImage(named: "background")
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        profileImage.layer.backgroundColor = UIColor.black.cgColor
        profileImage.layer.borderWidth = 2
        
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        profileImage.isUserInteractionEnabled = true
        
        
        uploadProfileImage()
    }
    func uploadProfileImage(){
        
        let imageName = NSUUID().uuidString
        let storageRef = FIRStorage.storage().reference().child("(imageName).png")
        if let uploadData = UIImagePNGRepresentation(self.profileImage.image!) {
            storageRef.put(uploadData,metadata:nil, completion: { (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString{
                    self.ref.child("Users/EmailUsers/(uid)").setValue(["ProfilImageUrl":profileImageUrl])
                }
            })
        }
    }
    
    
    
    
    
    
    /*
     let imageName = NSUUID().uuidString
     let storageRef = FIRStorage.storage().reference().child("profile_images").child("\(imageName).png")
     if let uploadData = UIImagePNGRepresentation(self.profileImage.image!) {
     storageRef.put(uploadData,metadata:nil, completion: { (metadata, error) in
     if error != nil {
     print(error)
     return
     }
     if let profileImageUrl = metadata?.downloadURL()?.absoluteString{
     let values = ["name":self.name, "email": self.email, "profile ImageUrl": profileImageUrl]
     
     }
     
     })
     }
     */
    
    
    
    
    
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        
    }
    
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    

    
}
