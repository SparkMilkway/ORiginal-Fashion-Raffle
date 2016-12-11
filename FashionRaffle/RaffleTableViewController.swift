//
//  RaffleTableViewController.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 11/27/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorageUI
import SVProgressHUD

class RaffleTableViewController: UITableViewController {
    
    var raffleDatas : [RafflePoolData] = []
    let storageReference = FIRStorage.storage()
    let ref = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        self.ref.child("Raffles").queryOrderedByKey().observe(.childAdded, with: {
            snapshot in
            
            let value = snapshot.value as? NSDictionary
            let title = value!["Title"] as! String
            let subtitle = value!["SubTitle"] as! String
            let image = value!["Image"] as! String
            let details = value!["Text"] as! String
            
            let raffleData = RafflePoolData.init(title: title, subtitle: subtitle, image: image, details: details)
            self.raffleDatas.append(raffleData)
            self.tableView.reloadData()
        })
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.raffleDatas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "RaffleMainCell", for: indexPath) as! RafflePoolCell
        
        let raffledata = raffleDatas[indexPath.row]
        let imageURL = raffledata.image1
        let storage = self.storageReference.reference(forURL: imageURL)
        cell.CellImage.sd_setImage(with: storage)
        cell.Title!.text = raffledata.title
        cell.Subtitle!.text = raffledata.subtitle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let raffledata = self.raffleDatas[indexPath.row]
        let storyboard = UIStoryboard(name: "FirstDemo", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RaffleReusableView") as! RaffleReusableViewController

        
        viewController.title = raffledata.title
        let imageURL = raffledata.image1
        let storage = self.storageReference.reference(forURL: imageURL)
        viewController.reference = storage
        viewController.passLabel = raffledata.title
        viewController.passDetail = raffledata.details
        
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
}
