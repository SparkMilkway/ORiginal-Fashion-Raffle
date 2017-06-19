//
//  UserPostsViewController.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 6/18/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import UIKit

class UserPostsViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    @IBOutlet var postsCollectionView: UICollectionView!
    
    @IBOutlet var collectionSuperView: UIView!
    
    let spacing : CGFloat = 1
    var selectedUserID : String? {
        didSet{
            fetchPostStrings()
        }
    }
    var userPosts = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postsCollectionView.delegate = self
        postsCollectionView.dataSource = self
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func fetchPostStrings() {
        if let userID = selectedUserID {
            API.userAPI.fetchUserPostsID(withUserID: userID, completion: {
                fetchedStrings in
                if let nowStrs = fetchedStrings {
                    if self.userPosts == nowStrs {
                        // No new stuff
                        print("No new stuff")
                        return
                    }
                    self.userPosts = nowStrs
                    self.postsCollectionView.reloadData()
                }
            })

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserPostsCell", for: indexPath) as! UserPostsCell
        let currentPostID = userPosts[indexPath.item]
        cell.postID = currentPostID
        return cell

    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.userPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenwidth = postsCollectionView.frame.width
        let cellWidth = CGFloat((screenwidth - spacing*3*2)/3)
        let cellSize = CGSize(width: cellWidth, height: cellWidth)
        return cellSize
        
    }
}
