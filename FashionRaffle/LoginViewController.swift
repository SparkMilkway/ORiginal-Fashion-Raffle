//
//  LoginViewController.swift
//  FashionRaffle
//
//  Created by Mac on 2016/10/28.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    
    @IBAction func moveToTabBar(_ sender: Any) {
        loginSuccess()
    }
    
    func loginInFailed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginVC") as UIViewController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = viewController
        print("Login Failed!")
    }
    
    func loginSuccess() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = tabBarController
    }
    
    /*@IBAction func fbLoginAction (sender:AnyObject){
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self, handler: {(result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                if (fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                }
            }
        })
    }*/
    
    
    @IBOutlet var fbLoginButton : FBSDKLoginButton! = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start{ (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    print(result)
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        fbLoginButton.delegate = self
        applyMotionEffect(toView:logoImageView, magnitude: -20)
    
        applyMotionEffect(toView:backgroundImageView, magnitude: 10)
        
        if let _ = FBSDKAccessToken.current(){
            getFBUserData()
            loginSuccess()
            
        }
        
        
        let attributedString = NSAttributedString(string:"Forgot your password?", attributes:[NSForegroundColorAttributeName:UIColor.white, NSUnderlineStyleAttributeName:1])
        passwordButton.setAttributedTitle(attributedString, for: .normal)
        
        
        
    }
    
    func applyMotionEffect (toView view:UIView, magnitude:Float){
        let xMotion = UIInterpolatingMotionEffect(keyPath:"center.x", type:.tiltAlongHorizontalAxis)
        xMotion.minimumRelativeValue = -magnitude
        xMotion.maximumRelativeValue = magnitude
        
        let yMotion = UIInterpolatingMotionEffect(keyPath:"center.y", type:.tiltAlongVerticalAxis)
        yMotion.minimumRelativeValue = -magnitude
        yMotion.maximumRelativeValue = magnitude
        
        let group = UIMotionEffectGroup()
        group.motionEffects = [xMotion,yMotion]
        
        
        view.addMotionEffect(group)
        
        
    }

    //Facebook Login Button Delegate
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error) {
        loginSuccess()
        print("successfully logged in with Facebook")

        
    }
    
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
