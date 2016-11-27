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
    
    let ref = FIRDatabase.database().reference()
    var ticketsTemp = 0 as NSNumber
    var ticketsCal = 0
    
    @IBAction func RaffleTickets(_ sender: Any) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        ref.child("Users/EmailUsers").child(userID!).observeSingleEvent(of: .value, with: {
            snapshot in
            let value = snapshot.value as? NSDictionary
            let tickets = value?["Tickets"] as? Int ?? nil
            if tickets == nil {
                self.ticketsCal = 0
            }
            else {
                self.ticketsCal = tickets!
            }
        })
        ticketsCal = ticketsCal + 1
        ticketsTemp = NSNumber(value: ticketsCal)
        let post = ["Tickets": ticketsTemp] as [String: NSNumber]
        ref.child("Users/EmailUsers").child(userID!).updateChildValues(post, withCompletionBlock: { (error, ref) in
            if error != nil {
                self.showAlerts(title: "Oops", message: error!.localizedDescription, handler: nil)
                return
            }
            else {
                self.showAlerts(title: "Purchase Success!", message: "Now you have \(self.ticketsTemp) raffle tickets!", handler: nil)
            }
        })
        
        
        

    }
    @IBOutlet weak var profileImage: UIImageView!
    

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
    
    
    
    
    func showAlerts(title: String, message: String, handler: ((UIAlertAction) -> Void)?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title:"OK", style: .cancel, handler: handler)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        
    }
    
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    

    
}
