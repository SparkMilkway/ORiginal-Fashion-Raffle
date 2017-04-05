//
//  uploadimage+handler.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 11/20/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit
import Firebase

extension SettingTableViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    
    
    func handleSelectProfileImageView() {
        let imagePickerController = UIImagePickerController()
        
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImage.image = selectedImage
        }
        dismiss(animated: true, completion: {
            () -> Void in
            self.uploadProfileImage()
        })
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

