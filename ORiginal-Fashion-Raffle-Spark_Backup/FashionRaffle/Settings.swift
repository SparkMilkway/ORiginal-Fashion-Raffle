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
    
    
    override init() {
        super.init()
    }
}
