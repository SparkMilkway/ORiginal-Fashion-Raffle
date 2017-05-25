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





class guestVC: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource {

    
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var profileBackground: UIImageView!
    
    
    @IBOutlet weak var following: UILabel!
    
    @IBOutlet weak var followers: UILabel!

    @IBOutlet weak var brandsCollectionView: UICollectionView!

    @IBOutlet weak var tempL: UILabel!
    
    @IBOutlet weak var guestProfilSegmentControl: UISegmentedControl!
    
    var brandDatas = [String]()
    var followingBrands = [String]()
    let storageReference = FIRStorage.storage()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
       
        
        

        profileImageView()
        backgroundImageView()
        self.guestProfilSegmentControl.selectedSegmentIndex = 0
        
        
        

        // Do any additional setup after loading the view.
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
