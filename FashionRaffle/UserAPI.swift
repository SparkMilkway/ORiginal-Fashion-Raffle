//
//  UserAPI.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 6/1/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserAPI: NSObject {
    
    let userRef = API().userRef
    
    func fetchUserInfo(withID userID: String, completion: @escaping (Profile) -> Void) {
        
        userRef.child(userID).observeSingleEvent(of: .value, with: {
            snapshot in
            
            guard let fetchProfileDict = snapshot.value as? [String:Any] else {
                print("Fetching User Profile Fails")
                return
            }
            
            let fetchProfile = Profile.initWithUserID(userID: userID, profileDict: fetchProfileDict)
            completion(fetchProfile!)
            
        })
        
    }
    
    func fetchUserProfilePicUrl(withID userID: String, completion: @escaping (URL?) -> Void) {
        
        userRef.child(userID).child("profilePicUrl").observeSingleEvent(of: .value, with: {
            snapshot in
            
            if let fetchedURL = snapshot.value as? String{
                let url = URL(string: fetchedURL)
                completion(url)
            }
            else {
                //If there is no such a profilePic
                completion(nil)
            }
            
        })
    }
    
    // Has the chance to have no post
    func fetchUserPosts(fromID userID: String, completion: @escaping ([Post]?) -> Void) {
        
    }
    
    
}
