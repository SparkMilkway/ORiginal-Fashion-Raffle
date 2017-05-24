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
import Imaginary
import SVProgressHUD

class RaffleTableViewController: UITableViewController {
    
    var raffleFeedDatas = [RaffleFeed]()
    let storageReference = FIRStorage.storage()
    let ref = FIRDatabase.database().reference()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        ref.child("Raffles").queryOrderedByKey().observe(.childAdded, with: {
            snapshot in
            guard let raffleData = snapshot.value as? [String:Any] else {
                print("No data here!")
                return
            }
            let raffleID = snapshot.key
            let newRaffleData = RaffleFeed.initWithRaffleID(raffleID: raffleID, contents: raffleData)!
            self.raffleFeedDatas.insert(newRaffleData, at: 0)
            self.tableView.reloadData()

        })

        
    }
    
    override func didReceiveMemoryWarning() {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.raffleFeedDatas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "RaffleMainCell", for: indexPath) as! RafflePoolCell
        
        
        let raffledata = raffleFeedDatas[indexPath.row]
        let imageURL = raffledata.headImageUrl
        cell.CellImage.setImage(url: imageURL)
        cell.Title!.text = raffledata.title
        cell.Subtitle!.text = raffledata.subtitle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Hooray!")
        /*
        let raffledata = self.raffleFeedDatas[indexPath.row]
        let storyboard = UIStoryboard(name: "FirstDemo", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "RaffleReusableView") as! RaffleReusableViewController

        
        viewController.title = raffledata.title
        let imageURL = raffledata.image1
        let storage = self.storageReference.reference(forURL: imageURL)
        viewController.reference = storage
        viewController.passLabel = raffledata.title
        viewController.passDetail = raffledata.details
        viewController.passKey = raffledata.pathKey
        
        self.navigationController?.pushViewController(viewController, animated: true)
        */
    }
    
}
