//
//  AddNewsViewController.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 4/3/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class AddNewsViewController: UIViewController {
    
    @IBOutlet weak var titleImagePicker: UIImageView!
    
    @IBOutlet weak var newsTitle: UITextField!

    @IBOutlet weak var subtitle: UITextField!
    @IBOutlet weak var details: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func postNewFeed(_ sender: Any) {
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
