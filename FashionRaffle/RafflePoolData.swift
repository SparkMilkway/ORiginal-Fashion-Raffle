//
//  RafflePoolData.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 11/30/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation


class RafflePoolData : NSObject {
    
    var title: String
    var subtitle: String
    var image1: String
    //var image2: String
    var details: String
    var pathKey: String
    
    init(title: String, subtitle: String, image: String, details: String, pathKey: String) {
        self.title = title
        self.subtitle = subtitle
        self.image1 = image
        self.details = details
        self.pathKey = "Raffles/\(pathKey)"
        super.init()
    }
    
}
