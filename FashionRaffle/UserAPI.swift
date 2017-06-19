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
    let storageAPI = API.storageAPI
    
    //****************************************************//
    // Upload
    //****************************************************//
    
    func uploadToDatabase(withID userID: String, dictValue: [String:Any], onSuccess: @escaping()->Void, onError: @escaping (Error) -> Void) {
        userRef.child(userID).setValue(dictValue, withCompletionBlock: {
            error, _ in
            if error != nil {
                onError(error!)
                return
            }
            onSuccess()
            
        })
    }
    
    // Along Database with Storage
    // Upload ProfileImage
    func uploadCurrentUserProfileImage(imageData: Data, onSuccess: @escaping()->Void) {
        
        guard let currentUser = Profile.currentUser else {
            print("No users")
            return
        }
        let userID = currentUser.userID
        
        Config.showLoading(Status: "Uploading Profile Picture...")
        let profilePath = "UserInfo/\(userID)/profilePic/profileImage.jpg"
        storageAPI.uploadDataToStorage(data: imageData, itemStoragePath: profilePath, contentType: "image/jpeg", completion: {
            meta, error in
            if error != nil {
                Config.dismissLoading(onFinished: {
                    Config.showError(withStatus: error!.localizedDescription)
                    return
                })
            }
            let url = meta?.downloadURL()
            Profile.currentUser?.profilePicUrl = url
            Profile.currentUser?.sync(onSuccess: {
                Config.dismissLoading(onFinished: onSuccess)
            }, onError: {
                uploadError in
                Config.dismissLoading(onFinished: {
                    Config.showError(withStatus: uploadError.localizedDescription)
                    return
                })
                
            })
        })
    }
    
    //Upload Background Image
    func uploadCurrentUserBackgroundImage(imageData: Data, onSuccess: @escaping()->Void) {
        
        guard let currentUser = Profile.currentUser else {
            print("No users")
            return
        }
        let userID = currentUser.userID
        Config.showLoading(Status: "Uploading BackGround Picture...")
        let backImagePath = "UserInfo/\(userID)/backgroundPic/backgroundImage.jpg"
        
        storageAPI.uploadDataToStorage(data: imageData, itemStoragePath: backImagePath, contentType: "image/jpeg", completion: {
            meta, error in
            if error != nil {
                Config.dismissLoading(onFinished: {
                    Config.showError(withStatus: error!.localizedDescription)
                    return
                })
            }
            let url = meta?.downloadURL()
            Profile.currentUser?.backgroundPictureUrl = url
            Profile.currentUser?.sync(onSuccess: {
                Config.dismissLoading(onFinished: onSuccess)
            }, onError: {
                uploadError in
                Config.dismissLoading(onFinished: {
                    Config.showError(withStatus: uploadError.localizedDescription)
                    return
                })
            })
            
        })
    }
    
    
    //****************************************************//
    // Fetch
    //****************************************************//
    
    func fetchUserInfo(withID userID: String, completion: @escaping (Profile?) -> Void) {
        
        userRef.child(userID).observeSingleEvent(of: .value, with: {
            snapshot in
            
            guard let fetchProfileDict = snapshot.value as? [String:Any] else {
                print("Fetching User Profile Fails")
                completion(nil)
                return
            }
            
            let fetchProfile = Profile.initWithUserID(userID: userID, profileDict: fetchProfileDict)
            completion(fetchProfile!)
            
        })
        
    }
    
    // Two functions below are used in the Post Feed for faster performance
    func fetchUserProfilePicUrl(withID userID: String, completion: @escaping (URL?) -> Void) {
        
        userRef.child(userID).child("profilePicUrl").observeSingleEvent(of: .value, with: {
            snapshot in
            
            if let fetchedURL = snapshot.value as? String {
                let url = URL(string: fetchedURL)
                completion(url)
            }
            else {
                //If there is no such a profilePic
                completion(nil)
            }
            
        })
    }
    
    func fetchUserName(withID userID: String, completion: @escaping (String) -> Void) {
        
        userRef.child(userID).child("username").observeSingleEvent(of: .value, with: {
            snapshot in
            
            let name = snapshot.value as! String
            completion(name)
        })
        
    }
    
    // Should fetch a certain amount
    func fetchUserPostsID(withUserID userID: String, completion: @escaping([String]?)->Void) {
        
        let personalPostRef = userRef.child(userID).child("posts")
        var tempIds = [String]()
        
        API.postAPI.fetchUserPostsCount(fromID: userID, completed: {
            number in
            guard number > 0 else {
                completion(nil)
                return
            }
            personalPostRef.queryOrderedByKey().observe(.childAdded, with: {
                snapshot in
                tempIds.insert(snapshot.key, at: 0)
                if tempIds.count == Int(number) {
                    completion(tempIds)
                    personalPostRef.removeAllObservers()
                }
            })
            
        })
        
    }
    
    
    
}
