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
import SVProgressHUD



class NewsReusableViewController: UIViewController {
    
    @IBOutlet weak var Label1: UILabel!
    
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var Details: UILabel!
    
    var reference : FIRStorageReference!
    
    var passLabel : String!
    var passDetail : String!
    var passKey: String!
    
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
    
    @IBOutlet var PaymentShow: UIView!
    var reference: FIRStorageReference!
    let ref = FIRDatabase.database().reference()
    var passLabel : String!
    var passDetail : String!
    var passKey: String!
    var likecheck = false
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        self.checkLikes()
        
        let likeBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "likeicon"), style: .plain, target: self, action: #selector(handlelike))
        let moreBarButton = UIBarButtonItem(image: #imageLiteral(resourceName: "white_ticket copy"), style: .plain, target: self, action: #selector(handlepurchase))

        navigationItem.rightBarButtonItems = [moreBarButton, likeBarButton]
        self.Label1.text = passLabel
        self.Details.text = passDetail
        
        self.Image.sd_setImage(with: reference)
        
        
    }
    
    let dimView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    func handlepurchase() {
        
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(dimView)
            window.addSubview(PaymentShow)
            self.dimView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            self.dimView.frame = window.frame
            self.dimView.alpha = 0
            let height = self.PaymentShow.frame.height
            let width = self.PaymentShow.frame.width
            let y = window.frame.height - height - 40
            self.PaymentShow.layer.cornerRadius = 7
            self.PaymentShow.frame = CGRect(x: 27.5, y: window.frame.height, width: width, height: height)
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.dimView.alpha = 1
                self.PaymentShow.frame = CGRect(x: 27.5, y: y, width: width, height: height)
            }, completion: nil)
        }
    }
    
    @IBAction func Pay(_ sender: Any) {
        
    }
    
    func handleDismiss() {
        if let window = UIApplication.shared.keyWindow {
            UIView.animate(withDuration: 0.4, animations: {
                self.PaymentShow.frame = CGRect(x: 27.5, y: window.frame.height, width: self.PaymentShow.frame.width, height: self.PaymentShow.frame.height)
                self.dimView.alpha = 0
            }) {(success : Bool) in
                self.PaymentShow.removeFromSuperview()
                self.dimView.removeFromSuperview()
            }
        }
        
    }

    
    @IBAction func DismissPay(_ sender: Any) {
        handleDismiss()
    }
    
    func handlelike() {
        var updateitemLike :[String: Any] = [:]
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy"
        let userID = FIRAuth.auth()?.currentUser?.uid
        let now = dateFormat.string(from: Date())
        let child = ref.child(passKey)


        if self.likecheck == false {
            updateitemLike = [userID! : now]
            SVProgressHUD.showSuccess(withStatus: "You've liked this item.")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.2, execute: {
                SVProgressHUD.dismiss()
            })
            child.child("Liked Users").updateChildValues(updateitemLike)
            self.likecheck = true
        }
        else {
            SVProgressHUD.showSuccess(withStatus: "You've unliked this item.")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1.2, execute: {
                SVProgressHUD.dismiss()
            })
            child.child("Liked Users").removeValue()
            self.likecheck = false
        }

        
    }
    func checkLikes() {
        let child = self.ref.child(passKey)
        let userID = FIRAuth.auth()?.currentUser?.uid
        child.child("Liked Users").observeSingleEvent(of: .value, with: {
            snapshot in
            if snapshot.hasChild(userID!) {
                self.likecheck = true
            }
            else {
                self.likecheck = false
            }
            
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}
