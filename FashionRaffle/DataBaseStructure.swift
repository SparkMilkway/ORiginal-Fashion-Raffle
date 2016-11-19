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

class DataBaseStructure {
    //let ref = FIRDatabase.database().reference()
    
    
    func setBasicInfo(userID: String, userEmail: String) {
        let ref = FIRDatabase.database().reference()
        
        //let userEmailpath = userEmail as String
        let post : NSDictionary = ["Email": userEmail, "UserID": userID]
        ref.child("Users/EmailUsers").child(userID).setValue(post)
        
    }
    
    func setProvidersInfo(userName: String, userID: String, userEmail: String, ProviderID: String) {
        let ref = FIRDatabase.database().reference()
        let post: NSDictionary = ["Email": userEmail, "Name": userName, "UserID": userID, "ProviderID": ProviderID]
        ref.child("Users/ProviderUsers").child(userID).setValue(post)
    }
    
    /*func setProviderUserID(providerID: NSString, userID: NSString, userName: NSString, userEmail: NSString) {
     //let ref = FIRDatabase.database().reference()
     ref.child("Users/Providers").child(userEmail).setValue(["Email": userEmail])
     ref.child("Users/Providers").child(userEmail).setValue(["UserName": userName])
     ref.child("Users/Providers").child(userEmail).setValue(["UserID": userID])
     ref.child("Users/Providers").child(userEmail).setValue(["ProviderID": providerID])
     
     }*/
    func updateNormalEmail(email: String?){
        let ref = FIRDatabase.database().reference()
        //let ref = FIRDatabase.database().reference()
        ref.child("Users/EmailID").child(email!).setValue(["Email": email!])
    }
    
    func updateNormalName(name: String?){
        let ref = FIRDatabase.database().reference()
        //let ref = FIRDatabase.database().reference()
        ref.child("Users/")
    }
    
    
}
