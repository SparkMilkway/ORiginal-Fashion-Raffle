//
//  DemoFeatures.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 11/1/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation

class DemoFeature: NSObject {
    
    var displayName: String
    var detailText: String
    var image: String
    var storyboard: String
    
    init(name: String, detail: String, image: String, storyboard: String) {
        self.displayName = name
        self.detailText = detail
        self.image = image
        self.storyboard = storyboard
        super.init()
    }
}
