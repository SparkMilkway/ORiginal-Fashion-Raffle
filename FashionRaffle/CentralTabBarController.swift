//
//  CentralTabBarController.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 5/6/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import UIKit

class CentralTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.isTranslucent = false
        for (index, vc) in (self.viewControllers?.enumerated())! {
            
            if index == (self.viewControllers?.count)! / 2 {
                vc.tabBarItem.isEnabled = false
            }
        }

        let button = UIButton(type: .custom)
        let image = UIImage(named: "redcamera")
        //let num = self.viewControllers?.count
        if image != nil {
            //let width = UIScreen.main.bounds.size.width
            let height = self.tabBar.frame.size.height
            let diameter = height * 1.2
            let offset = (diameter - height) / 2
            button.frame = CGRect(x: 0, y: 0, width: diameter, height: diameter)
            button.setImage(image, for: .normal)
            button.center.x = self.tabBar.center.x
            button.center.y = self.tabBar.center.y - offset
            button.addTarget(self, action: #selector(centralAction), for: .touchUpInside)

            self.view.addSubview(button)
        }
    }
    
    func centralAction() {
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let photoVC = story.instantiateViewController(withIdentifier: "PhotoVCNavi")
        let height = self.view.frame.height
        let width = self.view.frame.width
        let center = self.view.center
        
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.frame.size.height = height * 0.96
            self.view.frame.size.width = width * 0.96
            self.view.center = center
            self.tabBar.frame.size.width = width
            self.present(photoVC, animated: true, completion: nil)
        })
        
 
        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
}


