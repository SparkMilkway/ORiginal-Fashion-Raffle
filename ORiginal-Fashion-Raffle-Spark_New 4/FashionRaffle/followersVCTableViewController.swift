//
//  followersVCTableViewController.swift
//  FashionRaffle
//
//  Created by Mac on 5/25/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Foundation

var userId = String()
var category = String()


class followersVCTableViewController: UITableViewController {
    
    var refresher = UIRefreshControl()
    var guestF : [Profile] = []
    
    var userIdArray = [String]()
    var userPicArray = [String]()
    var followArray = [String]()
    var userProfile: Profile? // Fetch a user's profile if necessary
    
    var currentLoad : Int = 1
    var singleLoadLimit: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(followerArray, "===!!!!!!!!!!!!", followingArray)
        
        self.navigationItem.title = category.uppercased()
        print(category)
        if category == "followers" {
            followArray = followerArray
        }
        if category == "followings"{
            followArray = followingArray
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - self.view.frame.size.height * 2 {
            loadMore()
        }
    }
    //pagination
    func loadMore(){
        if currentLoad <= followArray.count {
            currentLoad = currentLoad + singleLoadLimit
            
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(followArray.count)
        return followArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.width / 6
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followerCell", for: indexPath) as! followerVCTableViewCell
        cell.userID.text  = followArray[indexPath.row]
        
        ref.child("Users").child(followArray[indexPath.row]).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String: Any]
            let user = Profile.initWithUserID(userID: self.followArray[indexPath.row], profileDict: value!)
            
            if let profileUrl = user?.profilePicUrl{
                cell.userImg.setImage(url: profileUrl)
                
                cell.userImg.layer.cornerRadius = cell.userImg.frame.height/2
                cell.userImg.clipsToBounds = true
                cell.userID.isHidden = true
            }
            if let userName = user?.username{
                cell.label.text = userName
            }
            if (Profile.currentUser?.following.contains(self.followArray[indexPath.row]))! {
                cell.actionButton.setTitle("Following", for: .normal)
            } else {
                cell.actionButton.setTitle("+ Follow", for: .normal)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        cell.viewProfile.layer.setValue(indexPath, forKey: "index")

        return cell
    }
    
    
    @IBAction func viewProfile(_ sender: AnyObject) {
        print("FUCK U")
        let i = sender.layer.value(forKey: "index") as! IndexPath
        let cell = tableView.cellForRow(at: i) as! followerVCTableViewCell
        guestId.append(cell.userID.text!)
        guestname.append(cell.label.text!)
        let guest = self.storyboard?.instantiateViewController(withIdentifier: "guestVC") as! guestVC
        self.navigationController?.pushViewController(guest, animated: true)

    }
       
    
}
