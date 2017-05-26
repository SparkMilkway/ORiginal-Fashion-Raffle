//
//  guestVC.swift
//  FashionRaffle
//
//  Created by Mac on 5/24/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Firebase
var guestname = [String]()
var guestId = [String]()
var followingBrand = [String]()

enum ActionButtonState: String {
    case CurrentUser = "Edit Profile"
    case NotFollowing = "+ Follow"
    case Following = "✓ Following"
}




class guestVC: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileBackground: UIImageView!
    
    
    @IBOutlet weak var following: UILabel!
    
    @IBOutlet weak var followers: UILabel!

    @IBOutlet weak var brandsCollectionView: UICollectionView!

    @IBOutlet weak var tempL: UILabel!
    
    @IBOutlet weak var guestProfilSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var actionButton: UIButton!
    var brandDatas = [String]()
    var followingBrands = [String]()
    let storageReference = FIRStorage.storage()
    
    var actionButtonState: ActionButtonState = .CurrentUser {
        willSet(newState) {
            switch  newState {
            case .CurrentUser:
                actionButton.backgroundColor = UIColor.blue
                actionButton.layer.borderWidth = 1
                
            case .NotFollowing:
                actionButton.backgroundColor = UIColor.white
                actionButton.layer.borderColor = UIColor.gray.cgColor
                actionButton.layer.borderWidth = 1
            case .Following:
                actionButton.backgroundColor = UIColor.red
                actionButton.layer.borderWidth = 0
            }
            actionButton.setTitle(newState.rawValue, for: UIControlState())
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        actionButton.layer.cornerRadius = 3

        self.brandsCollectionView.delegate = self
        self.brandsCollectionView.dataSource = self

        
        self.navigationItem.title = guestname.last?.uppercased()
        
        ref.child("Users").child(guestId.last!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            
            
            if let profileUrl = NSURL(string: value?["profilePicUrl"] as! String) {
            
                self.profileImage.setImage(url: profileUrl as URL)
            } else {
                self.profileImage.image = UIImage(named: "UserIcon")
            }
            
            
            if let bgpicUrl = NSURL(string: value?["backgroundPictureUrl"] as! String){
            
                self.profileBackground.setImage(url: bgpicUrl as URL)
            } else {
                self.profileBackground.image = UIImage(named: "background")
            }
            
            
            self.followingBrands = value?["followBrands"] as! [String]
            self.brandDatas = self.followingBrands
            
            print(self.brandDatas, "SSSSSSSSS")
            
            
                
            
            
            self.brandsCollectionView.reloadData()


        }) { (error) in
            print(error.localizedDescription)
        }
       
        
        let guestTmp = guestId.last as! String

        profileImageView()
        backgroundImageView()
        self.guestProfilSegmentControl.selectedSegmentIndex = 0
        
        
        print(guestTmp, "===???", Profile.currentUser?.userID)
        self.actionButtonState = .CurrentUser
        if guestTmp != Profile.currentUser?.userID {
            print("currentUser")
            if (Profile.currentUser?.following.contains(guestTmp))! {
                // Following
                self.actionButtonState = .Following
            } else {
                // Not following
                self.actionButtonState = .NotFollowing
            }
        }


        // Do any additional setup after loading the view.
    }
    
    @IBAction func actionButton(_ sender: AnyObject) {
        switch actionButtonState {
        case .CurrentUser:
            actionButtonState = .CurrentUser
        case .NotFollowing:
            actionButtonState = .Following
            Profile.currentUser?.following.append(guestId.last!)
            print(guestId.last!, "???")
            //userProfile?.followers.append(Profile.currentUser!.username)
            //userProfile?.sync()
            Profile.currentUser?.sync()
        case .Following:
            actionButtonState = .NotFollowing
            if let index = Profile.currentUser?.following.index(of: guestId.last!) {
                Profile.currentUser?.following.remove(at: index)
            }
            //if let index = userProfile?.followers.index(of: (Profile.currentUser?.username)!) {
              //  userProfile?.followers.remove(at: index)
            //}
            //userProfile?.sync()
            Profile.currentUser?.sync()
        }
        
    }
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.brandDatas.count
    }
    
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var brandURL = [String]()

        let brandCell = collectionView.dequeueReusableCell(withReuseIdentifier: "brand", for: indexPath) as! brandCollectionViewCell
        
        
     
            print(self.brandDatas[indexPath.row])
            
            ref.child("Brands").child(self.brandDatas[indexPath.row]).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
 
                let brandPicURL = value!["Logo"] as! String
                //brandURL.append(brandPicURL)
                let storage = self.storageReference.reference(forURL: brandPicURL)
                brandCell.brandImage.sd_setImage(with: storage)

            }) { (error) in
                print(error.localizedDescription)
            }
        
        //let imgURL = self.brandURL[1]
        
        
        
        
        brandCell.layer.borderColor = UIColor.lightGray.cgColor
        brandCell.layer.borderWidth = 1
        brandCell.visualEffectView.alpha = 0
        brandCell.layer.cornerRadius = 50
        
        brandCell.brandImage.contentMode = .scaleAspectFit
        return brandCell
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func profileImageView() {
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.contentMode = .scaleAspectFill
        profileImage.layer.cornerRadius = profileImage.frame.size.width / 2
        profileImage.clipsToBounds = true
        profileImage.layer.backgroundColor = UIColor.white.cgColor
        profileImage.layer.borderWidth = 2
        profileImage.layer.borderColor = UIColor.white.cgColor
        
        
    }
    func backgroundImageView() {
        
        
        
        profileBackground.contentMode = .scaleAspectFill
        profileBackground.alpha = 0.8
        
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
