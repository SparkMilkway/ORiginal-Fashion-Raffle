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
import FirebaseDatabase

class SettingTableViewController: UITableViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var ticketBalance: UILabel!
    
    @IBOutlet weak var userEmail: UILabel!
    
    @IBOutlet weak var profileName: UITextField!
    
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    let ref = FIRDatabase.database().reference()
    
    @IBAction func purchaseRaffleTicket(_ sender: Any) {
        let uid = FIRAuth.auth()?.currentUser?.uid
        //let userref = ref.child("Users/EmailUsers").child(uid!)

        ref.child("Users/EmailUsers").child(uid!).observeSingleEvent(of: .value, with: {(snapshot) in
            let value = snapshot.value as? NSDictionary
            
            let balance = value?["raffleTicket"]          //balance = balance! + 1
            print(balance)
            
            
            //how to store this value into int in order to to summation???
            //userref.updateChildValues(["raffleTicket" : balance])

        })
        
    }
    @IBAction func changeProfileName(_ sender: Any) {
        let uid = FIRAuth.auth()?.currentUser?.uid
        if FBSDKAccessToken.current() == nil {
            let userref = ref.child("Users/EmailUsers").child(uid!)
            if profileName.text != "" {
                let newname = profileName.text
                //
                userref.updateChildValues(["name" : newname!])
        } else {
            let userref = ref.child("Users/ProviderUsers").child(uid!)
            if profileName.text != "" {
            let newname = profileName.text
                    //
            userref.updateChildValues(["Name" : newname!])
                }
            }
        }
            
    }
    //let ref = FIRDatabase.database().reference(fromURL: "https://originalfashionraffle.firebaseio.com/")
    //let uid = FIRAuth.auth()?.currentUser?.uid
    //let email = FIRAuth.auth()?.currentUser?.email
    //let name = FIRDatabase.database().reference().child("Users/EmailUsers/(uid)/name")
    
    
    
    static let imageCache = NSCache<AnyObject, AnyObject>() //profile image buffer
    
    func logOut() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        self.present(loginVC, animated: true, completion: nil)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = loginVC
        print("Logged Out!")
    }

    func determineUserType(){
        if FBSDKAccessToken.current() == nil {
            emailUserHandler()
            
        } else {
            fbUserHandler()
        }
    }
    
    func emailUserHandler(){
        if let user = FIRAuth.auth()?.currentUser{
            let email = user.email
            self.userEmail.text = email
            
            let uid = FIRAuth.auth()?.currentUser?.uid
            
            //get username from database
            ref.child("Users/EmailUsers").child(uid!).observeSingleEvent(of: .value, with: {(snapshot) in
                let value = snapshot.value as? NSDictionary
                let username = value?["name"] as? String
                let balance = value?["raffleTicket"]
                self.profileName.text = username
                
                self.ticketBalance.text = balance as! String?    //show ticket balance
                
                //self.ref.child("Users/EmailUsers").child(user.uid).setValue(self.profileName.text)

            })
            //let changedProfileName = profileName
            //self.ref.child("Users/(EmailUsers.uid)/name").setValue(changedProfileName)
        }
    }
    
  
    func fbUserHandler(){ //uncertain about this
        logoutButton = FBSDKLoginButton()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView()
        determineUserType()
        
        //let storageRef = FIRStorage.storage().reference().child("myImage.png")
        
        uploadProfileImage()
        //changeName()
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
        //self.ref.child("Users/EmailUsers/(uid)").setValue(["Image":String])
        /*
         let imageName = NSUUID().uuidString
         if let uploadData = UIImagePNGRepresentation(self.profileImage.image!){
         if error != nil{
         print(error)
         }
         if let profileImageUrl = metadata?.downloadURL()?.absoluteString{
         self.ref.child("Users/EmailUsers/(uid)").setValue(["ProfileImage": profileImageUrl])
         }
         }*/
        
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
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    

    
}
