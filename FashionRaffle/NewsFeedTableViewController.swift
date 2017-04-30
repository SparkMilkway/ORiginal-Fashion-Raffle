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
import SVProgressHUD


class NewsFeedTableViewController: UITableViewController, UISearchBarDelegate {
    
    var newsF : [NewsFeed] = []
    // search attributes
    //var filterednewsDatas : [NewsFeedData] = []
    //let searchBar = UISearchBar()
    var label : UILabel?
    //var shouldFiltContents = false
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SettingsLauncher.showLoading(Status: "Loading...")
        label?.text = self.title
       // try! FIRAuth.auth()?.signOut()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search button"), style: .plain, target: self, action: #selector(self.searchTapped))

        ref.child("Demos").queryOrderedByKey().observe(.childAdded, with: {
            snapshot in
            guard let newsFeedData = snapshot.value as? [String:Any] else {
                print("No Data here! Fatal error with Firebase NewsFeed Data")
                return
            }
            
            let newsID = snapshot.key //get newsID
            let timestamp = newsFeedData["timestamp"] as? String
            let newNewsData = NewsFeed.initWithNewsID(newsID: newsID, contents: newsFeedData)!
            newNewsData.timestamp = timestamp!

            self.newsF.insert(newNewsData, at: 0)
            self.tableView.reloadData()
            
            SettingsLauncher.dismissLoading()
            
        })

    }
    
    //The function for search bar
    
    func searchTapped() {
        /*
        searchBar.delegate = self
        searchBar.tintColor = UIColor(red: 55/255, green: 183/255, blue: 255/255, alpha: 1)
        
        searchBar.isHidden = false
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Explore your interest!"
        self.navigationItem.titleView = searchBar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelsearch))
        */
    }
    
    //cancel the search if needed
    
    func cancelsearch() {
        /*
        searchBar.text = ""
        shouldFiltContents = false
        self.tableView.reloadData()
        searchBar.isHidden = true
        self.navigationItem.titleView = label
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "search button"), style: .plain, target: self, action: #selector(self.searchTapped))
        */
    }
    
    
    // Function for search bar ends
    
    //Search Functions
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        /*
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
        */
        
    }
    
    
    
    //Search Functions end
    
    //Close Search Bar if needed
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        /*searchBar.endEditing(true)
        shouldFiltContents = true
        self.tableView.reloadData()
 */
    }
    
    
    //Close search bar functions end
    
    
    func handleRefresh(refreshControl: UIRefreshControl) {

        /*
        self.tableView.reloadData()
        refreshControl.endRefreshing()
        */
    }
    
    
    //TableView Delegates
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "NewsCell", for: indexPath) as! NewsDataCell

        let newsCell = self.newsF[indexPath.row]
        if let image = newsCell.titleImage {
            cell.Cellimage.image = image
        }
        
        cell.timestamp!.text = newsCell.timestamp
        cell.Title!.text = newsCell.title
        cell.Subtitle!.text = newsCell.subtitle
        if let releaseDate = newsCell.releaseDate {
            let releaseStr = releaseDate.dateToStr()
            cell.releaseDateEvent.setTitle("Release on " + releaseStr, for: .normal)
        }
        else {
            cell.releaseDateEvent.setTitle("TBD", for: .normal)
        }
        return cell
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let feed = self.newsF
        return feed.count

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let newsCell = self.newsF[indexPath.row]
        NewsFeed.selectedNews = newsCell
        let storyboard = UIStoryboard(name: "FirstDemo", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "NewsReusableView") as! NewsReusableViewController
        //searchBar.endEditing(true)
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
