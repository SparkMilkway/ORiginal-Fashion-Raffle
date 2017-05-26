//
//  followersVCTableViewController.swift
//  FashionRaffle
//
//  Created by Mac on 5/25/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
var userId = String()
var category = String()


class followersVCTableViewController: UITableViewController {
    var userIdArray = [String]()
    var userPicArray = [String]()
    var followArray = [String]()
    var userProfile: Profile? // Fetch a user's profile if necessary



    override func viewDidLoad() {
        super.viewDidLoad()
        print(followerArray, "===!!!!!!!!!!!!", followingArray)

        self.navigationItem.title = category.uppercased()
        print(category)
        if category == "followers" {
            loadFollowers()
        }
        if category == "followings"{
            loadFollowings()
        }
    }
    
    func loadFollowers(){
        print("followers")
        ref.child("Users").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String: Any]
            
            self.userProfile = Profile.initWithUserID(userID: userId, profileDict: value!)
            self.followArray = (self.userProfile?.followers)!
            print(self.followArray)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func loadFollowings(){
        print("following")
        ref.child("Users").child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String: Any]
            
            self.userProfile = Profile.initWithUserID(userID: userId, profileDict: value!)
            self.followArray = (self.userProfile?.following)!
            print(self.followArray)
        }) { (error) in
            print(error.localizedDescription)
        }
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        print(followArray.count)
        return followArray.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.width / 4
    }




}
