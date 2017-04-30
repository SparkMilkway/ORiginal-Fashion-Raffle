//
//  PhotoViewController.swift
//  FashionRaffle
//
//  Created by Mac on 4/29/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Sharaku

class PhotoViewController: UIViewController, FusumaDelegate {

    @IBOutlet var background: UIView!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fileUrlLabel: UILabel!
    
    @IBOutlet weak var edit: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fileUrlLabel.text = ""
        
        self.tabBarController?.tabBar.isHidden = true

        let fusuma = FusumaViewController()
        
        //        fusumaCropImage = false
        
        fusuma.delegate = self
        present(fusuma, animated: true, completion: nil)
        
        
        // Do any additional setup after loading the view.
    }
    
    
   
    
   
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func edit(_ sender: Any) {
        
        let fusuma = FusumaViewController()
        
        //        fusumaCropImage = false
        
        fusuma.delegate = self
        present(fusuma, animated: true, completion: nil)
    }

    @IBAction func cancel(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        self.present(tabBarController, animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func fusumaImageSelected(_ image: UIImage) {
        
        print("Image selected")
        
        imageView.image = image
        print("selected - filter")
    }
    
    // Return the image but called after is dismissed.
    func fusumaDismissedWithImage(_ image: UIImage) {
        
        print("Called just after FusumaViewController is dismissed.")
        let filterimage = imageView.image
        let vc = SHViewController(image: filterimage!)
        vc.delegate = self
        present(vc, animated: true, completion:nil)
        
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        print("video completed and output to file: \(fileURL)")
        self.fileUrlLabel.text = "file output to: \(fileURL.absoluteString)"
        print("Called just after a video has been selected.")
    }
    
    // When camera roll is not authorized, this method is called.
    
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
    }
    
    func fusumaClosed() {
        
        print("Called when the close button is pressed")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        self.present(tabBarController, animated: true, completion: nil)
    }

}
extension PhotoViewController: SHViewControllerDelegate {
    func shViewControllerImageDidFilter(image: UIImage) {
        imageView.image = image
    }
    
    func shViewControllerDidCancel() {
        

    }
}
