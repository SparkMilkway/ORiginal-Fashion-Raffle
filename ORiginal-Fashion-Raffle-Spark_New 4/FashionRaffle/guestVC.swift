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

var followingArray = [String]()
var followerArray = [String]()

enum ActionButtonState: String {
    case CurrentUser = "Edit Profile"
    case NotFollowing = "+ Follow"
    case Following = "✓ Following"
}




class guestVC: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource, UITextViewDelegate {

    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileBackground: UIImageView!
    

    @IBOutlet weak var brandsCollectionView: UICollectionView!

    @IBOutlet weak var bio: UITextView!
    
    
    @IBOutlet weak var infoVE: UIVisualEffectView!
    
    @IBOutlet weak var guestProfilSegmentControl: UISegmentedControl!
    
    @IBOutlet weak var actionButton: UIButton!
    var brandDatas = [String]()
    var followingBrands = [String]()
    let storageReference = FIRStorage.storage()
    var fingArray = [String]()
    var ferArray = [String]()

    var userProfile: Profile? // Fetch a user's profile if necessary

    
    @IBOutlet weak var followingButton: UIButton!
    
    @IBOutlet weak var followerButton: UIButton!
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
        
       
        infoVE.alpha = 0.5
        
        actionButton.layer.cornerRadius = 3

        self.brandsCollectionView.delegate = self
        self.brandsCollectionView.dataSource = self

        self.navigationController?.navigationBar.tintColor = UIColor.black
        
        self.navigationItem.title = guestname.last?.uppercased()
        
        
        ref.child("Users").child(guestId.last!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String: Any]
            
            self.userProfile = Profile.initWithUserID(userID: guestId.last!, profileDict: value!)
            
            
            if let profileUrl = self.userProfile?.profilePicUrl{
                self.profileImage.setImage(url: profileUrl)
            }
            else {
                self.profileImage.image = UIImage(named:"background")
            }
            if let bgUrl = self.userProfile?.backgroundPictureUrl{
                self.profileBackground.setImage(url: bgUrl)
            }
            else {
                self.profileBackground.image = UIImage(named:"background")
            }
            if let fingArray = self.userProfile?.following{
                self.fingArray = fingArray
                self.followingButton.setTitle("Following: " + String(self.fingArray.count), for: .normal)
                
                if self.fingArray.count == 0 {
                    self.followingButton.isUserInteractionEnabled = false
                }
                
                
            }
            if let ferArray = self.userProfile?.followers{
                self.ferArray = ferArray
                self.followerButton.setTitle("Followers: " + String(self.ferArray.count), for: .normal)
                if self.ferArray.count == 0 {
                    self.followerButton.isUserInteractionEnabled = false

                }

            }
            if let bio = self.userProfile?.bio{
                if let web = self.userProfile?.website{
                    self.bio.text = bio + "\n" + web
                }
                else{
                    self.bio.text = bio
                }
            }else {
                if let web = self.userProfile?.website{
                    self.bio.text = web
                }
                else{
                    self.bio.isHidden = true
                }
            }
            
            
            followingArray = self.fingArray
            followerArray = self.ferArray
            
            self.followingBrands = value?["followBrands"] as! [String]
            self.brandDatas = self.followingBrands
            
            
            
                
            
            
            self.brandsCollectionView.reloadData()


        }) { (error) in
            print(error.localizedDescription)
        }
        
        let guestTmp = guestId.last as! String

        profileImageView()
        backgroundImageView()
        self.guestProfilSegmentControl.selectedSegmentIndex = 0
        
        
        print(self.fingArray , "===",self.ferArray,"???", followerArray, "===", followingArray)
        self.actionButtonState = .CurrentUser
        if guestTmp != Profile.currentUser?.userID {
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
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:])
        return false
    }
    
    @IBAction func followerTapped(_ sender: Any) {
        
        userId = guestId.last!
        category = "followers"
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersVCTableViewController
        self.navigationController?.pushViewController(followers, animated: true)
    }
    
    @IBAction func followingTapped(_ sender: Any) {
        userId = guestId.last!
        category = "followings"
        let followers = self.storyboard?.instantiateViewController(withIdentifier: "followersVC") as! followersVCTableViewController
        self.navigationController?.pushViewController(followers, animated: true)

    }
    
    @IBAction func actionButton(_ sender: AnyObject) {
        switch actionButtonState {
        case .CurrentUser:
            actionButtonState = .CurrentUser
        case .NotFollowing:
            actionButtonState = .Following
            Profile.currentUser?.following.append(guestId.last!)
            
            userProfile?.followers.append(Profile.currentUser!.userID)
            userProfile?.sync()
            Profile.currentUser?.sync()
            
            

        case .Following:
            actionButtonState = .NotFollowing
            if let index = Profile.currentUser?.following.index(of: guestId.last!) {
                Profile.currentUser?.following.remove(at: index)
            }
            
            if let index = userProfile?.followers.index(of: (Profile.currentUser?.userID)!) {
                userProfile?.followers.remove(at: index)
                
            }
            userProfile?.sync()
            Profile.currentUser?.sync()
            
           
        }
        
    }
    
    
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        followingArray = self.fingArray
        followerArray = self.ferArray
        
        print(self.fingArray , "===",self.ferArray,"???", followerArray, "===", followingArray)

        return self.brandDatas.count
    }
    
    
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var brandURL = [String]()

        let brandCell = collectionView.dequeueReusableCell(withReuseIdentifier: "brand", for: indexPath) as! brandCollectionViewCell
        
        
     
        
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
