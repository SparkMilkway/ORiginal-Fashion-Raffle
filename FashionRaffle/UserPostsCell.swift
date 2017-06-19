//
//  UserPostsCell.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 6/18/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import UIKit
import Imaginary

class UserPostsCell: UICollectionViewCell {
    
    @IBOutlet var postsImage: UIImageView!
    
    var postID : String? {
        didSet {
            updateImage()
        }
    }
    
    
    func updateImage() {
        if let postid = postID {
            API.postAPI.fetchPostImageURL(withPostID: postid, completed: {
                url in
                self.postsImage.setImage(url: url)
            })
        }
    }
    
}
