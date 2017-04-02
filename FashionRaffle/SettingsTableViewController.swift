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
import PassKit

class SettingTableViewController: UITableViewController, FBSDKLoginButtonDelegate, PKPaymentAuthorizationViewControllerDelegate {

    let ref = FIRDatabase.database().reference()
    let storage = FIRStorage.storage()
    var defaulttickets : Int = 0
    var nextDayYet = false
    var checkedYet = false
    
    var paymentRequest : PKPaymentRequest!
    
    @IBOutlet weak var changeImage: UITextField!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    
    //Check in Begin
    @IBOutlet weak var dailyCheckInButton: UIButton!
    @IBAction func dailyCheckIn(_ sender: Any) {

        if checkedYet == false {
            
            SVProgressHUD.showSuccess(withStatus: "Checked Today!")
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "MM/dd/yyyy"
            let now = dateFormat.string(from: Date())
            let userID = FIRAuth.auth()?.currentUser?.uid
            let post:[String: String] = ["Last Checked In": now]

            DataBaseStructure().updateUserDatabase(location: "Users", userID: userID!, post: post)

            self.dailyCheckInButton.backgroundColor = UIColor(colorLiteralRed: 153/255, green: 153/255, blue: 153/255, alpha: 1)
            checkedYet = true
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.4, execute: {
                () -> Void in
                SVProgressHUD.dismiss()
            })
            
        }
        else {
            SVProgressHUD.showError(withStatus: "Already Checked Today!")
            print("Good Work")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.4, execute: {
                () -> Void in
                SVProgressHUD.dismiss()
            })
        
        }
        
    }
    //Check in ends
    

    
    //Email Log out Begin
    
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
    //Ends
    
    @IBOutlet var fbLogoutButton: FBSDKLoginButton! = {
       let button = FBSDKLoginButton()
        return button
    }()
    
    @IBAction func checkTickets(_ sender: Any) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        let location = "Users"
        ref.child(location).child(userID!).observeSingleEvent(of: .value, with: {
            snapshot in
            let value = snapshot.value as? NSDictionary
            let tickets = value!["Tickets"] as! Int
            SettingsLauncher().showAlerts(title: "Raffle Tickets", message: "You have \(tickets) raffle tickets.", handler: nil, controller: self)
        })
    }
    
    
    //Buy raffle Tickets and Update the database////////////////////////////////////////
    
    
    
    func itemToSell() -> [PKPaymentSummaryItem] {
        let oneRaffleTicket = PKPaymentSummaryItem(label: "One Raffle Ticket", amount: 0.99)
        let totalPrice = PKPaymentSummaryItem(label: "ORiginal APP", amount: oneRaffleTicket.amount)
        return [oneRaffleTicket, totalPrice]
    }
    
    @IBAction func RaffleTickets(_ sender: Any) {
        let paymentNetworks = [PKPaymentNetwork.amex, .visa, .discover, .masterCard]
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: paymentNetworks) {
            paymentRequest = PKPaymentRequest()
            paymentRequest.currencyCode = "USD"
            paymentRequest.countryCode = "US"
            paymentRequest.merchantIdentifier = "merchant.com.Raffle-F"
            paymentRequest.supportedNetworks = paymentNetworks
            paymentRequest.merchantCapabilities = .capability3DS
            paymentRequest.requiredShippingAddressFields = [.email,.name,.phone]
            paymentRequest.paymentSummaryItems = self.itemToSell()
            
            let freeShipping = PKShippingMethod(label: "Normal Delivery", amount: 0)
            freeShipping.detail = "Delivered to you within 7 to 10 days."
            freeShipping.identifier = "freeShipping"
            
            paymentRequest.shippingMethods = [freeShipping]
            
            let applePayVC = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
            applePayVC.delegate = self
            self.present(applePayVC, animated: true, completion: nil)
            
        }
        else {
            SettingsLauncher().showAlerts(title: "Oops", message: "You need to set up Apple Pay!", handler: nil, controller: self)
        }
            
        
    }
    
    func purchaseSuccess() {
        let user = FIRAuth.auth()?.currentUser
        let userID = user?.uid
        var hastickets : Int = 0
        var location = ""
        if FBSDKAccessToken.current() == nil {
            location = "Users/EmailUsers"
        }else {
            location = "Users/ProviderUsers"
        }
        ref.child(location).child(userID!).observeSingleEvent(of: .value, with: {
            snapshot in
            let value = snapshot.value as? NSDictionary
            let tickets = value!["Tickets"] as! Int
            hastickets = tickets
            let post : [String: Int] = ["Tickets" : hastickets + 1]
            self.ref.child(location).child(userID!).updateChildValues(post)
        })
        
        SettingsLauncher().showAlerts(title: "Purchase Success!", message: "Enjoy your raffle!", handler: nil, controller: self)
        

    }
    
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect shippingMethod: PKShippingMethod, completion: @escaping (PKPaymentAuthorizationStatus, [PKPaymentSummaryItem]) -> Void) {
        completion(PKPaymentAuthorizationStatus.success, itemToSell())
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        completion(PKPaymentAuthorizationStatus.success)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.2, execute: {
            controller.dismiss(animated: true, completion: {
                self.purchaseSuccess()
            })
        })
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion:nil)
        
        
    }
    //End///////////////////////////////////////////////////////////
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
                ref.child("Users").child(userID).observeSingleEvent(of: .value, with: {
                    snapshot in
                    let value = snapshot.value as? NSDictionary
                    let checkdate = value?["Last Checked In"] as? String
                    if checkdate == nil{
                        self.checkedYet = false
                    }
                    else {
                        if checkdate == now {
                            self.checkedYet = true
                            self.dailyCheckInButton.backgroundColor = UIColor(colorLiteralRed: 153/255, green: 153/255, blue: 153/255, alpha: 1)
                        }
                        else {
                            self.checkedYet = false
                        }
                    }
                    let name = value!["username"] as? String
                    let email = value!["email"] as? String
                    
                    let pictureURL = value?["ProfileImageUrl"] as? String
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
                let uid = user.uid
                for profile in user.providerData {
                    let name = profile.displayName
                    let email = profile.email
                    self.userEmail!.text = email
                    self.userName!.text = name
                    let userID = profile.uid as String
                    
                    ref.child("Users").child(uid).observeSingleEvent(of: .value, with: {
                        snapshot in
                        let value = snapshot.value as? NSDictionary
                        
                        let checkdate = value?["Last Checked In"] as? String
                        if checkdate == nil{
                            self.checkedYet = false
                        }
                        else {
                            if checkdate == now {
                                self.checkedYet = true
                                self.dailyCheckInButton.backgroundColor = UIColor(colorLiteralRed: 153/255, green: 153/255, blue: 153/255, alpha: 1)
                            }
                            else {
                                self.checkedYet = false
                            }
                        }
                    })
                    //Get the user's Profile Image
                    
                    let pictureURL = URL(string: "http://graph.facebook.com/\(userID)/picture?type=large")
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
