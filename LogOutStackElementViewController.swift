//
//  LogOutStackElementViewController.swift
//  FashionRaffle
//
//  Created by Mac on 2016/10/28.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit

class LogOutStackElementViewController: UIViewController {
    @IBOutlet weak var logOutManagerHeader: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var headerString:String?{
            didSet{
                configureView()
            }
        }
        
        func configureView(){
            logOutManagerHeader.text = headerString
        }
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
