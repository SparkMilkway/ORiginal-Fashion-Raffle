//
//  FIRStorageAPI.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 6/1/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import Firebase
import SVProgressHUD


class FIRStorageAPI: NSObject {
    
    let storageRef = FIRStorage.storage().reference()
    let feedRef = API().feedRef
    let postRef = API().postRef
    
    func uploadDataToStorage (data: Data,itemStoragePath: String, contentType: String?, completion: ((FIRStorageMetadata?, Error?) -> Void)?) {

        let metadata = FIRStorageMetadata()
        metadata.contentType = contentType
        
        storageRef.child(itemStoragePath).put(data, metadata: metadata, completion: completion)

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
        
        uploadDataToStorage(data: imageData, itemStoragePath: profilePath, contentType: "image/jpeg", completion: {
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
        
        uploadDataToStorage(data: imageData, itemStoragePath: backImagePath, contentType: "image/jpeg", completion: {
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
    
    // Upload HeadImage with DetailImages
    
    
    // Upload Posts ( Should include normal posts, giveaways and others.)
    // Should update posts under Users, Feed and Posts.
    func uploadPostImage(withImageData imageData:Data, captions: String?, onSuccess: @escaping() -> Void) {
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            print("No CurrentUser")
            return
        }
        let userID = currentUser.uid
        Config.showLoading(Status: "Uploading...")
        let creator = Profile.currentUser?.username
        let now = Date().now()
        let autoRef = postRef.childByAutoId()
        let autoPostID = autoRef.key
        let storagePath = "Posts/\(autoPostID)/postPic.jpg"
        
        uploadDataToStorage(data: imageData, itemStoragePath: storagePath, contentType: "image/jpeg", completion: {
            metadata, error in
            if error != nil {
                Config.dismissLoading(onFinished: {
                    Config.showError(withStatus: error!.localizedDescription)
                    return
                })
            }
            let url = metadata?.downloadURL()
            // Do three things: Upload posts dict into Posts, append postID into posts in users, append postID into feed of currentUser
            let newPost = Post.init(postID: nil, creator: creator!, creatorID: userID, imageUrl: url!, caption: captions, brandinfo: nil, timestamp: now, likedUsers: nil, likeCounter: 0)
            // 1
            autoRef.setValue(newPost.dictValue())
            // 2
            Profile.currentUser?.posts?.append(autoPostID)
            Profile.currentUser?.sync(onSuccess: {}, onError: {
                error in
                print(error.localizedDescription)
            })
            // 3
            self.feedRef.child(userID).child(autoPostID).setValue(true, withCompletionBlock: {
                error,_ in
                if error != nil {
                    print(error!.localizedDescription)
                    return
                }
                Config.dismissLoading(onFinished: {
                    onSuccess()
                })
            })
        })
    }
}
