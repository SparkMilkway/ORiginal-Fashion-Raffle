//
//  API.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 5/31/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import Firebase

let databaseRef = FIRDatabase.database().reference()


class API: NSObject {
    
    static let postRef = databaseRef.child("Posts")
    static let userRef = databaseRef.child("Users")
    static let raffleRef = databaseRef.child("Raffles")
    static let releaseRef = databaseRef.child("ReleaseNews")
    static let giveawayRef = databaseRef.child("Giveaways")
    static let directPostRef = databaseRef.child("DirectPosts")
    
    
    
    
    static func uploadDataToStorage (data: Data,itemStoragePath: String, contentType: String?, completion: ((FIRStorageMetadata?, Error?) -> Void)?) {
        let storageRef = FIRStorage.storage().reference()
        let metadata = FIRStorageMetadata()
        metadata.contentType = contentType
        
        storageRef.child(itemStoragePath).put(data, metadata: metadata, completion: completion)
        
        
    }
    
}
