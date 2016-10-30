//
//  FirstViewController.swift
//  FashionRaffle
//
//  Created by Mac on 2016/10/28.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, FBSDKLoginButtonDelegate {

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
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error) {
        
        print("successfully logged in")
        
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        fbLogOut()
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }

}

