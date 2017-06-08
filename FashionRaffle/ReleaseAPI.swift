//
//  ReleaseAPI.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 6/1/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ReleaseAPI: NSObject {
    let releaseRef = API().releaseRef
    
    // Remove Observers From ReleaseNews
    func removeObserverFromRelease() {
        
        releaseRef.removeAllObservers()
        
    }
    
    
    
    // Get all the releaseInfo for now
    
    
}
