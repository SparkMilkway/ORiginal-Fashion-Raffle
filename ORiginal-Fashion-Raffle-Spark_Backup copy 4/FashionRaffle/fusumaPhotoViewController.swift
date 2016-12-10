//
//  fusumaPhotoViewController.swift
//  FashionRaffle
//
//  Created by Mac on 2016/12/4.
//  Copyright © 2016年 Mac. All rights reserved.
//

import UIKit
//import Fusuma



class fusumaPhotoViewController: UIViewController,UITableViewDelegate, FusumaDelegate, UITableViewDataSource {
    
    @IBOutlet var addTagView: UIView!
    
    @IBOutlet weak var addCategory: UITextField!
    
    @IBOutlet weak var addBrandInfo: UITextField!
    
    
    @IBOutlet weak var popupVisualEffectView: UIVisualEffectView!
    var effect : UIVisualEffect!
    
    @IBAction func dismissPopup(_ sender: Any) {
        //tags.append(Tags(category: addCategory.text! ,brand: addBrandInfo.text! , size: "", collection: ""))
        
        

        animatedOut()
        print (tags)
    }
    
    //prepare implement unwind segue to update the table view content
    
    @IBOutlet weak var updateAndDismiss: UIButton!
    @IBAction func updateTag(_ sender: UIStoryboardSegue) {
        animatedOut()
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var showButton: UIButton!
    
    
    @IBOutlet weak var fileUrlLabel: UILabel!
    
    @IBOutlet weak var tagsTableView: UITableView!
    
    
    @IBAction func addMoreTag(_ sender: Any) {
        animatedIn()
    }
    
  //  @IBOutlet weak var brandLabel: UILabel!
    
    
    //Mark: _tableViewMethod
    /*
    func tableView(_ tagsTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }*/
    
    var tags = [Tags]()
    

    
    public func tableView(_ tagsTableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return(tags.count)
    }
    
    public func tableView(_ tagsTableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tagsTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! photoTagTableViewCell
        cell.categoryTag.text = tags[indexPath.row].category
        cell.brandLabel.text = "brand"
        
        //int to string a.text = "\(a.year)"
        return (cell)
    }
    
    //Mark: _ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        effect = popupVisualEffectView.effect
        popupVisualEffectView.effect = nil
        addTagView.layer.cornerRadius = 5 //popup
        

        // Do any additional setup after loading the view
        
        showButton.layer.cornerRadius = 2.0
        self.fileUrlLabel.text = ""
        
        tagsTableView.dataSource = self
        tagsTableView.delegate = self
        
        tags.append(Tags(category: "hat",brand: "", size: "", collection: ""))
        tags.append(Tags(category: "top",brand: "", size: "", collection: ""))
        tags.append(Tags(category: "bottom",brand: "", size: "", collection: ""))
        tags.append(Tags(category: "shoes",brand: "", size: "", collection: ""))
        tags.append(Tags(category: "accessory",brand: "", size: "", collection: ""))



        


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
    func animatedIn() {
        self.view.addSubview(addTagView)
        addTagView.center = self.view.center
        addTagView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        addTagView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.popupVisualEffectView.effect = self.effect
            self.addTagView.alpha = 1
            self.addTagView.transform = CGAffineTransform.identity
        }
    }
    
    func animatedOut() {
        UIView.animate(withDuration: 0.3, animations:{
            self.addTagView.transform = CGAffineTransform.init(scaleX: 1.3, y:1.3)
            self.addTagView.alpha = 0
            self.popupVisualEffectView.effect = nil
        }) { (success: Bool) in
            self.addTagView.removeFromSuperview()
        }
    }
    
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
