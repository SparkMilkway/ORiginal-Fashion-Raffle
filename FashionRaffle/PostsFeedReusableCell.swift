//
//  PostsFeedReusableCell.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 6/3/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import UIKit

class PostPoolCell: UITableViewCell {
    
    @IBOutlet weak var captionLabel:UILabel!
    @IBOutlet weak var imgView:UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeStamp: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet var viewProfile: UIButton!
    
    var creatorID : String!
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let currentPost = post {
            
        }
    }

    
    // Comment Button
    @IBAction func commentDidTap(_ sender: Any) {
        
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        captionLabel.text = ""
        userNameLabel.text = ""
        
    }
    
    
}
