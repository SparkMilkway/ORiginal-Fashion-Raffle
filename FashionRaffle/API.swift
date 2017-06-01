//
//  API.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 5/31/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import Firebase




class API: NSObject {
    
    //Loacations, subject to change
    var postRef = FIRDatabase.database().reference().child("Posts")
    var userRef = FIRDatabase.database().reference().child("Users")
    var raffleRef = FIRDatabase.database().reference().child("Raffles")
    var releaseRef = FIRDatabase.database().reference().child("ReleaseNews")
    var giveawayRef = FIRDatabase.database().reference().child("Giveaways")
    var directPostRef = FIRDatabase.database().reference().child("DirectPosts")
    
    static var userAPI = UserAPI()
    static var storageAPI = FIRStorageAPI()

    
}
