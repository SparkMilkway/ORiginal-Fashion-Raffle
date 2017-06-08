//
//  RaffleAPI.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 6/2/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import FirebaseDatabase

class RaffleAPI: NSObject {
    let raffleRef = API().raffleRef
    
    // Remove Observer From Raffles
    func removeObserverFromRaffles() {
        
        raffleRef.removeAllObservers()
        
    }
    
    
}
