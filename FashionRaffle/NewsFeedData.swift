//
//  NewsFeedData.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 11/14/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import UIKit


class NewsFeedData : NSObject {
    
    var title: String
    var subtitle: String
    var image: String
    var details: String
    var pathKey: String
    
    init(title: String, subtitle: String, image: String, details: String, pathKey: String) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.details = details
        self.pathKey = "Demos/\(pathKey)"
        super.init()
    }
    
}

class NewsDataCell: UITableViewCell{
    
    @IBOutlet weak var Cellimage: UIImageView!
    
    @IBOutlet weak var Title: UILabel!
    
    @IBOutlet weak var Subtitle: UILabel!
}
