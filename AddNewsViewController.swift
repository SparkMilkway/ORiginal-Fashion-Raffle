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

class AddNewsTableViewController: UITableViewController {
    
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var subtitleText: UITextField!
    @IBOutlet weak var releaseDLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var timePicker: UIDatePicker!
    @IBOutlet weak var detailText: UITextView!
    
    @IBAction func postNews(_ sender: Any) {
        let titleEdit = self.titleText.text
        let subtitleEdit = self.subtitleText.text
        let detailEdit = self.detailText.text
        let imageSelect = self.titleImage.image
        let releaseDstr = self.releaseDLabel.text
        guard let releaseD = Date.strToDate(Str: releaseDstr!) else {
            SettingsLauncher.showAlerts(title: "Error!", message: "Date format is not correct", handler: nil, controller: self)
            return
        }
        if (titleEdit == "" || subtitleEdit == "" || detailEdit == "" || imageSelect == nil) {
            SettingsLauncher.showAlerts(title: "Error!", message: "Please enter all the required info", handler: nil, controller: self)
        }
        else {
            SettingsLauncher.showLoading(Status: "Uploading new post...")
            let newPost = NewsFeed.init(newsID: nil, releaseDate: releaseD, title: titleEdit!, titleImage: imageSelect, subtitle: subtitleEdit!, detailInfo: detailEdit!, imagePool: nil, tags: ["Text"])
            ref.child("Demos").childByAutoId().setValue(newPost.dictValue())
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+1, execute: {
                SettingsLauncher.dismissLoading()
                SettingsLauncher.showAlerts(title: "Success!", message: "This piece of news is posted!", handler: {
                    UIAlertAction in
                    self.navigationController?.popToRootViewController(animated: true)
                }, controller: self)
            })
        }
    }
    
    @IBAction func backToProfile(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        titleImage.isUserInteractionEnabled = true
        titleImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectNewsImageView)))
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        self.updateDateLabel()
        
        datePicker.addTarget(self, action: #selector(datePickerChanged(datePicker:)), for: .valueChanged)
        timePicker.addTarget(self, action: #selector(timePickerChanged(timePicker:)), for: .valueChanged)
        
    }
    
    func updateDateLabel() {
        let dateFormat = DateFormatter()
        let timeFormat = DateFormatter()
        dateFormat.dateFormat = "MM/dd/yyyy"
        timeFormat.dateFormat = "HH:mm"
        let strDate = dateFormat.string(from: self.datePicker.date)
        let strTime = timeFormat.string(from: self.timePicker.date)
        self.releaseDLabel.text = strDate + " " + strTime
    }
    
    func datePickerChanged(datePicker:UIDatePicker) {
        self.updateDateLabel()
    }
    
    func timePickerChanged(timePicker:UIDatePicker) {
        self.updateDateLabel()
        
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension AddNewsTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
            titleImage.image = selectImg
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}



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
            let newPost = NewsFeed.init(newsID: nil, releaseDate:nil, title: titleEdit!, titleImage: imageSelect, subtitle: subtitleEdit!, detailInfo: detailEdit!, imagePool: nil, tags: ["Text"])
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
