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
import FirebaseStorageUI

class NewsFeedTableViewController: UITableViewController, UISearchBarDelegate {
    
    var newsDatas : [NewsFeedData] = []
    
    // search attributes
    var filterednewsDatas : [NewsFeedData] = []
    
    let searchBar = UISearchBar()
    
    var label : UILabel?
    
    var shouldFiltContents = false
    //let searchController = UISearchController(searchResultsController: nil)
    
    let storageReference = FIRStorage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label?.text = self.title
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search button"), style: .plain, target: self, action: #selector(self.searchTapped))
        
        
        let ref = FIRDatabase.database().reference()
        
        
        ref.child("Demos").queryOrderedByKey().observe(.childAdded, with: {
            snapshot in
            
            let value = snapshot.value as? NSDictionary
            let title = value!["Title"] as? String
            let subtitle = value!["SubTitle"] as? String
            let image = value!["Image"] as? String
            
            let newsData = NewsFeedData.init(title: title!, subtitle: subtitle!, image: image!)
            self.newsDatas.insert(newsData, at: 0)
            
            self.tableView.reloadData()
            
        })
        self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(refreshControl:)), for: .valueChanged)
    }
    
    //The function for search bar
    
    func searchTapped() {
        
        searchBar.delegate = self
        searchBar.tintColor = UIColor(red: 55/255, green: 183/255, blue: 255/255, alpha: 1)
        
        searchBar.isHidden = false
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Explore your interest!"
        self.navigationItem.titleView = searchBar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelsearch))

        
    }
    
    //cancel the search if needed
    
    func cancelsearch() {
        searchBar.text = ""
        shouldFiltContents = false
        self.tableView.reloadData()
        searchBar.isHidden = true
        self.navigationItem.titleView = label
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search button"), style: .plain, target: self, action: #selector(self.searchTapped))
    }
    
    
    // Function for search bar ends
    
    //Search Functions
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.filterednewsDatas = newsDatas.filter({content -> Bool in
            let title = content.title
            return title.lowercased().contains(searchText.lowercased())
        
        })
        if searchText != "" {
            shouldFiltContents = true
            self.tableView.reloadData()
        }
        else {
            shouldFiltContents = false
            self.tableView.reloadData()
        }
        
    }
    
    /*func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
     self.filterednewsDatas = newsDatas.filter({ content in
     
     let title = content.title
     return title.lowercased().contains(searchText.lowercased())
     
     })
     
     if searchText != "" {
     shouldFiltContents = true
     self.tableView.reloadData()
     }
     else {
     shouldFiltContents = false
     self.tableView.reloadData()
     }
     }*/
    
    
    
    //Search Functions end
    
    //Close Search Bar if needed
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        shouldFiltContents = true
        self.tableView.reloadData()
    }
    
    
    //Close search bar functions end
    
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        
        
        
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    
    //TableView Delegates
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsDataCell
        
        
        var newstemp : NewsFeedData
        
        if shouldFiltContents == false {
         newstemp = newsDatas[indexPath.row]
         }
         else {
         newstemp = filterednewsDatas[indexPath.row]
         }
        
        //newstemp = newsDatas[indexPath.row]
        
        
        let imageURL = newstemp.image
        let storage = storageReference.reference(forURL: imageURL)
        
        cell.Cellimage.sd_setImage(with: storage)
        
        cell.Title!.text = newstemp.title
        cell.Subtitle!.text = newstemp.subtitle
        
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if shouldFiltContents == true {
         return self.filterednewsDatas.count
         }
        return self.newsDatas.count
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        var newsData : NewsFeedData
        
        if shouldFiltContents == true {
         newsData = filterednewsDatas[indexPath.row]
         }
         else {
         newsData = newsDatas[indexPath.row]
         }
        
        let storyboard = UIStoryboard(name: "FirstDemo", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NewsReusableView") as! NewsReusableViewController
        
        viewController.title = newsData.title
        
        let imageURL = newsData.image
        let storage = storageReference.reference(forURL: imageURL)
        
        viewController.reference = storage
        
        viewController.passLabel = newsData.title
        viewController.passDetail = newsData.subtitle
        
        searchBar.endEditing(true)
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    //TableView Delegates end
    
    
    
    //Search bar delegates
    
    
    /*
     func updateSearchResults(for searchController: UISearchController) {
     // updates
     filterContents(searchText: self.searchController.searchBar.text!)
     }
     */
    //Search Bar delegates end
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
