//
//  PostStruct.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 3/14/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit

class Post {
    let postID:String?
    let creator:String
    let creatorID:String
    
    var timestamp:String
    var likedUsers:[String]?
    var likeCounter:Int?
    var comments:[String]?
    let imageUrl:URL
    let profileImageUrl:URL?
    let caption:String?
    let brandinfo:[String]?
    //var giveaway: Giveaway?
    
    static var currentPost:Post?
    
    init(postID:String?,creator:String, creatorID: String, imageUrl:URL, caption:String?, brandinfo:[String]?, profileImageUrl:URL?, timestamp: String, likedUsers: [String]?, likeCounter: Int?) {
        self.postID = postID
        self.creator = creator
        self.creatorID = creatorID
        self.imageUrl = imageUrl
        self.profileImageUrl = profileImageUrl
        self.caption = caption
        self.brandinfo = brandinfo
        self.timestamp = timestamp
        self.likedUsers = likedUsers
        self.likeCounter = likeCounter
    }
    
    static func initWithPostID(postID: String, postDict:[String:Any]) -> Post? {
        guard let creator = postDict["creator"] as? String, let imageUrlStr = postDict["imageUrl"] as? String else {
            print ("No post here!")
            return nil
        }
        let caption = postDict["caption"] as? String
        let timestamp = postDict["timestamp"] as? String
        let brandinfo = postDict["brandinfo"] as? [String]
        let creatorID = postDict["creatorID"] as? String
        
        var likeUsers = [String]()
        if let likedUsers = postDict["likedUsers"] as? [String:Bool] {
            for tempusers in likedUsers {
                likeUsers.append(tempusers.key)
            }
        }
        
        
        let likeCounter = postDict["likeCounter"] as? Int
        let imageUrl = URL(string: imageUrlStr)!
        let profileImageUrl:URL?
        if let profileUrlStr = postDict["profileImageUrl"] as? String {
            profileImageUrl = URL(string: profileUrlStr)
        }
        else{
            profileImageUrl = nil
        }
        return Post(postID: postID, creator: creator, creatorID: creatorID!, imageUrl: imageUrl, caption: caption, brandinfo: brandinfo, profileImageUrl: profileImageUrl, timestamp: timestamp!, likedUsers: likeUsers, likeCounter: likeCounter)

    }
    
    func dictValue() -> [String:Any] {
        var postDict = [String:Any]()
        
        var likeUsersDB = [String:Bool]()
        postDict["creator"] = creator
        postDict["creatorID"] = creatorID
        postDict["brandinfo"] = brandinfo
        postDict["imageUrl"] = "\(imageUrl)"
        if let likeUsers = likedUsers {
            for tempUsers in likeUsers{
                likeUsersDB[tempUsers] = true
            }
            postDict["likedUsers"] = likeUsersDB
        }
        postDict["likeCounter"] = likeCounter
        if let profileUrl = profileImageUrl {
            postDict["profileImageUrl"] = "\(profileUrl)"
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




