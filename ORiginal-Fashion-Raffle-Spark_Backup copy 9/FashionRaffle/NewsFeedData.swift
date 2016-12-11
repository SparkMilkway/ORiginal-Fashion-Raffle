//
//  NewsFeedData.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 11/14/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation

class NewsFeedData : NSObject {
    
    var title: String
    var subtitle: String
    //var details: String
    var image: String
    
    init(title: String, subtitle: String, image: String) {
        self.title = title
        self.subtitle = subtitle
        //self.details = details
        self.image = image
        super.init()
    }
    
}
