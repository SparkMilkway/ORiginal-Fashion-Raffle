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




class settingTableViewController: UITableViewController, FBSDKLoginButtonDelegate, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var Website: UITextField!
    
    @IBOutlet weak var Bio: UITextView!
    
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var addNews: UIButton!
    @IBOutlet weak var emailLogoutButton: UIButton!
    
    @IBOutlet weak var dayPicker: UIPickerView!
    var time = [["0 Day", "1 Day", "2 Day", "3 Day", "4 Day", "5 Day","6 Day", "7 Day"],["0 Hour", "1 Hour", "2 Hour", "3 Hour", "4 Hour", "5 Hour", "6 Hour", "7 Hour", "8 Hour", "9 Hour", "10 Hour", "11 Hour", "12 Hour", "13 Hour", "14 Hour", "15 Hour", "16 Hour", "17 Hour", "18 Hour", "19 Hour", "20 Hour", "21 Hour", "22 Hour", "23 Hour"],["0 Minuete", "5 Minuete", "10 Minuete", "15 Minuete", "20 Minuete", "25 Minuete","30 Minuete","35 Minuete","40 Minuete","45 Minuete","50 Minuete","55 Minuete" ]]
    var day = Double()
    var hour = Double()
    var minute = Double()
    
   
    
    @IBAction func emailLogout(_ sender: Any) {
        SettingsLauncher.showAlertsWithOptions(title: "", message: "Are you sure to sign out?", controller: self, yesHandler: {
            UIAlertAction in
            try! FIRAuth.auth()?.signOut()
            self.logOut()
            
        }, cancelHandler: nil)
    }
    
    @IBOutlet weak var setAlarmButton: UIButton!
    
    @IBOutlet weak var alarmCell: UITableViewCell!
    @IBAction func setAlarmButtonTapped(_ sender: Any) {
        
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
        let defaults = UserDefaults.standard
        let Day = defaults.double(forKey: "Day")
        let Hour = defaults.double(forKey: "Hour")
        let minute = defaults.double(forKey: "minute")
        
        dayPicker.selectRow(Int(Day), inComponent: 0, animated: false)
        dayPicker.selectRow(Int(Hour), inComponent: 1, animated: false)
        dayPicker.selectRow(Int(minute/5), inComponent: 2, animated: false)
        
        
        dayPicker.delegate = self
        dayPicker.dataSource = self
        self.Bio.layer.borderWidth = 0.5
        self.Bio.layer.cornerRadius = 5
        self.Bio.layer.borderColor = UIColor.groupTableViewBackground.cgColor
        
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
            if Bio == ""{
                self.Bio.text = "Bio"
                self.Bio.textColor = UIColor.lightGray
            } else {
            self.Bio.text = Bio
            }
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
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return time.count
    }
    func pickerView ( _ dayPicker: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return time[component].count
    }
    
    func pickerView (_ dayPicker: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return time[component][row]
    }
    
    func pickerView (_ dayPicker: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        switch (component){
        case 0:
            day = Double(time[component][row])!
            let defaults = UserDefaults.standard
            defaults.set(day, forKey:"Day")
            print(day)
        case 1:
            hour = Double(time[component][row])!
            print(hour)
            let defaults = UserDefaults.standard
            defaults.set(hour, forKey:"Hour")
        case 2:
            minute = Double(time[component][row])!
            print(minute)
            let defaults = UserDefaults.standard
            defaults.set(minute, forKey:"minute")
        default: break
        }
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
