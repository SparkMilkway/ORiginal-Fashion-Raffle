//
//  fusumaPhotoViewController.swift
//  FashionRaffle
//
//  Created by Mac on 2016/12/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit
//import Fusuma



class fusumaPhotoViewController: UIViewController, FusumaDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
   
    
    //prepare implement unwind segue to update the table view content
    
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var showButton: UIButton!
    
    
    @IBOutlet weak var fileUrlLabel: UILabel!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var brandName: UITextField!
    
  //  @IBOutlet weak var brandLabel: UILabel!
    
    
    //Mark: _tableViewMethod
    /*
    func tableView(_ tagsTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }*/
    
    var tags = [Tags]()
    var choosenRow = 0

    
    
    //Mark: _ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
       

        // Do any additional setup after loading the view
        
        showButton.layer.cornerRadius = 2.0
        self.fileUrlLabel.text = ""
       
        pickerView.delegate = self
        pickerView.dataSource = self
        tags.append(Tags(category: "hat",brand: "", size: "", collection: ""))
        tags.append(Tags(category: "top",brand: "", size: "", collection: ""))
        tags.append(Tags(category: "bottom",brand: "", size: "", collection: ""))
        tags.append(Tags(category: "shoes",brand: "", size: "", collection: ""))
        tags.append(Tags(category: "accessory",brand: "", size: "", collection: ""))

        


    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return tags.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        choosenRow = row
        print(choosenRow)
    }
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let myView = UIView()
        myView.frame = CGRect(x: 0, y: 0, width: pickerView.bounds.width , height: 40)
        var myImageView = UIImageView()
        myImageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        //myImageView.contentMode = UIViewContentMode.scaleAspectFit;
        
        switch row{
        case 0:
            myImageView = UIImageView(image: UIImage(named:"video_button"))
        case 1:
            myImageView = UIImageView(image: UIImage(named:"video_button"))
        case 2:
            myImageView = UIImageView(image: UIImage(named:"video_button"))
        case 3:
            myImageView = UIImageView(image: UIImage(named:"video_button"))
        case 4:
            myImageView = UIImageView(image: UIImage(named:"video_button"))
        case 5:
            myImageView = UIImageView(image: UIImage(named:"video_button"))
        default:
            myImageView.image = nil
            
            return myImageView
        }
        let myTags = UILabel()
        myTags.frame = CGRect(x: 80, y: 0, width: pickerView.bounds.width, height: 50)
        myTags.text = tags[row].category
        
        let myBrand = UILabel()
        myBrand.frame = CGRect(x: 240, y: 0, width: pickerView.bounds.width, height: 50)
        myBrand.text = tags[row].brand
        
        
        myView.addSubview(myTags)
        myView.addSubview(myBrand)
        myView.addSubview(myImageView)
        
        return myView
    }
    

    @IBAction func submit(_ sender: Any) {
        if (brandName != nil){
            tags[choosenRow].brand = brandName.text!
        }
        
        
        self.pickerView .reloadAllComponents()
        print(tags)
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showButtonPressed(_ sender: Any) {
        // Show Fusuma
        let fusuma = FusumaViewController()
        
        //        fusumaCropImage = false
        
        fusuma.delegate = self
        self.present(fusuma, animated: true, completion: nil)
    }
    func fusumaImageSelected(_ image: UIImage) {
        
        print("Image selected")
        showButton.setImage(nil, for: UIControlState.normal)

        imageView.image = image
    }
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        print("video completed and output to file: \(fileURL)")
        self.fileUrlLabel.text = "file output to: \(fileURL.absoluteString)"
    }
    
    func fusumaDismissedWithImage(_ image: UIImage) {
        print("Called just after dismissed FusumaViewController")
    }
    
    func fusumaCameraRollUnauthorized() {
        
        print("Camera roll unauthorized")
        
        let alert = UIAlertController(title: "Access Requested", message: "Saving image needs to access your photo album", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (action) -> Void in
            
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.openURL(url)
            }
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func fusumaClosed() {
        
        print("Called when the close button is pressed")
    }
    
    //Mark: _ ADD POP UP (Start)
    
    //tags.append(Tag(type: "", brand: ""))
    
    
    
    
   

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
