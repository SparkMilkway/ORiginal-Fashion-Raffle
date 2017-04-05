//
//  PostStruct.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 3/14/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class Post {
    let creator:String
    let postID:String?
    let timestamp:NSDate
    let image:UIImage
    let caption:String?
    let brandinfo:[String]?
    static var feed:[Post]?
    
    init(postID:String?,creator:String,image:UIImage, caption:String?, brandinfo:[String]) {
        self.postID = postID
        self.creator = creator
        self.image = image
        self.caption = caption
        self.brandinfo = brandinfo
        timestamp = NSDate()
    }
    
    static func initWithPostID(postID: String, postDict:[String:Any]) -> Post? {
        guard let creator = postDict["creator"] as? String, let base64String = postDict["image"] as? String else {
            print ("No post here!")
            return nil
        }
        let caption = postDict["caption"] as? String
        let brandinfo = postDict["brandinfo"] as? [String]
        let image = UIImage.imageWithBase64String(base64String: base64String)
        return Post(postID: postID, creator: creator, image: image, caption: caption, brandinfo:brandinfo!)
    }
    
    func dictValue() -> [String:Any] {
        var postDict = [String:Any]()
        postDict["creator"] = creator
        postDict["brandinfo"] = brandinfo
        postDict["image"] = image.base64String()
        if let realcaption = caption {
            postDict["caption"] = realcaption
        }
        return postDict
    }
}




class PostPoolCell: UITableViewCell {
    @IBOutlet weak var captionLabel:UILabel!
    @IBOutlet weak var imgView:UIImageView!
    
}



