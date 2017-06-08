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
    
    func uploadDataToStorage (data: Data,itemStoragePath: String, contentType: String?, completion: ((FIRStorageMetadata?, Error?) -> Void)?) {

        let metadata = FIRStorageMetadata()
        metadata.contentType = contentType
        
        storageRef.child(itemStoragePath).put(data, metadata: metadata, completion: completion)
        
        
    }
    
    func uploadPostImage() {
        
    }
    
    // Along Database with Storage
    // Upload ProfileImage
    func uploadCurrentUserProfileImage(imageData: Data, onSuccess: @escaping()->Void) {
        
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            print("No user now")
            return
        }
        let userID = currentUser.uid
        
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
        
        guard let currentUser = FIRAuth.auth()?.currentUser else {
            print("No Current User")
            return
        }
        let userID = currentUser.uid
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
    
    
    
}
