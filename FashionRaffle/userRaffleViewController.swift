//
//  userRaffleViewController.swift
//  FashionRaffle
//
//  Created by Mac on 5/8/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import UIKit


class userRaffleViewController: UIViewController {

    @IBOutlet weak var userRaffleTickets: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let tickets:Int = (Profile.currentUser?.tickets)!
        print(tickets)
        self.userRaffleTickets!.text = "Raffle Tickets: " + String(tickets)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
