//
//  NewsFeedTableViewController.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 11/15/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabase

class NewsFeedTableViewController: UITableViewController {
    
    var newsDatas : [NewsFeedData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        let ref = FIRDatabase.database().reference()
        
        ref.child("Demos").queryOrderedByKey().observe(.childAdded, with: {
        snapshot in
            
            let value = snapshot.value as? NSDictionary
            let title = value!["Title"] as? String
            let subtitle = value!["SubTitle"] as? String
            
            let newsData = NewsFeedData.init(title: title!, subtitle: subtitle!)
            self.newsDatas.append(newsData)
            
            self.tableView.reloadData()
        
        })
        

    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsDataCell
        let newstemp = newsDatas[indexPath.row]
        cell.Title!.text = newstemp.title
        cell.Subtitle!.text = newstemp.subtitle
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.newsDatas.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let newsData = newsDatas[indexPath.row]
        let storyboard = UIStoryboard(name: "FirstDemo", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NewsReusableView") as! NewsReusableViewController
        
        viewController.title = newsData.title
        viewController.passLabel = newsData.title
        viewController.passDetail = newsData.subtitle
        
        
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
