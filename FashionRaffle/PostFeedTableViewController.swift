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

class PostFeedTableViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        if let feed = Post.feed {
            return feed.count
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = Post.feed![postIndex(cellIndex: indexPath.section)]
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostPoolCell
        cell.captionLabel.text = post.caption
        cell.imgView.image = post.image
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let post = Post.feed![postIndex(cellIndex: indexPath.section)]
        let img = post.image
        let ratio = img.size.height/img.size.width
        return tableView.frame.size.width * ratio + 40
        
    }
    
    func postIndex(cellIndex:Int) -> Int {
        return tableView.numberOfSections - cellIndex - 1
    }
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        
    }
}
