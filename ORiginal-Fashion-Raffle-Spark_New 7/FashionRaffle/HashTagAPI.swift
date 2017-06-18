//
//  HashTagAPI.swift
//  FashionRaffle
//
//  Created by Mac on 6/17/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import FirebaseDatabase

class HashTagAPI {
    var REF_HASHTAG = FIRDatabase.database().reference().child("hashTag")
    
    func fetchPosts(withTag tag: String, completion: @escaping (String) -> Void) {
        REF_HASHTAG.child(tag.lowercased()).observe(.childAdded, with: {
            snapshot in
            completion(snapshot.key)
        })
    }
}
