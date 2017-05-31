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
        cell.label.text  = followArray[indexPath.row]
        
        return cell
    }

}
