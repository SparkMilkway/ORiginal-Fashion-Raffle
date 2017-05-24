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
import Cache
import PassKit
import Imaginary

class SettingTableViewController: UITableViewController, FBSDKLoginButtonDelegate, PKPaymentAuthorizationViewControllerDelegate {
    
    var paymentRequest : PKPaymentRequest!
    
    @IBOutlet weak var changeImage: UITextField!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var checkCount: UILabel!
    
    
    
    //Check in Begin
 
    @IBOutlet weak var addNews: UIBarButtonItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let currentDate = Date().now()
        let currentUser = Profile.currentUser
        if let checkInCount = currentUser?.checkInCount {
            if currentDate != currentUser?.lastCheckDate {
                currentUser?.checkInCount = checkInCount + 1
                currentUser?.lastCheckDate = currentDate
                currentUser?.sync()
                Profile.currentUser = currentUser
            }
            if Profile.currentUser?.checkInCount == 1 {
                self.checkCount!.text = "You've checked in 1 day."
            }
            else {
                self.checkCount!.text = "You've checked in \((Profile.currentUser?.checkInCount)!) days."
            }
            
        }

    }
    
    //Check in ends
    

    //Email Log out Begin
    
    @IBOutlet weak var emailLogOutButton: UIButton!
    
    @IBAction func emailLogOut(_ sender: Any) {
        SettingsLauncher.showAlertsWithOptions(title: "", message: "Are you sure to sign out?", controller: self, yesHandler: {
            UIAlertAction in
            try! FIRAuth.auth()?.signOut()
            self.logOut()
            
        }, cancelHandler: nil)

    }
    //Ends
    
    @IBOutlet var fbLogoutButton: FBSDKLoginButton! = {
       let button = FBSDKLoginButton()
        return button
    }()
    
    @IBAction func checkTickets(_ sender: Any) {
        let tickets:Int = (Profile.currentUser?.tickets)!
        SettingsLauncher.showAlerts(title: "Raffle Tickets", message: "You have \(tickets) raffle tickets.", handler: nil, controller: self)
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
            SettingsLauncher.showAlerts(title: "Oops", message: "You need to set up Apple Pay!", handler: nil, controller: self)
        }
    }
    func purchaseSuccess() {
        var tickets:Int = (Profile.currentUser?.tickets)!
        tickets = tickets + 1
        // Every time there is an update to the class, current user needs to be updated
        Profile.currentUser?.tickets = tickets
        Profile.currentUser?.sync()
        SettingsLauncher.showAlerts(title: "Purchase Success!", message: "Enjoy your raffle!", handler: nil, controller: self)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didSelect shippingMethod: PKShippingMethod, completion: @escaping (PKPaymentAuthorizationStatus, [PKPaymentSummaryItem]) -> Void) {
        completion(PKPaymentAuthorizationStatus.success, itemToSell())
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        completion(PKPaymentAuthorizationStatus.success)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        fbLogoutButton.delegate = self

        navigationController?.navigationBar.backgroundColor = UIColor.white
        
        let now = Date().now()
        self.dateLabel.text = now
        profileImageView()
        if FBSDKAccessToken.current() == nil{
            self.fbLogoutButton.isHidden = true
            self.emailLogOutButton.isHidden = false
        }
        else {
            self.fbLogoutButton.isHidden = false
            self.emailLogOutButton.isHidden = true
        }
        let username = Profile.currentUser?.username
        let email = Profile.currentUser?.email
        if let profileUrl = Profile.currentUser?.profilePicUrl {
            self.profileImage.setImage(url: profileUrl)
        }
        else {
            self.profileImage.image = UIImage(named: "UserIcon")
        }
        self.userName!.text = username
        self.userEmail!.text = email

        if Profile.currentUser?.editor == true {
            print("Is Editor")
            self.title = "Editor Profile"
            
            self.addNews.isEnabled = true
            self.addNews.tintColor = UIColor.black
        }
        else {
            print("Not Editor")
            self.title = "User Profile"
            self.addNews.isEnabled = false
            self.addNews.tintColor = self.navigationController?.navigationBar.tintColor
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // ProfileImageView
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
    
    // Upload the Image to database
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
