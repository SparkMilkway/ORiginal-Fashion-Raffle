//
//  GradientView.swift
//  FashionRaffle
//
//  Created by Mac on 5/29/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
@IBDesignable

class GradientView: UIView {
    @IBInspectable var FirstColor : UIColor = UIColor.clear {
        didSet{
            updateView()
        }
    }
    @IBInspectable var SecondeColor : UIColor = UIColor.clear {
        didSet{
            updateView()
        }
    }
    
    override class var layerClass: AnyClass{
        get {
            return CAGradientLayer.self
        }
    }

    func updateView() {
        let layer = self.layer as! CAGradientLayer
        layer.colors = [FirstColor.cgColor, SecondeColor.cgColor]
        
    }
    
}
