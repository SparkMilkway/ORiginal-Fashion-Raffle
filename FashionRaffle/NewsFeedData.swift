//
//  NewsFeedData.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 11/14/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import UIKit
import Firebase


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

class NewsFeed {
    // title, subtitle, detailInfo and tags can't be nil
    let newsID:String?
    let timestamp:String
    let title:String
    let titleImage:UIImage?
    let subtitle:String
    let detailInfo:String
    let imagePool:[UIImage]?
    let tags:[String]
    static var selectedNews:NewsFeed?
    static var newsFeed:[NewsFeed]?
    
    init(newsID:String?, title:String, titleImage:UIImage?, subtitle:String, detailInfo:String, imagePool:[UIImage]?, tags:[String]) {
        self.newsID = newsID
        self.title = title
        self.titleImage = titleImage
        self.subtitle = subtitle
        self.detailInfo = detailInfo
        self.imagePool = imagePool
        self.tags = tags
        timestamp = Date().now()
    }
    // Fetch the News Feed
    static func initWithNewsID(newsID:String, contents:[String:Any]) -> NewsFeed? {
        guard let title = contents["title"] as? String, let imgStr = contents["titleImage"] as? String else{
            print("No news fetched")
            return nil
        }
        let subtitle = contents["subtitle"] as? String
        let detailInfo = contents["detailInfo"] as? String
        let tags = contents["tags"] as? [String]
        let titleImage = UIImage.imageWithBase64String(base64String: imgStr)
        var imagePool = [UIImage]()
        if let strPool = contents["imagePool"] as? [String] {
            for imgstrs in strPool {
                imagePool.append(UIImage.imageWithBase64String(base64String: imgstrs))
            }
        }
        return NewsFeed(newsID: newsID, title: title, titleImage: titleImage, subtitle: subtitle!, detailInfo: detailInfo!, imagePool: imagePool, tags:tags!)
    }
    
    func dictValue() -> [String:Any] {
        var newsDict:[String:Any] = [:]
        //newsID, timestamp, title, titleImage, subtitle, detailInfo, imagePool, tags
        newsDict["newsID"] = newsID
        newsDict["timestamp"] = timestamp
        newsDict["title"] = title
        newsDict["subtitle"] = subtitle
        newsDict["detailInfo"] = detailInfo
        newsDict["tags"] = tags
        if let tImgae = titleImage {
            newsDict["titleImage"] = tImgae.base64String()
        }
        var imgStr = [String]()
        if let imgPool = imagePool {
            for img in imgPool {
                imgStr.append(img.base64String())
            }
            newsDict["imagePool"] = imgStr
        }
        return newsDict
    }
    // Sync to database
    func sync() {
        let ref = FIRDatabase.database().reference()
        ref.child("Demos").child(newsID!).setValue(dictValue())
    }
}

class NewsDataCell: UITableViewCell{
    
    @IBOutlet weak var Cellimage: UIImageView!
    
    @IBOutlet weak var Title: UILabel!
    
    @IBOutlet weak var Subtitle: UILabel!
}
