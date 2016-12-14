//
//  DataBaseStructure.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 11/18/16.
//  Copyright © 2016 Mac. All rights reserved.
//


import Foundation
import Firebase
import FirebaseDatabase

class DataBaseStructure: NSObject {
    //let ref = FIRDatabase.database().reference()
    

    func updateUserDatabase(location: String,userID: String, post: [String:Any]) {
        let ref = FIRDatabase.database().reference()
        ref.child(location).child(userID).updateChildValues(post, withCompletionBlock: {
            (error, ref) -> Void in
            if error != nil {
                print(error!)
                return
            }
        })
    }
    
    override init() {
        super.init()
    }


    
    
}
