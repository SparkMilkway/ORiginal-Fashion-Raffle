//
//  LoginViewController.swift
//  FashionRaffle
//
//  Created by OneSpark Mac on 2016/10/28.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet var addForgetPasswordView: UIView!
    
    @IBOutlet weak var forgetPasswordTextField: UITextField!
    @IBOutlet weak var passwordButton: UIButton!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.black
        button.setTitle("Login", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        return button
    }()
    
    
    func handleLoginRegister(){
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0{
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin(){

        if emailTextField.text == "" || passwordTextField.text == "" {
            self.showAlerts(title: "Oops!", message: "Please enter values!", handler: nil)
        }
        
        else {
            let email = emailTextField.text, password = passwordTextField.text
            FIRAuth.auth()?.signIn(withEmail: email!, password: password!, completion: { (user, error) in
                
                if error == nil {
                    self.showAlerts(title: "Success!", message: "Welcome Back!", handler: {
                        UIAlertAction in
                        self.loginSuccess()
                    })
                }
                    
                else {
                    self.showAlerts(title: "Oops!", message: (error?.localizedDescription)!, handler: nil)
                    return
                }
                //successfully logged in our user
            })
        }
    }
    
    func handleRegister() {

        if emailTextField.text == "" || passwordTextField.text == "" || nameTextField.text == ""
        {
            self.showAlerts(title: "Oops!", message: "Please enter values!", handler: nil)
            
        }
            //Create an account
        else{
            
            let email = emailTextField.text, password = passwordTextField.text, name = nameTextField.text
            let raffleTicket = "0";
            FIRAuth.auth()?.createUser(withEmail: email!, password: password!, completion: {(user, error) in
                if error == nil{
                    
                    //successfully register
                    guard let uid = user?.uid else{
                        return
                    }
                    
                    // put the values into Firebase Auth
                    let ref = FIRDatabase.database().reference()
                    let values = ["name": name, "email":email, "userID": uid, "raffleTicket": raffleTicket]
                    let usersReference = ref.child("Users/EmailUsers").child(uid)
                    
                    usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                        
                        if err != nil{
                            self.showAlerts(title: "Oops!", message: (error?.localizedDescription)!, handler: nil)
                            return
                        }
                    })
                    
                    self.showAlerts(title: "Success!", message: "Your account is successfully created! You can sign in now!", handler: {
                        UIAlertAction in
                        self.loginSuccess()
                    })
                }
                else {
                    self.showAlerts(title: "Oops!", message: (error?.localizedDescription)!, handler: nil)
                }
            })
        }
        
        
        
    }
    
    
    
    
    let forgotPasswordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Forgot your password?"
        return tf
    }()
    
    let nameTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameSeparatorView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let emailSeparatorView:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let passwordTextField:UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        return tf
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 0
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return sc
    }()
    
    
    
    
    func handleLoginRegisterChange(){
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        //change height of inputcontainerview
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        //change height of nametextfield
        
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            nameTextField.placeholder = ""
        }
        else {
            nameTextField.placeholder = "Name"
        }
        nameTextFieldHeightAnchor?.isActive = true
        
        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        
        
        
        
    }
    
    func loginSuccess() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        self.present(tabBarController, animated: true, completion: nil)
    }
    
    
    //facebook login button
    @IBOutlet var fbLoginButton : FBSDKLoginButton! = {
        let button = FBSDKLoginButton()
        //button.width(equalTo: inputsContainerView.width)
        //button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        button.readPermissions = ["email"]
        return button
    }()
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start{ (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    print(result!)
                }
            }
        }
    }
    
    //FB stuff ends
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Hide the keyboard when tapping around
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
        
        
        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(loginRegisterSegmentedControl)
        
        setUpInputsContainerView()
        setUpLoginRegisterButton()
        setUpLoginRegisterSegmentControl()
        
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)
        
        
        
        // Do any additional setup after loading the view.
        
        fbLoginButton.delegate = self
        applyMotionEffect(toView:logoImageView, magnitude: 5)
        
        applyMotionEffect(toView:backgroundImageView, magnitude: 15)
        //If FB signed in
        if let _ = FBSDKAccessToken.current(){
            getFBUserData()
            
        }
        
        let attributedString = NSAttributedString(string:"Forget your password?", attributes:[NSForegroundColorAttributeName:UIColor.white, NSUnderlineStyleAttributeName:1])
        passwordButton.setAttributedTitle(attributedString, for: .normal)
        
    }
    
    func setUpLoginRegisterSegmentControl(){
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor, multiplier: 1).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
    
    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?
    
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
        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 0)
        nameTextFieldHeightAnchor?.isActive = true
        
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant:12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/2)
        emailTextFieldHeightAnchor?.isActive = true
        
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant:12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
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
    
    //add forgot Password Pop Up
    @IBAction func addForgetPasswordPopUp(_ sender: Any) {
        self.view.addSubview(addForgetPasswordView)
        addForgetPasswordView.center = self.view.center
        addForgetPasswordView.transform = CGAffineTransform.init(scaleX:1.3,y:1.3)
        addForgetPasswordView.alpha = 0
        
        UIView.animate(withDuration:0.4){
            self.addForgetPasswordView.alpha = 1
            self.addForgetPasswordView.transform = CGAffineTransform.identity
        }
    }
    
    
    //do the forget password work and if successfully sent then dismiss the view
    @IBAction func dismissForgetPasswordPopUp(_ sender: Any) {
        if self.forgetPasswordTextField.text == "" {
            self.showAlerts(title: "Oops!", message: "Please enter your email!", handler: nil)
        }
        else{
            FIRAuth.auth()?.sendPasswordReset(withEmail: self.forgetPasswordTextField.text!, completion: {(error) in
                var title = ""
                var message = ""
                if error != nil {
                    title = "Oops!"
                    message = (error?.localizedDescription)!
                    self.showAlerts(title: title, message: message, handler: nil)
                    
                }
                else {
                    title = "Success!"
                    message = "The password reset email was sent!"
                    self.forgetPasswordTextField.text = ""
                    self.showAlerts(title: title, message: message, handler: {
                        UIAlertAction in
                        UIView.animate(withDuration:0.3, animations:{
                            self.addForgetPasswordView.transform = CGAffineTransform.init(scaleX:1.3,y:1.3)
                            self.addForgetPasswordView.alpha = 0
                        }) {(success:Bool) in
                            self.addForgetPasswordView.removeFromSuperview()
                        }
                        
                    })
                }
            })
        }
        
    }
    //Directly dismiss the password reset view
    @IBAction func dismissPasswordReset(_ sender: AnyObject) {
        UIView.animate(withDuration:0.3, animations:{
            self.addForgetPasswordView.transform = CGAffineTransform.init(scaleX:1.3,y:1.3)
            self.addForgetPasswordView.alpha = 0
        }) {(success:Bool) in
            self.addForgetPasswordView.removeFromSuperview()
        }
    }
    
    
    
    
    
    
    //TextFields Edit
    
    func showAlerts(title: String, message: String, handler: ((UIAlertAction) -> Void)?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title:"OK", style: .cancel, handler: handler)
        alertController.addAction(defaultAction)
        self.present(alertController, animated: true, completion: nil)
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
        
        
        // link with Firebase!
        if let _ = FBSDKAccessToken.current(){
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            FIRAuth.auth()?.signIn(with: credential, completion: {(user, error) in
                if error == nil{
                    //self.showAlerts(title: "Success", message: "Welcome Back!")
                    
                    if let user = FIRAuth.auth()?.currentUser {
                        for profile in user.providerData {
                            let providerID = profile.providerID
                            let uid = profile.uid;  // Provider-specific UID
                            let name = profile.displayName
                            let email = profile.email
                            
                            DataBaseStructure().setProvidersInfo(userName: name!, userID: uid, userEmail: email!, ProviderID: providerID)
                        }
                    } else {
                        // No user is signed in.
                        print("No user is signed in")
                    }
                    
                    
                    
                    self.loginSuccess()
                    
                    
                    //Add facebook users to firebase database
                    
                    /*guard let uid = user?.uid else{
                        return
                    }
                    
                    // put the values into Firebase Auth
                    let ref = FIRDatabase.database().reference()
                    let values = ["name": name, "email":email, "userID": uid]
                    let usersReference = ref.child("Users/EmailUsers").child(uid)
                    
                    usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
                        
                        if err != nil{
                            self.showAlerts(title: "Oops!", message: (error?.localizedDescription)!, handler: nil)
                            return
                        }
                    })
                    
                    */
                    
                    
                }
                else {
                    self.showAlerts(title: "Oops!", message: (error?.localizedDescription)!, handler: nil)
                }
            })
            print("successfully logged in with Facebook")
        }
        
        
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