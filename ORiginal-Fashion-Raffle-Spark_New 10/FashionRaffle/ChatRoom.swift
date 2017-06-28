//
//  ChatRoom.swift
//  FashionRaffle
//
//  Created by Mac on 6/25/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct ChatRoom {
    var username: String!
    var other_Username: String!
    var userId: String!
    var other_userId: String!
    var members: [String]!
    var chatRommId: String!
    var key: String = ""
    var lastMessage: String!
    

}
