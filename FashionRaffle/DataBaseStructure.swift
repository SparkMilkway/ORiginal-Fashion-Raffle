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
        
        let post : [String: String?] = ["Email": userEmail,"Name": userName, "UserID": userID, "ProviderID": ProviderID]
        ref.child("Users/ProviderUsers").child(userID).updateChildValues(post)
    }
    
    
    func updateNormalEmail(email: String?){
        let ref = FIRDatabase.database().reference()
        //let ref = FIRDatabase.database().reference()
        ref.child("Users/EmailID").child(email!).setValue(["Email": email!])
    }
    
    
    
    
}
