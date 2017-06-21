//
//  RaffleTableViewController.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 11/27/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import UIKit
import Imaginary
import SVProgressHUD
import ESPullToRefresh

class RaffleTableViewController: UITableViewController {
    
    var raffleFeedDatas = [RaffleFeed]()
    let raffleAPI = API.raffleAPI
    
    var currentLoad : UInt = 4
    var singleLoadLimit: UInt = 2
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        
        loadAttributes()
        
        self.tableView.es_addPullToRefresh {
            self.loadRowsFromTop()
        }
        self.tableView.es_addInfiniteScrolling {
            self.loadMore()
        }
    }
    
    // Refresh, load more and so on

    func loadAttributes() {
        
        raffleFeedDatas.removeAll()
        
        raffleAPI.fetchAllRaffles(withLimitToLast: self.currentLoad, completed: {
            fetchedRaffles in
            if let raffles = fetchedRaffles{
                self.raffleFeedDatas = raffles
                
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        })
        
    }
    
    
    func loadRowsFromTop() {
        
        if let firstID = self.raffleFeedDatas[0].raffleID {
            self.raffleAPI.checkNewRafflesInTable(withFirstRaffleID: firstID, completed: {
                checkValue in
                if checkValue == true {
                    print("will fetch new value")
                    self.raffleFeedDatas.removeAll()
                    self.raffleAPI.fetchAllRaffles(withLimitToLast: self.currentLoad, completed: {
                        fetchRaffles in
                        if let raffles = fetchRaffles {
                            self.raffleFeedDatas = raffles
                            self.tableView.reloadData()
                            self.tableView.es_stopPullToRefresh()
                            return
                        }
                        else {
                            Config.showError(withStatus: "Loading Error!")
                            return
                        }
                    })
                }
                
            })
        }
        //Otherwise
        print("No new Raffle Data")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3, execute: {
            self.tableView.es_stopPullToRefresh()
            return
        })
        
    }
    
    func loadMore() {
        
        //Still more data
        if currentLoad <= UInt(raffleFeedDatas.count) {
            currentLoad = currentLoad + singleLoadLimit
            let checkCount = self.raffleFeedDatas.count
            
            self.raffleAPI.fetchAllRaffles(withLimitToLast: self.currentLoad, completed: {
                allRaffles in
                
                if let tempRaffles = allRaffles{
                    if tempRaffles.count > checkCount {
                        print("Has More Data")
                        self.raffleFeedDatas.removeAll()
                        self.raffleFeedDatas = tempRaffles
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.1, execute: {
                            
                            self.tableView.reloadData()
                            self.tableView.es_stopLoadingMore()
                            return
                        })
                    }
                    else {
                        print("No new Data now")
                        DispatchQueue.main.async {
                            self.tableView.es_noticeNoMoreData()
                            return
                        }
                    }
                }
            })
            
            // No more data actually
        }
        else {
            //No more data
            print("No more data to load")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.3, execute: {
                self.tableView.es_noticeNoMoreData()
            })
            
        }
        
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.raffleFeedDatas.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "RaffleMainCell", for: indexPath) as! RafflePoolCell
        
        
        let raffledata = raffleFeedDatas[indexPath.row]
        cell.raffleValue = raffledata
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
