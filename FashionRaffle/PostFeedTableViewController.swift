//
//  SocialTableViewController.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 3/14/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD
import Imaginary
import ESPullToRefresh

class PostFeedTableViewController: UITableViewController {
    
    var postFeeds: [Post] = []
    
    let feedAPI = API.feedAPI
    var currentLoad : UInt = 5
    var singleLoadLimit: UInt = 2
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        
        loadAttributes()
        
        self.tableView.es_addPullToRefresh {
            self.loadRowsFromTop()
        }
        self.tableView.es_addInfiniteScrolling {
            self.loadMore()
        }

    }
    // Refresh, load more and so on
    
    func loadAttributes() {
        postFeeds.removeAll()
        // query limited to last int m will return the most recent m items (if generated by autoID)
        
        self.feedAPI.fetchFeeds(withLimitToLast: self.currentLoad, completed: {
            posts in
            if let fetchPosts = posts {
                self.postFeeds = fetchPosts
                self.tableView.reloadData()
            }
            else {
                Config.showError(withStatus: "No Posts!")
            }
        })
    }
    
    func loadRowsFromTop() {
        
        postFeeds.removeAll()
        // query limited to last int m will return the most recent m items (if generated by autoID)
        
        self.feedAPI.fetchFeeds(withLimitToLast: self.currentLoad, completed: {
            posts in
            if let fetchPosts = posts {
                self.postFeeds = fetchPosts
                self.tableView.reloadData()
            }
            else {
                Config.showError(withStatus: "No Posts!")
                self.tableView.reloadData()
            }
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3, execute: {
                self.tableView.es_stopPullToRefresh()
                return
            })
        })
    }
    
    func loadMore() {
        
        //Still more data
        if currentLoad <= UInt(postFeeds.count) {
            currentLoad = currentLoad + singleLoadLimit
            let checkCount = self.postFeeds.count

            self.feedAPI.fetchFeeds(withLimitToLast: self.currentLoad, completed: {
                posts in
                if let fetchedPosts = posts {
                    if fetchedPosts.count > checkCount {
                        print("Has more data")
                        self.postFeeds.removeAll()
                        self.postFeeds = fetchedPosts
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1, execute: {
                            self.tableView.reloadData()
                            self.tableView.es_stopLoadingMore()
                            return
                        })
                        
                    }
                    else {
                        print("No new data now")
                        DispatchQueue.main.async {
                            self.tableView.es_noticeNoMoreData()
                        }
                    }
                }
            })
        }
        else {
            //No more data
            print("No more data to load")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3, execute: {
                self.tableView.es_noticeNoMoreData()
            })
            
        }
        
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
        cell.post = post
        cell.homeTableViewController = self

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
