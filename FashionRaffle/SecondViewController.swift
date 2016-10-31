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



    @IBOutlet weak var emailSignOut: UIButton!
   /* @IBAction func emailLogOut(_ sender: AnyObject) {
        let refreshAlert = UIAlertController(title: "Sign Out", message: "Are you sure to sign out?", preferredStyle: .alert)
      
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) -> Void in
            //try! FIRAuth.auth()?.signOut()
            self.fbLogOut()
            
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        
        present(refreshAlert, animated: true, completion: nil)
        
    }*/
    
    @IBOutlet var fbLoginButton : FBSDKLoginButton! = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
    
    
    func fbLogOut() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as UIViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = viewController
        print("Logged Out!")
    }
    
    override func viewDidLoad() {
        
        
        
        
        
        super.viewDidLoad()
        fbLoginButton.delegate = self
        
        if FBSDKAccessToken.current() == nil{
            fbLoginButton.isHidden = true
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
        self.fbLogOut()
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }

}

