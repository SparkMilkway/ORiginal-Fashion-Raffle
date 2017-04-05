//
//  LoginVCFunctions.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 3/2/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import SVProgressHUD

extension LoginViewController {
    func handleLoginRegister(){
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0{
            handleLogin()
        } else {
            handleRegister()
        }
    }

    func handleLogin() {
        if emailTextField.text == "" || passwordTextField.text == "" {
            SettingsLauncher().showAlerts(title: "Oops", message: "Please enter valid values!", handler: nil, controller: self)
        }
        else {
            self.view.endEditing(true)
            let email = emailTextField.text, password = passwordTextField.text
            FIRAuth.auth()?.signIn(withEmail: email!, password: password!, completion: { (user, error) in
                if error != nil {
                    SettingsLauncher().showAlerts(title: "Oops!", message: (error?.localizedDescription)!, handler: nil, controller: self)
                }
                else {
                    guard let uid = user?.uid else{
                        return
                    }
                    SVProgressHUD.show(withStatus: "Logging in...")
                    let ref = FIRDatabase.database().reference()
                    ref.child("Users").child(uid).observeSingleEvent(of:.value, with: {
                        snapshot in
                        guard let profileinfo = snapshot.value as? [String:Any] else{
                            print("Fatal error happened in Database, can't retrieve user data.")
                            return
                        }
                        let newuser = Profile.initWithUserID(userID: uid, profileDict: profileinfo)
                        Profile.currentUser = newuser
                    })
                    SVProgressHUD.showSuccess(withStatus: "Welcome Back!")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                        self.loginSuccess()
                    })
                }
            })
        }
    }
    
    func handleRegister() {
        if emailTextField.text == "" || passwordTextField.text == "" || nameTextField.text == ""
        {
            SettingsLauncher().showAlerts(title: "Oops!", message: "Please enter valid values!", handler: nil, controller: self)
        }
        else {
            self.view.endEditing(true)
            let email = emailTextField.text! as String, password = passwordTextField.text, name = nameTextField.text! as String
            FIRAuth.auth()?.createUser(withEmail: email, password: password!, completion: {(user, error) in
                if error != nil {
                    SettingsLauncher().showAlerts(title: "Oops!", message: (error?.localizedDescription)!, handler: nil, controller: self)
                }
                else {
                    guard let uid = user?.uid else{
                        return
                    }
                    SVProgressHUD.show(withStatus: "Registering...")
                    let newprofile = Profile.newUser(username: name, userID: uid, email: email)
                    Profile.currentUser = newprofile
                    //sync to database
                    newprofile.sync()
                    SVProgressHUD.showSuccess(withStatus: "Success!")
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                        self.loginSuccess()
                    })
                }
            })
        }
    }

    
    
    
    // function that handle the segments
    func handleLoginRegisterChange(){
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        //change height of inputcontainerview
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        //change height of nametextfield
        
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            nameTextField.isHidden = true
        }
        else {
            nameTextField.isHidden = false
            
        }
        nameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
    }
    
    //Login Func
    
    func loginSuccess() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        SVProgressHUD.dismiss()
        self.present(tabBarController, animated: true, completion: nil)
    }
    
    
    func setUpLoginRegisterSegmentControl(){
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    

    
    func setUpInputsContainerView(){
        //need x,y,width, height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier:0.9, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 100)
        inputsContainerViewHeightAnchor?.isActive = true
        
        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)
        
        
        
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant:12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -10).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 0)
        nameTextFieldHeightAnchor?.isActive = true
        nameTextField.isHidden = true
        
        
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant:12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -10).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
        emailTextFieldHeightAnchor?.isActive = true
        
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant:12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, constant: -10).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
        passwordTextFieldHeightAnchor?.isActive = true
        
        
    }
    
    func setUpLoginRegisterButton(){
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
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
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error?) {
        self.fbLoginButton.isHidden = true
        if error == nil {
            SVProgressHUD.show(withStatus: "Logging in...")
            let ref = FIRDatabase.database().reference()
            // link with Firebase!
            if let current = FBSDKAccessToken.current() {
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: current.tokenString)
                FIRAuth.auth()?.signIn(with: credential, completion: {(user, error) in
                    if error == nil{
                        
                        
                        let userID = user?.uid
                        ref.child("Users").child(userID!).observeSingleEvent(of: .value, with: {
                            snapshot in
                            guard let profilevalue = snapshot.value as? [String:Any] else{
                                print("No record in database, will create one")
                                for profile in (user?.providerData)! {
                                    let name = profile.displayName
                                    let email = profile.email
                                    let uid = profile.uid as String
                                    let newuser = Profile.newUser(username: name, userID: userID, email: email)
                                    
                                    guard let imageURL = URL(string: "http://graph.facebook.com/\(uid)/picture?type=large") else{
                                        print("Can't retrieve the profile image URL.")
                                        return
                                    }
                                    let imagedata = try? Data(contentsOf: imageURL)
                                    let image = UIImage(data: imagedata!)
                                    newuser.picture = image
                                    Profile.currentUser = newuser
                                    newuser.sync()
                                    
                                }
                                return
                            }
                            Profile.currentUser = Profile.initWithUserID(userID: userID!, profileDict: profilevalue)
                        })
                        
                        
                        /*
                         let currentUser = Profile.currentUser
                         print(currentUser?.username)
                         print(currentUser?.userID)
                         print(currentUser?.checkInCount)
                         print(currentUser?.lastCheckDate)
                         print(currentUser?.email)
                         print(currentUser?.tickets)
                         print(currentUser?.editor)
                         */
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                            self.loginSuccess()
                        })
                    }
                    else {
                        self.fbLoginButton.isHidden = true
                        SettingsLauncher().showAlerts(title: "Oops!", message: (error?.localizedDescription)!, handler: nil, controller: self)
                    }
                })
                print("successfully logged in with Facebook")
            }
            else{
                self.fbLoginButton.isHidden = false
            }
            
        }
        else {
            self.fbLoginButton.isHidden = false
            return}
        
        
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
    
    
    
}
