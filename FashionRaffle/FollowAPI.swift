//
//  FollowAPI.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 6/7/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation

class FollowAPI: NSObject {
    
    var userRef = API().userRef
    var feedRef = API().feedRef
    
    // Upon follow, the feed of the current user will append posts from the following user
    
    func followAction(withUserID userID:String, completed:@escaping()->Void) {
        
        guard let currentID = Profile.currentUser?.userID else {
            return
        }
        
        userRef.child(userID).child("followers").child(currentID).setValue(true)
        userRef.child(currentID).child("following").child(userID).setValue(true)
        
        API.userAPI.fetchUserPostsIds(withID: userID, completion: {
            ids in
            if let fetchedIds = ids {
                for currentPostId in fetchedIds {
                    self.feedRef.child(currentID).child(currentPostId).setValue(true)
                }
            }
            completed()
        })
    }
    
    func unfollowAction(withUserID userID:String, completed:@escaping()->Void) {
        
        guard let currentID = Profile.currentUser?.userID else {
            return
        }
        
        userRef.child(userID).child("followers").child(currentID).setValue(nil)
        userRef.child(currentID).child("following").child(userID).setValue(nil)
        
        API.userAPI.fetchUserPostsIds(withID: userID, completion: {
            ids in
            if let fetchedIds = ids {
                for currentPostId in fetchedIds {
                    self.feedRef.child(currentID).child(currentPostId).setValue(nil)
                }
            }
            completed()
            
        })
    }
    
    // Check following
    func checkIsFollowing(withUserID userID:String, completed:@escaping(Bool)->Void) {
        
        guard let currentID = Profile.currentUser?.userID else {
            return
        }
        userRef.child(currentID).child("following").child(userID).observeSingleEvent(of: .value, with: {
            snapshot in
            if snapshot.value != nil {
                completed(true)
            }
            else {
                completed(false)
            }
            
        })
        
    }
    
}
