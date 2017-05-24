//
//  NewsFeedData.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 11/14/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import EventKit


class NewsFeed {
    // title, subtitle, detailInfo can't be nil
    let newsID:String?
    var timestamp:String
    let releaseDate:String?
    let title:String
    let subtitle:String
    let detailInfo:String
    let headImageUrl:URL?
    var detailImageUrls:[URL]?
    var tags:[String]?
    var likedUsers:[String]?
    static var selectedNews:NewsFeed?
    
    init(newsID:String?, timestamp: String,releaseDate: String?, title:String, subtitle:String, detailInfo:String, tags:[String]?, likedUsers:[String]?, headImageURL: URL?, detailImageURLs: [URL]?) {
        self.newsID = newsID
        self.title = title
        self.subtitle = subtitle
        self.detailInfo = detailInfo
        self.tags = tags
        self.releaseDate = releaseDate
        self.likedUsers = likedUsers
        self.headImageUrl = headImageURL
        self.detailImageUrls = detailImageURLs
        self.timestamp = timestamp
    }
    
    static func createNewFeed(newsID: String?, releaseDate: String?, title: String, subtitle: String, detailInfo: String, tags: [String]?, headImageURL: URL?, detailImageURLs: [URL]?) -> NewsFeed? {
        
        return NewsFeed(newsID: newsID, timestamp: Date().now(), releaseDate: releaseDate, title: title, subtitle: subtitle, detailInfo: detailInfo, tags: tags, likedUsers: nil, headImageURL: headImageURL, detailImageURLs: detailImageURLs)
        
    }
    
    // Fetch the News Feed
    static func initWithNewsID(newsID:String, contents:[String:Any]) -> NewsFeed? {
        guard let title = contents["title"] as? String else{
            print("No news fetched")
            return nil
        }
        let subtitle = contents["subtitle"] as? String
        
        let detailInfo = contents["detailInfo"] as? String
        
        let tags = contents["tags"] as? [String]
        
        let headImageURL: URL?
        
        if let headImageUrlstr = contents["headImageUrl"] as? String {
            headImageURL = URL(string: headImageUrlstr)
        }
        else {
            headImageURL = nil
        }
        
        var detailImageURL = [URL]()
        
        if let detailImageUrlstr = contents["detailImageUrls"] as? [String] {
            for url in detailImageUrlstr {
                let tempURL = URL(string: url)
                detailImageURL.append(tempURL!)
            }
        }
        
        let releaseDate = contents["releaseDate"] as? String
        
        let likedUsers = contents["likedUsers"] as? [String]
        
        let timestamp = contents["timestamp"] as? String
        
        return NewsFeed(newsID: newsID, timestamp: timestamp!, releaseDate: releaseDate, title: title, subtitle: subtitle!, detailInfo: detailInfo!, tags: tags, likedUsers: likedUsers, headImageURL: headImageURL, detailImageURLs: detailImageURL)

    }
    
    func dictValue() -> [String:Any] {
        var newsDict:[String:Any] = [:]
        //newsID, timestamp, title, titleImage, subtitle, detailInfo, imagePool, tags
        newsDict["newsID"] = newsID
        newsDict["timestamp"] = timestamp
        newsDict["title"] = title
        newsDict["subtitle"] = subtitle
        newsDict["detailInfo"] = detailInfo
        newsDict["tags"] = tags
        newsDict["likedUsers"] = likedUsers
        newsDict["releaseDate"] = releaseDate
        if let headImageurl = headImageUrl {
            newsDict["headImageUrl"] = "\(headImageurl)"
        }
    
        var detailImageURLStr = [String]()
        if let detailImageurls = detailImageUrls {
            for url in detailImageurls {
                detailImageURLStr.append("\(url)")
            }
            newsDict["detailImageUrls"] = detailImageURLStr
        }
        return newsDict
    }
    // Sync to database

}




class NewsDataCell: UITableViewCell{
    
    @IBOutlet weak var Cellimage: UIImageView!
    
    
    @IBOutlet weak var Title: UILabel!
    
    @IBOutlet weak var timestamp: UILabel!
    @IBOutlet weak var Subtitle: UILabel!
    
    @IBOutlet weak var releaseDateEvent: UIButton!
    
    @IBAction func createEvent(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        print(self.releaseDateEvent.currentTitle!)
        
        if appDelegate.eventStore == nil {
            appDelegate.eventStore = EKEventStore()
            
            appDelegate.eventStore?.requestAccess(
                to: EKEntityType.reminder, completion: {(granted, error) in
                    if !granted {
                        print("Access to store not granted")
                        print(error?.localizedDescription)
                    } else {
                        print("Access granted")
                    }
            })
        }
        
        if (appDelegate.eventStore != nil) {
            print( self.releaseDateEvent.currentTitle! + "test")//
            if(self.releaseDateEvent.currentTitle == "TBD"){
                return
            }
            else{
                createReminder(releasedate: self.releaseDateEvent.currentTitle!)
            }
        }
        open(scheme: "x-apple-reminder://")
        

    }
    
    func createReminder(releasedate: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let reminder = EKReminder(eventStore: appDelegate.eventStore!)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy HH:mm"
        
        
        
        reminder.calendar = appDelegate.eventStore!.defaultCalendarForNewReminders()
        //let dateString = "12/12/2017 5:00"//test
        let dateString = releasedate
        print(releasedate + "----")
        
        reminder.title = self.Title.text! + ": "+dateString
        
        let date = dateFormatter.date(from: dateString)
        let datesss = dateFormatter.date(from: releasedate)
        print(datesss!,  "actual")
        
        
        print(dateString + "==========")
        print(date! , "result")
        let alarm = EKAlarm(absoluteDate: date!)
        
        reminder.addAlarm(alarm)
        
        do {
            try appDelegate.eventStore?.save(reminder,
                                             commit: true)
        } catch let error {
            print("Reminder failed with error \(error.localizedDescription)")
        }
    }
    

}

func open(scheme: String) {
    if let url = URL(string: scheme) {
        if #available(iOS 10, *) {
            UIApplication.shared.open(url, options: [:],
                                      completionHandler: {
                                        (success) in
                                        print("Open \(scheme): \(success)")
            })
        } else {
            let success = UIApplication.shared.openURL(url)
            print("Open \(scheme): \(success)")
        }
    }
}
