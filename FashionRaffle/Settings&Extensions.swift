//
//  Settings.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 12/11/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit
import SVProgressHUD

class SettingsLauncher: NSObject {

    static func showLoading(Status: String) {
        let blackV = UIView()
        blackV.isUserInteractionEnabled = true
        blackV.backgroundColor = UIColor(white: 0, alpha: 0.5)
        if let window = UIApplication.shared.keyWindow {
            window.addSubview(blackV)
            // Add a tag to the blackview
            
            blackV.tag = 100
            blackV.frame = window.frame
            blackV.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                blackV.alpha = 1
            }, completion: {(completed) -> Void in
                if completed == true {
                    SVProgressHUD.show(withStatus: Status)
                }
            })
        }
    }
    static func dismissLoading() {
        if let window = UIApplication.shared.keyWindow {
            SVProgressHUD.dismiss()
            if let blackview = window.viewWithTag(100) {
                blackview.alpha = 1
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                    blackview.alpha = 0
                }, completion: {
                    (completed) -> Void in
                    if completed == true {
                        blackview.removeFromSuperview()
                    }
                })
            }
        }
    }


    static func showAlerts(title: String, message: String, handler: ((UIAlertAction) -> Void)?, controller: UIViewController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title:"OK", style: .cancel, handler: handler)
        alertController.addAction(defaultAction)
        controller.present(alertController, animated: true, completion: nil)
    }
    
    override init() {
        super.init()
    }
}

extension UIImage {
    func base64String() -> String {
        let imageData = UIImageJPEGRepresentation(self, 0.5)!
        let base64String = imageData.base64EncodedString(options: .lineLength64Characters)
        return base64String
    }
    
    static func imageWithBase64String(base64String: String) -> UIImage {
        let decodedData = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters)!
        let postImage = UIImage(data: decodedData)!
        return postImage
    }
}

extension Date {
    // Return the date now as MM/DD/YYYY
    func now() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy"
        let now = dateFormat.string(from: Date())
        return now
    }
    
    static func strToDate(Str: String) -> Date? {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy HH:mm O"
        guard let date = dateFormat.date(from: Str) else {
            print("Date format not correct")
            return nil
            
        }
        return date
    }
    
    func dateToStr() -> String {
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy HH:mm O"
        let str = dateFormat.string(from: self)
        return str
    }
    
}
