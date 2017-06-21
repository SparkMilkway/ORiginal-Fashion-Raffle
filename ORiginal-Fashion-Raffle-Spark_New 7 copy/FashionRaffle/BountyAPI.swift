//
//  BountyAPI.swift
//  FashionRaffle
//
//  Created by Mac on 6/20/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import FirebaseDatabase

class BountyAPI: NSObject {
    let bountyRef = API().bountyRef
    let userRef = API().userRef
    let storageAPI = API.storageAPI
    // Remove Observers From Feed
    func removeObserverFromFeed() {
        bountyRef.removeAllObservers()
    }
    
    // Fetch a single bounty with bountyID
    func fetchPost(withID bountyID: String, completion: @escaping (Bounty) -> Void) {
        
        bountyRef.child(bountyID).observeSingleEvent(of: .value, with: {
            snapshot in
            
            guard let bountyDict = snapshot.value as? [String:Any] else{
                print("Fetch bounty Fails")
                return
            }
            let newBounty = Bounty.initWithBountyID(bountyID: bountyID, bountyDict: bountyDict)
            completion(newBounty!)
        })
    }
    
    func fetchPostCommentsCount(withID bountyID:String, completion: @escaping(UInt) ->Void) {
        bountyRef.child(bountyID).child("comments").observeSingleEvent(of: .value, with: {
            snapshot in
            
            let count = snapshot.childrenCount
            completion(count)
        })
    }
    func uploadPostImage(withImageData imageData:Data, captions: String?, location:[String]?,bountyAmount:Int, onSuccess: @escaping() -> Void) {
        guard let currentUser = Profile.currentUser else {
            print("No CurrentUser")
            return
        }
        let userID = currentUser.userID
        Config.showLoading(Status: "Uploading...")
        let creator = Profile.currentUser?.username
        let now = Date().now()
        let autoRef = bountyRef.childByAutoId()
        let autoPostID = autoRef.key
        let storagePath = "Bountys/\(autoPostID)/bountyPic.jpg"
        
        
        storageAPI.uploadDataToStorage(data: imageData, itemStoragePath: storagePath, contentType: "image/jpeg", completion: {
            metadata, error in
            if error != nil {
                Config.dismissLoading(onFinished: {
                    Config.showError(withStatus: error!.localizedDescription)
                    return
                })
            }
            let url = metadata?.downloadURL()
            // Do three things: Upload posts dict into Posts, append postID into posts in users, append postID into feed of currentUser
            let newBounty = Bounty.init(bountyID: nil, creator: creator!, creatorID: userID, imageUrl: url!, caption: captions, timestamp: now, comments: nil, likeCounter: nil, status: "active", location: location, bountyAmount: bountyAmount, likedUsers: nil)
            // 1
            autoRef.setValue(newBounty.dictValue())
            // 2
            Profile.currentUser?.posts?.append(autoPostID)
            Profile.currentUser?.sync(onSuccess: {}, onError: {
                error in
                print(error.localizedDescription)
            })
            // 3
            /*
            self.feedRef.child(userID).child(autoPostID).setValue(true, withCompletionBlock: {
                error,_ in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                Config.dismissLoading(onFinished: {
                    onSuccess()
                })
            })*/
        })
    }


}
