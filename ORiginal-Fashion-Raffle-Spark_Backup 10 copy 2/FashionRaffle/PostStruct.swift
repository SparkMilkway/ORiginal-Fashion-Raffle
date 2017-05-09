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
    var timestamp:String
    let image:UIImage
    let profileImage:UIImage?
    let caption:String?
    let brandinfo:[String]?
    static var currentPost:Post?
    
    init(postID:String?,creator:String,image:UIImage, caption:String?, brandinfo:[String]?, profileImage:UIImage?) {
        self.postID = postID
        self.creator = creator
        self.image = image
        self.caption = caption
        self.brandinfo = brandinfo
        self.profileImage = profileImage
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy hh:mm:ssa"
        let str = dateFormat.string(from: Date())

        timestamp = str
    }
    
    static func initWithPostID(postID: String, postDict:[String:Any]) -> Post? {
        guard let creator = postDict["creator"] as? String, let base64String = postDict["image"] as? String else {
            print ("No post here!")
            return nil
        }
        let caption = postDict["caption"] as? String
        let brandinfo = postDict["brandinfo"] as? [String]
        let image = UIImage.imageWithBase64String(base64String: base64String)
        let proimage : UIImage?
        if let profileImagestr = postDict["profileImage"] as? String {
            proimage = UIImage.imageWithBase64String(base64String: profileImagestr)
        }
        else{
            proimage = #imageLiteral(resourceName: "profile1")
        }
        return Post(postID: postID, creator: creator, image: image, caption: caption, brandinfo:brandinfo, profileImage:proimage)
    }
    
    func dictValue() -> [String:Any] {
        var postDict = [String:Any]()
        postDict["creator"] = creator
        postDict["brandinfo"] = brandinfo
        postDict["image"] = image.base64String()
        if let image = profileImage {
            postDict["profileImage"] = image.base64String()
        }
        postDict["timestamp"] = timestamp
        if let realcaption = caption {
            postDict["caption"] = realcaption
        }
        return postDict
    }
}

class PhotoEdit {
    var photo: UIImage
    static var currentPhoto: PhotoEdit?
    
    init(photo: UIImage) {
        self.photo = photo
    }
}



class PostPoolCell: UITableViewCell {
    @IBOutlet weak var captionLabel:UILabel!
    @IBOutlet weak var imgView:UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    
}



