//
//  PhotoViewController.swift
//  FashionRaffle
//
//  Created by Mac on 4/29/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import Sharaku
import Firebase

class PhotoViewController: UIViewController, FusumaDelegate, SHViewControllerDelegate {

    @IBOutlet var background: UIView!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fileUrlLabel: UILabel!
    @IBOutlet weak var captionLabel: UITextView!
    
    @IBOutlet weak var edit: UIButton!


    let postref = FIRDatabase.database().reference().child("Posts")
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.isHidden = true
        self.captionLabel.tintColor = UIColor.black
        let fusuma = FusumaViewController()
        
        //        fusumaCropImage = false
        
        fusuma.delegate = self
        self.fileUrlLabel.text = ""
        present(fusuma, animated: true, completion: nil)
        
        
        
        
    }
    
    @IBAction func uploadPost(_ sender: Any) {
        let image = self.imageView.image
        let caption = self.captionLabel.text!
        if caption == "Captions." || caption == "" {
            SettingsLauncher.showAlerts(title: "Error", message: "Please write the caption section.", handler: nil, controller: self)
            return
        }
        else{
            self.view.endEditing(true)
            
            let proImage = Profile.currentUser?.picture
            let newPost = Post.init(postID: nil, creator: (Profile.currentUser?.username)!, image: image!, caption: caption, brandinfo: ["example1","example2"], profileImage: proImage)
            let uniqueRef = postref.childByAutoId()
            uniqueRef.setValue(newPost.dictValue())
            SettingsLauncher.showAlerts(title: "Success!", message: "Your post has been posted!", handler: {
                UIAlertAction in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarController = storyboard.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
                self.present(tabBarController, animated: true, completion: nil)
            }, controller: self)
        }
        
        
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

        let filterimage = image
        let vc = SHViewController(image: filterimage)
        vc.delegate = self
        self.present(vc, animated: true, completion:nil)

        
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
    func shViewControllerImageDidFilter(image: UIImage) {
        
        imageView.image = image
    }
    
    func shViewControllerDidCancel() {
        
        
    }
    

}
