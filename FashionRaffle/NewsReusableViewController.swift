//
//  NewsReusableViewController.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 11/15/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class NewsReusableViewController: UIViewController {
    
    @IBOutlet weak var Label1: UILabel!
    @IBOutlet weak var Details: UILabel!
    @IBOutlet weak var Image: UIImageView!
    
    var passLabel : String!
    var passDetail : String!
    var passImageURL : String!
    
    var reference : FIRStorageReference!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        self.Label1.text = passLabel
        self.Details.text = passDetail
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    
}
