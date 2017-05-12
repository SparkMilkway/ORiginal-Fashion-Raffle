//
//  SocialTableViewController.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 3/14/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorageUI
import SVProgressHUD
import Cache

class PostFeedTableViewController: UITableViewController {
    
    var postFeeds: [Post] = []
    let postRef = FIRDatabase.database().reference().child("Posts")
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false

        ref.child("Posts").queryOrderedByKey().observe(.childAdded, with: {
            snapshot in
            guard let postFeed = snapshot.value as? [String:Any] else {
                print("No Data here! Fatal error with Firebase NewsFeed Data")
                return
            }
            
            let postID = snapshot.key //get newsID
            let time = postFeed["timestamp"] as? String
            let newPost = Post.initWithPostID(postID: postID, postDict: postFeed)
            newPost?.timestamp = time!
            self.postFeeds.insert(newPost!, at: 0)
            self.tableView.reloadData()

            
        })
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.postFeeds.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = self.postFeeds[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostPoolCell
        cell.captionLabel.text = post.caption
        cell.imgView.image = post.image
        cell.userNameLabel.text = post.creator
        cell.timeStamp.text = post.timestamp
        cell.profileImage.image = post.profileImage
        
        
        return cell
    }
    /*
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = self.postFeeds[indexPath.section]
        let img = post.image
        let ratio = img.size.height/img.size.width
        return tableView.frame.size.width * ratio + 40
        
    }
    */
    func postIndex(cellIndex:Int) -> Int {
        return tableView.numberOfSections - cellIndex - 1
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        
    }
}
