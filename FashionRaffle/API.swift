//
//  API.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 5/31/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import Firebase

let ref = FIRDatabase.database().reference()

class API: NSObject {
    
    //Loacations, subject to change
    var postRef = FIRDatabase.database().reference().child("Posts")
    var feedRef = FIRDatabase.database().reference().child("Feeds")
    var userRef = FIRDatabase.database().reference().child("Users")
    var raffleRef = FIRDatabase.database().reference().child("Raffles")
    var releaseRef = FIRDatabase.database().reference().child("ReleaseNews")
    var giveawayRef = FIRDatabase.database().reference().child("Giveaways")
    var directPostRef = FIRDatabase.database().reference().child("DirectPosts")
    var commentRef = FIRDatabase.database().reference().child("Comments")
    
    
    static var userAPI = UserAPI()
    static var storageAPI = FIRStorageAPI()
    static var authAPI = AuthAPI()
    static var postAPI = PostAPI()
    static var feedAPI = FeedAPI()
}
