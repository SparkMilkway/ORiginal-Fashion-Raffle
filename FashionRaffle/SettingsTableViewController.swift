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
import SVProgressHUD

class SettingTableViewController: UITableViewController, FBSDKLoginButtonDelegate {
    
    let ref = FIRDatabase.database().reference()
    let storage = FIRStorage.storage()
    var ticketsTemp = 0 as NSNumber
    var ticketsCal = 0
    
    @IBOutlet weak var changeImage: UITextField!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    
    @IBOutlet weak var emailLogOutButton: UIButton!
    @IBAction func emailLogOut(_ sender: Any) {
        let refreshAlert = UIAlertController(title: "Sign Out", message: "Are you sure to sign out?", preferredStyle: .alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) -> Void in
            try! FIRAuth.auth()?.signOut()
            self.logOut()
            
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    @IBOutlet var fbLogoutButton: FBSDKLoginButton! = {
       let button = FBSDKLoginButton()
        return button
    }()
    
    
    
    //Buy raffle Tickets and Update the database
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
    
    
    let emailStorageRef = FIRStorage.storage().reference().child("User Info/EmailUsers")
    let providerStorageRef = FIRStorage.storage().reference().child("User Info/ProviderUsers")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        fbLogoutButton.delegate = self
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy"
        let now = dateFormat.string(from: Date())
        self.dateLabel.text = now
        
        
        profileImageView()
        
        
        if FBSDKAccessToken.current() == nil {

            self.fbLogoutButton.isHidden = true
            self.emailLogOutButton.isHidden = false
            if let userID = FIRAuth.auth()?.currentUser?.uid {
                ref.child("Users/EmailUsers").child(userID).observeSingleEvent(of: .value, with: {
                    snapshot in
                    let value = snapshot.value as? NSDictionary
                    let name = value!["name"] as? String
                    let email = value!["email"] as? String
                    let pictureURL = value!["ProfileImageUrl"] as? String
                    if pictureURL != nil{
                        let httpRef = self.storage.reference(forURL: pictureURL!)
                        self.profileImage.sd_setImage(with: httpRef)
                    }
                    else {
                        self.profileImage.image = UIImage(named: "background")
                    }
                    self.userName!.text = name
                    self.userEmail!.text = email
                })
            }
            
        }
            
        else {
            self.fbLogoutButton.isHidden = false
            self.emailLogOutButton.isHidden = true
            profileImage.isUserInteractionEnabled = false
            if let user = FIRAuth.auth()?.currentUser{
                for profile in user.providerData {
                    let name = profile.displayName
                    let email = profile.email
                    let userID = profile.uid as NSString
                    let pictureURL = URL(string: "http://graph.facebook.com/\(userID)/picture?type=large")
                    
                    self.userEmail!.text = email
                    self.userName!.text = name
                
                    if let url = pictureURL {
                        if let image = self.imageCache.object(forKey: url as AnyObject) as? UIImage {
                            self.profileImage.image = image
                        }
                        else {
                            URLSession.shared.dataTask(with: url, completionHandler: {
                                (data, response, error) -> Void in
                                if (error != nil) {
                                    print (error!)
                                    return
                                }
                                let image = UIImage(data: data!)
                                self.imageCache.setObject(image!, forKey: url as AnyObject)
                                DispatchQueue.main.async(execute: {
                                    () -> Void in
                                    self.profileImage.image = image
                                })
                            }).resume()
                        }
                    }
                }
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        
        
        
    }

    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func profileImageView() {
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        profileImage.layer.backgroundColor = UIColor.black.cgColor
        profileImage.layer.borderWidth = 2
        
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        profileImage.isUserInteractionEnabled = true
        
    }
    
    // Upload the Image to cloud storage
    func uploadProfileImage(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{return}
        let imageName = NSUUID().uuidString
        let storageRef = emailStorageRef.child("/\(uid)/Profile Images/\(imageName).jpg")
        //let metadata = FIRStorageMetadata()
        if let uploadData = UIImageJPEGRepresentation(self.profileImage.image!, 0.6) {
            SVProgressHUD.show(withStatus: "Uploading...")
            storageRef.put(uploadData,metadata:nil, completion: { (metadata, error) in
                if error != nil {
                    print(error!)
                    SVProgressHUD.showError(withStatus: "Error Occurs")
                    return
                }
                SVProgressHUD.showSuccess(withStatus: "Upload Success!")
                SVProgressHUD.dismiss(withDelay: 1)
                if let profileImageUrl = metadata?.downloadURL()?.absoluteString{
                    self.ref.child("Users/EmailUsers/\(uid)").updateChildValues(["ProfileImageUrl":profileImageUrl])
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
    
    func logOut() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        self.present(loginVC, animated: true, completion: nil)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginVC
        print("Logged Out!")
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
