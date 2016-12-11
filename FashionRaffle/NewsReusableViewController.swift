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
import FirebaseStorageUI



class NewsReusableViewController: UIViewController {
    
    @IBOutlet weak var Label1: UILabel!
    
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var Details: UILabel!
    
    var reference : FIRStorageReference!
    
    var passLabel : String!
    var passDetail : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        
        self.Label1.text = passLabel
        self.Details.text = passDetail
        self.Image.sd_setImage(with: reference)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

class RaffleReusableViewController: UIViewController {
    @IBOutlet weak var Label1: UILabel!
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var Details: UILabel!
    
    var reference: FIRStorageReference!
    
    var passLabel : String!
    var passDetail : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        self.Label1.text = passLabel
        self.Details.text = passDetail
        self.Image.sd_setImage(with: reference)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
