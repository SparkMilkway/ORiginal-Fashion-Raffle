//
//  profileMainViewController.swift
//  FashionRaffle
//
//  Created by Mac on 5/6/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorageUI
import SVProgressHUD
import PassKit


class profileMainViewController: UIViewController {
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileBackground: UIImageView!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var following: UILabel!
    
    @IBOutlet weak var followers: UILabel!
    
    @IBOutlet weak var brandsContainerView: UIView!

    @IBOutlet weak var Controller: UISegmentedControl!
    
    @IBOutlet weak var userPostContainerView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        let username = Profile.currentUser?.username
        if let picture = Profile.currentUser?.picture {
            self.profileImage.image = picture
        }
        else {
            self.profileImage.image = UIImage(named: "background")
        }
        
        self.userName!.text = username
        self.profileBackground.image = UIImage(named: "background")
        
        
        self.Controller.selectedSegmentIndex = 0
        brandsContainerView.isHidden = true
        userPostContainerView.isHidden = false


        
        
        profileImageView()
        backgroundImageView()

        // Do any additional setup after loading the view.
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
    @IBAction func changeView(_ sender: Any) {
        if Controller.selectedSegmentIndex == 0{
            userPostContainerView.isHidden = false
            brandsContainerView.isHidden = true
        }
        if Controller.selectedSegmentIndex == 1{
            userPostContainerView.isHidden = true
            brandsContainerView.isHidden = false
        }
        
    }
    func profileImageView() {
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        profileImage.layer.backgroundColor = UIColor.white.cgColor
        profileImage.layer.borderWidth = 2
        
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        profileImage.isUserInteractionEnabled = true
        
        
    }
    
    func uploadProfileImage(){
        Profile.currentUser?.picture = self.profileImage.image
        SVProgressHUD.show(withStatus: "Uploading...")
        Profile.currentUser?.sync()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
            
            SVProgressHUD.showSuccess(withStatus: "Uploaded!")
            SVProgressHUD.dismiss(withDelay: 1.5)
        })
        
    }
    
    func backgroundImageView() {
        
        
        profileBackground.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectProfileImageView)))
        profileBackground.isUserInteractionEnabled = true
        profileBackground.contentMode = .scaleAspectFill
        
    }

    
    

}
