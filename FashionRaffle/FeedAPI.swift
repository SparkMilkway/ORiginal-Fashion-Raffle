//
//  FeedAPI.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 6/7/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import FirebaseDatabase


class FeedAPI : NSObject {
    
    var feedRef = API().feedRef
    var postRef = API().postRef
    
    func removeObserverFromFeed() {
        feedRef.removeAllObservers()
    }
    
    
    //***********************************************************//
    // Actual Usage Functions. Fetch the personal feeds
    //***********************************************************//
    
    // Fetch feeds from Feeds
    func fetchFeeds(ofID userID: String) {
        
    }
    
    
    
    //***********************************************************//
    // Used in the whole post feed
    //***********************************************************//
    
    // Get the amount of posts in the feed
    func fetchPostsCount(completed: @escaping (UInt) -> Void) {
        
        var fetchCount : UInt = 0
        postRef.observeSingleEvent(of: .value, with: {
            snapshot in
            fetchCount = snapshot.childrenCount
            completed(fetchCount)
        })
    }
    
    // Get posts given a maximum limit query from newest
    // This will return a reversed array with latest on the top
    func fetchPostFromPosts(withLimitToLast number:UInt, completion: @escaping ([Post]?) -> Void) {
        
        
        var tempPosts = [Post]()
        fetchPostsCount(completed: {
            postCount in
            
            var actualCount : UInt
            if postCount < number {
                actualCount = postCount
            }
            else {
                actualCount = number
            }
            
            self.postRef.queryOrderedByKey().queryLimited(toLast: actualCount).observe(.childAdded, with: {
                snapshot in
                guard let feed = snapshot.value as? [String:Any] else{
                    print("Error getting Posts")
                    return
                }
                let postID = snapshot.key
                API.postAPI.fetchPost(withID: postID, completion: {
                    fetchedPost in
                    tempPosts.insert(fetchedPost, at: 0)
                    // When fetched all the data
                    if tempPosts.count == Int(actualCount) {
                        completion(tempPosts)
                    }
                })
            })
        })
        
        
    }
    
}
