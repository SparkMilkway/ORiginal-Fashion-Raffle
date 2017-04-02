//
//  Settings.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 12/11/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class SettingsLauncher: NSObject {
    
    let blackView : UIView = {
        let view = UIView()
        view.isUserInteractionEnabled = true
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()

    
    func showDim() {

        if let window = UIApplication.shared.keyWindow {

            window.addSubview(blackView)
            window.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            self.blackView.frame = window.frame
            self.blackView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                
            }, completion: nil)
        }
        
    }
    
    
    func handleDismiss() {
        UIView.animate(withDuration: 0.5, animations: {

            self.blackView.alpha = 0
        })
    }
    func showAlerts(title: String, message: String, handler: ((UIAlertAction) -> Void)?, controller: UIViewController){
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
        let imageData = UIImagePNGRepresentation(self)!
        let base64String = imageData.base64EncodedString(options: .lineLength64Characters)
        return base64String
    }
    
    static func imageWithBase64String(base64String: String) -> UIImage {
        let decodedData = Data(base64Encoded: base64String, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)!
        let postImage = UIImage(data: decodedData)!
        return postImage
    }
}
