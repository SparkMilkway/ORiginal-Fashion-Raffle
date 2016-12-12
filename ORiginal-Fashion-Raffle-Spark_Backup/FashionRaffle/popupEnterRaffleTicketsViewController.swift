//
//  popupEnterRaffleTicketsViewController.swift
//  FashionRaffle
//
//  Created by Mac on 2016/12/11.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit
import Firebase

class popupEnterRaffleTicketsViewController: UIViewController {
    @IBOutlet weak var popupBackground: UIView!

    @IBOutlet weak var lbl: UILabel!
    @IBOutlet weak var slider: UISlider!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = FIRDatabase.database().reference()
        let user = FIRAuth.auth()?.currentUser
        let userID = user?.uid
        if FBSDKAccessToken.current() == nil {

        ref.child("Users/EmailUsers").child(userID!).observeSingleEvent(of: .value, with: {
            snapshot in
            let value = snapshot.value as? NSDictionary
            let hastickets = value!["Tickets"] as! Int
            print(hastickets)
            if hastickets < 6{
            self.slider.maximumValue = Float(hastickets)
            }
            else{
                self.slider.maximumValue = 5
 
            }

        })
        } else {
            ref.child("Users/ProviderUsers").child(userID!).observeSingleEvent(of: .value, with: {
                snapshot in
                let value = snapshot.value as? NSDictionary
                let hastickets = value!["Tickets"] as! Int
                print(hastickets)
                if hastickets < 6{
                    self.slider.maximumValue = Float(hastickets)
                }
                else{
                    self.slider.maximumValue = 5
                    
                }
            })
        }
        //above code is super redundent!!!!
        
                slider.minimumValue = 0
        // Do any additional setup after loading the view.
        popupBackground.layer.cornerRadius = 10
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func sliderValue(_ sender: UISlider) {
        lbl.text = String(Int(sender.value))
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated:true, completion: nil)
    }

    @IBAction func comfirm(_ sender: Any) {
        
        let purchasedTicket = Int(slider.value)
        
        let ref = FIRDatabase.database().reference()
        let user = FIRAuth.auth()?.currentUser
        let userID = user?.uid
        if FBSDKAccessToken.current() == nil {
            
            ref.child("Users/EmailUsers").child(userID!).observeSingleEvent(of: .value, with: {
                snapshot in
                let value = snapshot.value as? NSDictionary
                var hastickets = value!["Tickets"] as! Int
                print(hastickets)
                hastickets = hastickets - purchasedTicket
                DataBaseStructure().updateUserDatabase(location: "Users/EmailUsers",userID: userID!, post: ["Tickets": hastickets])
            })
        } else {
            ref.child("Users/ProviderUsers").child(userID!).observeSingleEvent(of: .value, with: {
                snapshot in
                let value = snapshot.value as? NSDictionary
                var hastickets = value!["Tickets"] as! Int
                print(hastickets)
                hastickets = hastickets - purchasedTicket

                DataBaseStructure().updateUserDatabase(location: "Users/ProviderUsers",userID: userID!, post: ["Tickets": hastickets])
            })
        }
        dismiss(animated:true, completion: nil)

        
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
