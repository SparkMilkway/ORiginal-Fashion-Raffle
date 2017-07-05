//
//  BountyStruct.swift
//  FashionRaffle
//
//  Created by Mac on 6/20/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
class Bounty {
    let bountyID: String?
    let creator: String
    let creatorID: String
    var timestamp:String
    var likeCounter:Int?
    var likedUsers:[String]?

    var comments:[String]?
    let imageUrl: URL
    let caption: String?
    let location : [String]?
    let bountyAmount: Int
    var status: String
    static var currentBounty: Bounty?
    
    
    init(bountyID:String?, creator: String, creatorID:String, imageUrl: URL!, caption:String?,timestamp:String, comments:[String]?, likeCounter:Int?, status:String, location:[String]?, bountyAmount: Int, likedUsers: [String]?) {
        self.bountyID = bountyID
        self.creator = creator
        self.creatorID = creatorID
        self.imageUrl = imageUrl
        self.caption = caption
        self.timestamp = timestamp
        self.likeCounter = likeCounter
        self.comments = comments
        self.status = status
        self.location = location
        self.bountyAmount = bountyAmount
        self.likedUsers = likedUsers

    }
    
    static func initWithBountyID(bountyID:String, bountyDict:[String:Any]) -> Bounty?{
        guard let creator = bountyDict["creator"] as? String, let imageUrlStr = bountyDict["imageUrl"] as? String else {
            print ("No post here!")
            return nil
        }
        let caption = bountyDict["caption"] as? String
        let timestamp = bountyDict["timestamp"] as? String
        let creatorID = bountyDict["creatorID"] as? String
        var commentsID = [String]()
        if let comments = bountyDict["comments"] as? [String:Bool] {
            for tempcomments in comments {
                commentsID.append(tempcomments.key)
            }
        }
        var likeUsers = [String]()
        if let likedUsers = bountyDict["likedUsers"] as? [String:Bool] {
            for tempusers in likedUsers {
                likeUsers.append(tempusers.key)
            }
        }
        let likeCounter = bountyDict["likeCounter"] as? Int
        let imageUrl = URL(string: imageUrlStr)!
        let status = bountyDict["status"] as? String
        let bountyAmount = bountyDict["bountyAmount"] as? Int
        let location = bountyDict["location"] as? [String]
        
        return Bounty(bountyID: bountyID, creator: creator, creatorID: creatorID!, imageUrl: imageUrl, caption: caption,  timestamp: timestamp!, comments: commentsID, likeCounter: likeCounter,status: status!, location:location, bountyAmount: bountyAmount!, likedUsers: likeUsers)
    }
    
    func dictValue() -> [String:Any] {
        var bountyDict = [String:Any]()
        
        var likeUsersDB = [String:Bool]()
        var commentsDB = [String:Bool]()
        bountyDict["creator"] = creator
        bountyDict["creatorID"] = creatorID
        bountyDict["imageUrl"] = "\(imageUrl)"
        if let likeUsers = likedUsers {
            for tempUsers in likeUsers{
                likeUsersDB[tempUsers] = true
            }
            bountyDict["likedUsers"] = likeUsersDB
        }
        if let comment = comments {
            for tempcomment in comment {
                commentsDB[tempcomment] = true
            }
            bountyDict["comments"] = commentsDB
        }
        
        bountyDict["likeCounter"] = likeCounter
        bountyDict["timestamp"] = timestamp
        if let realcaption = caption {
            bountyDict["caption"] = realcaption
        }
        return bountyDict
    }

    
}
