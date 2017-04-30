//
//  AddNewsViewController.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 4/3/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SVProgressHUD

class AddNewsViewController: UIViewController {
    
    @IBOutlet weak var titleImagePicker: UIImageView!
    
    @IBOutlet weak var newsTitle: UITextField!

    @IBOutlet weak var subtitle: UITextField!
    @IBOutlet weak var details: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        titleImagePicker.isUserInteractionEnabled = true
        titleImagePicker.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectNewsImageView)))

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @IBAction func postNews(_ sender: Any) {
        let titleEdit = self.newsTitle.text
        let subtitleEdit = self.subtitle.text
        let detailEdit = self.details.text
        let imageSelect = self.titleImagePicker.image
        if (titleEdit == "" || subtitleEdit == "" || detailEdit == "" || imageSelect == nil) {
            SettingsLauncher.showAlerts(title: "Error!", message: "Please enter all the required info", handler: nil, controller: self)
        }
        else {
            SVProgressHUD.show(withStatus: "Uploading new post...")
            let ref = FIRDatabase.database().reference()
            //let someDate = Date.strToDate(Str: "Sep.17,2017 13:00:00 EST")
            let newPost = NewsFeed.init(newsID: nil, title: titleEdit!, titleImage: imageSelect, subtitle: subtitleEdit!, detailInfo: detailEdit!, imagePool: nil, tags: ["Text"])
            ref.child("Demos").childByAutoId().setValue(newPost.dictValue())
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                SVProgressHUD.dismiss()
                SettingsLauncher.showAlerts(title: "Success!", message: "This piece of news is posted!", handler: {
                    UIAlertAction in
                    self.navigationController?.popToRootViewController(animated: true)
                }, controller: self)
            })
        }
    }

    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension AddNewsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleSelectNewsImageView() {
        let imagePC = UIImagePickerController()
        imagePC.sourceType = .photoLibrary
        imagePC.delegate = self
        imagePC.allowsEditing = true
        present(imagePC, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImage: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImage = editedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = originalImage
        }
        
        if let selectImg = selectedImage {
            titleImagePicker.image = selectImg
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
