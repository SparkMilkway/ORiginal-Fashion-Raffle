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

class PhotoViewController: UIViewController, FusumaDelegate{

    @IBOutlet var background: UIView!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fileUrlLabel: UILabel!
    @IBOutlet weak var captionLabel: UITextView!
    
    @IBOutlet weak var edit: UIButton!

    var fusumaOne : FusumaViewController?
    var shOne : SHViewController?
    var passingImage : UIImage?

    var centralVC : CentralTabBarController?
    
    let postref = FIRDatabase.database().reference().child("Posts")
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.view.frame = self.view.frame
        self.addChildViewController(fusuma)
        self.view.addSubview(fusuma.view)
        fusuma.didMove(toParentViewController: self)
        fusumaOne = fusuma

        
        
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
            SettingsLauncher.showLoading(Status: "Uploading...")
            let profilePicUrl = Profile.currentUser?.profilePicUrl
            let imageData = UIImageJPEGRepresentation(image!, 0.6)!
            let userID = Profile.currentUser?.userID
            let userName = Profile.currentUser?.username
            let now = Date().now()
            let postPath = "UserInfo/\(userID!)/posts/\(now)/postPic.jpg"
            
            SettingsLauncher.uploadDatatoStorage(data: imageData, itemStoragePath: postPath, contentType: "image/jpeg", completion: {
                metadata, error in
                if error != nil {
                    print("Error happens when uploading")
                    return
                }
                guard let meta = metadata else{
                    return
                }
                let url = meta.downloadURL()
                let newPost = Post.init(postID: nil, creator: userName!, creatorID: userID!, imageUrl: url!, caption: caption, brandinfo: nil, profileImageUrl: profilePicUrl, timestamp: now, likedUsers: nil)
                let uniqueRef = self.postref.childByAutoId()
                uniqueRef.setValue(newPost.dictValue())
                SettingsLauncher.dismissLoading()
                SettingsLauncher.showAlerts(title: "Success!", message: "", handler: {
                    UIAlertAction in
                    UIView.animate(withDuration: 0.4, animations: {
                        self.dismiss(animated: true, completion: nil)
                        if let central = self.centralVC {
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1, execute: {
                                UIView.animate(withDuration: 0.3, animations: {
                                    central.view.alpha = 1
                                })
                            })
                        }
                    })
                    
                    
                }, controller: self)
                
            })
        }
        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func cancel(_ sender: Any) {
        
        UIView.animate(withDuration: 0.4, animations: {
            self.navigationController?.isNavigationBarHidden = true
            self.fusumaOne?.view.frame.origin.x = self.view.frame.origin.x
            
        })
        
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
        print("Called when success")
        imageView.image = image

        let shVC = SHViewController(image: image)
        shVC.delegate = self

        
        self.fusumaOne?.addChildViewController(shVC)
        shVC.view.frame = self.view.frame
        self.fusumaOne?.view.addSubview(shVC.view)
        shVC.didMove(toParentViewController: self.fusumaOne)
        self.shOne = shVC
        shVC.view.frame.origin.x = self.view.frame.width + 1
        UIView.animate(withDuration: 0.3, animations: {
            shVC.view.frame.origin.x = 0
        }, completion: nil)

        
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
        if let central = self.centralVC {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1, execute: {
                UIView.animate(withDuration: 0.3, animations: {
                    central.view.alpha = 1
                })
            })
        }
    }
}

extension PhotoViewController : SHViewControllerDelegate {
    func shViewControllerDidCancel() {
        UIView.animate(withDuration: 0.3, animations: {
            self.shOne?.view.frame.origin.x = self.view.frame.width + 100
        }, completion: {
            _ in
            self.shOne?.view.removeFromSuperview()
            self.shOne?.removeFromParentViewController()
        })
    }
    func shViewControllerImageDidFilter(image: UIImage) {

        self.imageView.image = image
        
        UIView.animate(withDuration: 0.4, animations: {
            self.navigationController?.isNavigationBarHidden = false
            self.fusumaOne?.view.frame.origin.x = 0 - self.view.frame.width - 100
        })
    }
}
