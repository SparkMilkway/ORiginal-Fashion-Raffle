//
//  profileMainViewExtension.swift
//  FashionRaffle
//
//  Created by Mac on 5/6/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation

extension profileMainViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    func handleSelectProfileImageView( ) {
        let imagePickerController = UIImagePickerController()
        
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        chooseImage = true
        present(imagePickerController, animated: true, completion: nil)
        
        
    }
    func handleSelectBackgroundImageView( ) {
        let imagePickerController = UIImagePickerController()
        
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        chooseImage = false
        present(imagePickerController, animated: true, completion: nil)
        
        
    }

    


    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            
            selectedImageFromPicker = originalImage
        }
        
        if chooseImage == true {
            if let selectedImage = selectedImageFromPicker {
                profileImage.image = selectedImage
            }
            dismiss(animated: true, completion: {
                () -> Void in
                self.uploadProfileImage()
            })
        }else{
            
            if let selectedImage = selectedImageFromPicker {
                profileBackground.image = selectedImage
            }
            //dismiss(animated: true, completion: {
              //  () -> Void in
                //self.uploadProfileImage()
            //})
            dismiss(animated: true, completion: nil)
            
        }
        
        
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}
