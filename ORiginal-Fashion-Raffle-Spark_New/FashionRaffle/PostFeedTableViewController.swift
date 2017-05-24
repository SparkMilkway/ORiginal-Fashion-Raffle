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
import SVProgressHUD
import Cache
import Imaginary

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

        //SettingsLauncher.showLoading(Status: "Loading...")
        ref.child("Posts").queryOrderedByKey().observe(.childAdded, with: {
            snapshot in
            guard let postFeed = snapshot.value as? [String:Any] else {
                print("No Data here!")
                return
            }
            let postID = snapshot.key
            let newPost = Post.initWithPostID(postID: postID, postDict: postFeed)
            self.postFeeds.insert(newPost!, at: 0)
            self.tableView.reloadData()
            //SettingsLauncher.dismissLoading()
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
        let imageUrl = post.imageUrl
        cell.imgView.setImage(url: imageUrl)
        cell.userNameLabel.text = post.creator
        cell.timeStamp.text = post.timestamp
        if let profileUrl = post.profileImageUrl {
            cell.profileImage.setImage(url: profileUrl)
        }

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
