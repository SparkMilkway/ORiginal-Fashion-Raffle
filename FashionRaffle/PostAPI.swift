//
//  PostAPI.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 6/2/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import FirebaseDatabase

class PostAPI: NSObject {
    let postRef = API().postRef
    let userRef = API().userRef
    
    // Remove Observers From Feed
    func removeObserverFromFeed() {
        
        postRef.removeAllObservers()
        
    }
    //***********************************************************//
    // General Usage Function
    //***********************************************************//
    
    // Fetch a single post with postID
    func fetchPost(withID postID: String, completion: @escaping (Post) -> Void) {
        
        postRef.child(postID).observeSingleEvent(of: .value, with: {
            snapshot in
            
            guard let postDict = snapshot.value as? [String:Any] else{
                print("Fetch post Fails")
                return
            }
            let newPost = Post.initWithPostID(postID: postID, postDict: postDict)
            completion(newPost!)
            
        })
    }
    
    
    
    //***********************************************************//
    // Used in profile, not in the feed
    //***********************************************************//
    
    // Get the amount of posts of a user
    func fetchUserPostsCount(fromID userID: String, completed: @escaping (UInt) -> Void){
        
        var fetchCount : UInt = 0
        userRef.child(userID).child("posts").observeSingleEvent(of: .value, with: {
            snapshot in
            fetchCount = snapshot.childrenCount
            completed(fetchCount)
        })
        
        
    }
    
    // Get posts from a certain user with a maximum limiter
    // Has the chance to have no post
    func fetchUserPosts(fromID userID: String, withLimitToLast number:UInt, completion: @escaping ([Post]?) -> Void) {
        
        fetchUserPostsCount(fromID: userID, completed: {
            (count) in
            
            if count == 0 {
                completion(nil)
                return
            }
            var actualcount : UInt
            if count < number {
                actualcount = count
            }
            else {
                actualcount = number
            }
            let personalPostsRef = self.userRef.child(userID).child("posts")
            var tempPosts = [Post]()
            
            // Continously fetch data while added child.
            personalPostsRef.queryOrderedByKey().queryLimited(toLast: actualcount).observe(.childAdded, with: {
                snapshot in
                
                let postID = snapshot.key
                self.fetchPost(withID: postID, completion: {
                    fetchedPost in
                    tempPosts.insert(fetchedPost, at: 0)
                    // When Finished
                    if tempPosts.count == Int(actualcount) {
                        completion(tempPosts)
                    }
                })
                
            })
            
        })
        
    }
    


}
