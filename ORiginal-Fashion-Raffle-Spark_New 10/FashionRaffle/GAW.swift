//
//  GAW.swift
//  FashionRaffle
//
//  Created by Mac on 7/15/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import UIKit

class GiveAway {
    
    let gawID:String?
    let creator:String
    let creatorID:String
    
    var timestamp:String
    var likedUsers:[String]?
    var likeCounter:Int?
    var comments:[String]?
    let imageUrl:URL
    let caption:String?
    let announceDay: String
    let winners: [String]?
    
    static var currentGAW:GiveAway?
    
    init(gawID:String?,creator:String, creatorID: String, imageUrl:URL, caption:String?,  timestamp: String, comments:[String]?,likedUsers: [String]?, likeCounter: Int?, announceDay: String, winners: [String]?) {
        self.gawID = gawID
        self.creator = creator
        self.creatorID = creatorID
        self.imageUrl = imageUrl
        self.caption = caption
        self.timestamp = timestamp
        self.likedUsers = likedUsers
        self.likeCounter = likeCounter
        self.comments = comments
        self.announceDay = announceDay
        self.winners = winners
    }
    
    static func initWithGAWID(gawID: String, gawDict:[String:Any]) -> GiveAway? {
        guard let creator = gawDict["creator"] as? String, let imageUrlStr = gawDict["imageUrl"] as? String else {
            print ("No post here!")
            return nil
        }
        let caption = gawDict["caption"] as? String
        let timestamp = gawDict["timestamp"] as? String
        let creatorID = gawDict["creatorID"] as? String
        let announceDay = gawDict["announceDay"] as? String
        let winners = gawDict["winners"] as? [String]
        
        var likeUsers = [String]()
        if let likedUsers = gawDict["likedUsers"] as? [String:Bool] {
            for tempusers in likedUsers {
                likeUsers.append(tempusers.key)
            }
        }
        var commentsID = [String]()
        if let comments = gawDict["comments"] as? [String:Bool] {
            for tempcomments in comments {
                commentsID.append(tempcomments.key)
            }
        }
        
        
        let likeCounter = gawDict["likeCounter"] as? Int
        let imageUrl = URL(string: imageUrlStr)!
        
        return GiveAway(gawID: gawID, creator: creator, creatorID: creatorID!, imageUrl: imageUrl, caption: caption, timestamp: timestamp!, comments: commentsID, likedUsers: likeUsers, likeCounter: likeCounter, announceDay:announceDay!, winners: winners)
        
    }
    
    func dictValue() -> [String:Any] {
        var gawDict = [String:Any]()
        
        var likeUsersDB = [String:Bool]()
        var commentsDB = [String:Bool]()
        var winnersDB = [String:Bool]()
        gawDict["creator"] = creator
        gawDict["creatorID"] = creatorID
        gawDict["imageUrl"] = "\(imageUrl)"
        gawDict["announceDay"] = announceDay
        if let likeUsers = likedUsers {
            for tempUsers in likeUsers{
                likeUsersDB[tempUsers] = true
            }
            gawDict["likedUsers"] = likeUsersDB
        }
        if let comment = comments {
            for tempcomment in comment {
                commentsDB[tempcomment] = true
            }
            gawDict["comments"] = commentsDB
        }
        if let winners = winners {
            for tempWinner in winners {
                winnersDB[tempWinner] = true
            }
            gawDict["winners"] = winnersDB
        }
        
        
        gawDict["likeCounter"] = likeCounter
        gawDict["timestamp"] = timestamp
        if let realcaption = caption {
            gawDict["caption"] = realcaption
        }
        return gawDict
    }
    
    
}
