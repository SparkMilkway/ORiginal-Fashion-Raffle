//
//  ProfileStruct.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 3/14/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Firebase
let ref = FIRDatabase.database().reference()

class Profile {
    let userID:String
    var email:String
    var username:String
    var tickets:Int
    var checkInCount:Int
    var lastCheckDate:String
    var followers:[String]
    var following:[String]
    var followBrands:[String]
    var posts:[Post]
    var picture:UIImage?
    var editor:Bool
    static var currentUser:Profile?
    
    init(username:String, email:String,userID:String, tickets: Int, followers:[String], following:[String],followBrands:[String],checkInCount: Int, posts:[Post], picture:UIImage?) {
        self.username = username
        self.userID = userID
        self.email = email
        self.tickets = tickets
        self.followers = followers
        self.following = following
        self.followBrands = followBrands
        self.checkInCount = checkInCount
        self.posts = posts
        self.picture = picture
        lastCheckDate = Date().now()
        editor = false
        // Check in upon login
        //It's the local time, later it should be a world time and can't be changed from the user's calendar
    }
    // Used during register
    static func newUser(username:String!,userID:String!, email:String!) -> Profile {
        return Profile(username: username, email:email, userID: userID, tickets:0, followers: [String](), following: [String](), followBrands:[String](),checkInCount:1,posts: [Post](), picture: nil)
    }
    
    // Used during login
    static func initWithUserID(userID:String , profileDict: [String:Any]) -> Profile? {
        let profile = Profile.newUser(username: "Default", userID: userID, email: "Default")
        if let lastCheckDate = profileDict["lastCheckDate"] as? String {
            profile.lastCheckDate = lastCheckDate
        }
        //fetch username,email,raffleTickets,checkinCount,followers,followings, brands,posts, picture
        if let email = profileDict["email"] as? String {
            profile.email = email
        }
        if let username = profileDict["username"] as? String {
            profile.username = username
        }
        if let tickets = profileDict["tickets"] as? Int {
            profile.tickets = tickets
        }
        if let checkInCount = profileDict["checkInCount"] as? Int {
            profile.checkInCount = checkInCount
        }
        if let followers = profileDict["followers"] as? [String] {
            profile.followers = followers
        }
        if let following = profileDict["following"] as? [String] {
            profile.following = following
        }
        if let brands = profileDict["followBrands"] as? [String] {
            profile.followBrands = brands
        }
        if let imgString = profileDict["picture"] as? String {
            profile.picture = UIImage.imageWithBase64String(base64String: imgString)
        }
        if profileDict["editor"] != nil {
            profile.editor = true
        }
        else {
            profile.editor = false
        }
        return profile
    }
    // put all info into dict
    func dictValue() -> [String:Any] {
        var profileDict:[String:Any] = [:]
        //fetch userID,username,email,tickets,checkInCount,followers,following, followBrands,posts, picture
        profileDict["userID"] = userID
        profileDict["username"] = username
        profileDict["email"] = email
        profileDict["tickets"] = tickets
        profileDict["checkInCount"] = checkInCount
        profileDict["followers"] = followers
        profileDict["following"] = following
        profileDict["followBrands"] = followBrands
        profileDict["posts"] = posts
        profileDict["lastCheckDate"] = lastCheckDate
        if editor == true {
            profileDict["editor"] = "yes"
        }
        if let profilepic = picture {
            profileDict["picture"] = profilepic.base64String()
        }
        return profileDict
    }
    //sync the user profile to database
    func sync() {
        ref.child("Users").child(userID).setValue(dictValue())
    }
}

