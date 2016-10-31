//
//  SecondViewController.swift
//  FashionRaffle
//
//  Created by Mac on 2016/10/28.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit
import Firebase

class SecondViewController: UIViewController, FBSDKLoginButtonDelegate {



    @IBOutlet weak var emailSignOutButton: UIButton!
    @IBAction func emailSignOut(_ sender: AnyObject) {
        //self.logOut()
    

    
        //try! FIRAuth.auth()?.signOut()
        
        let refreshAlert = UIAlertController(title: "Sign Out", message: "Are you sure to sign out?", preferredStyle: .alert)
      
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) -> Void in
            try! FIRAuth.auth()?.signOut()
            self.logOut()
            
        }))
        present(refreshAlert, animated: true, completion: nil)
        
}

    @IBOutlet var fbLoginButton : FBSDKLoginButton! = {
        let button = FBSDKLoginButton()
        //button.readPermissions = ["email"]
        return button
    }()
    
    
    
    func logOut() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as UIViewController
        self.present(viewController, animated: true, completion: nil)
        print("Logged Out!")
    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        fbLoginButton.delegate = self
        
        if FBSDKAccessToken.current() == nil{
            fbLoginButton.isHidden = true
        }
        if let user = FIRAuth.auth()?.currentUser{
            self.emailSignOutButton.isHidden = false
        }   else {
            self.emailSignOutButton.isHidden = true
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error) {
        
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        self.logOut()
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }

}

