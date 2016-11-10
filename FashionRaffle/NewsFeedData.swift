//
//  NewsFeedData.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 11/6/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
class NewsFeedData: NSObject {
    
    var title: String!
    var subtitle: String!
    var details: String!
    
    init(title: String!, subtitle: String!, details: String!) {
        self.title = title
        self.subtitle = subtitle
        self.details = details
        super.init()
    }
}
