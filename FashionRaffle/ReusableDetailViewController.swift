//
//  ReusableDetailViewController.swift
//  FashionRaffle
//
//  Created by Spark Da Capo on 5/22/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import UIKit
import Photos
import SVProgressHUD

class ReusableDetaiViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet var deleteButton: UIBarButtonItem!
    
    var imageAssets = [UIImage?]()
    var currentIndexPath = IndexPath()
    var deletable : Bool = true
    var rootCollectionViewController: AddNewsTableViewController?
    var cellSize: CGSize {
        return Size.screenRectWithoutAppBar(self).size
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = UIColor.black
        //Set used by editing or viewing
        if deletable {
            self.navigationItem.rightBarButtonItem = self.deleteButton
        }
        else{
            self.navigationItem.rightBarButtonItems = []
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        let indexPath = self.currentIndexPath
        self.scrollCollectionView(to: indexPath)
        collectionView?.reloadData()

        
    }

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionDetailCell", for: indexPath) as? ReusableCollectionCell
        if let image = imageAssets[indexPath.row] {
            cell?.collectionImageView.image = image
        }
        cell?.collectionScrollView.zoomScale = 1
        cell?.collectionScrollView.maximumZoomScale = 2
        cell?.collectionScrollView.minimumZoomScale = 1
        cell?.tag = indexPath.item
        cell?.collectionScrollView.delegate = cell
        
        return cell!
        
    }
 
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageAssets.count
    }

    
    func scrollCollectionView(to indexPath: IndexPath) {
        let count: Int? = imageAssets.count
        guard count != nil else {
            return
        }
        DispatchQueue.main.async {
            let toIndexPath = IndexPath(item: indexPath.item, section: 0)
            self.collectionView?.scrollToItem(at: toIndexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    // Delete contents
    
    
    @IBAction func deleteAction(_ sender: Any) {
        guard deletable else {
            return
        }
        let indexPath = currentIndexPath
        let refreshAlert = UIAlertController(title: "Delete this photo?", message: "", preferredStyle: .alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .cancel, handler: {
            UIAlertAction in
            SVProgressHUD.showSuccess(withStatus: "Deleted!")
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()+0.6, execute: {
                SVProgressHUD.dismiss()
                self.deleteRootCollectionViewItem(at: indexPath)
                if self.imageAssets.count == 1 {
                    
                    self.navigationController?.popToRootViewController(animated: true)
                    return
                }
                self.imageAssets.remove(at: indexPath.item)
                self.collectionView?.reloadData()
                self.updateCurrentIndexPath()
                
                
            })
            

            
            
            
        }))
        refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: nil))
        self.present(refreshAlert, animated: true, completion: nil)
    }
    
    
    //Scrollview delegate


    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateCurrentIndexPath()
    }
 
    func updateCurrentIndexPath() {
        guard let collectionV = collectionView else {
            return
        }
        let row = Int((collectionV.contentOffset.x + cellSize.width * 0.5) / cellSize.width)
        if row < 0 {
            self.currentIndexPath = IndexPath(row: 0, section: self.currentIndexPath.section)
        }else if row >= collectionV.numberOfItems(inSection: 0) {
            self.currentIndexPath = IndexPath(row: collectionV.numberOfItems(inSection: 0) - 1, section: self.currentIndexPath.section)
        }else {
            self.currentIndexPath = IndexPath(row: row, section: self.currentIndexPath.section)
        }
    }
    
    func deleteRootCollectionViewItem(at indexPath: IndexPath) {
        guard let rootVC = rootCollectionViewController else {
            return
        }
        rootVC.imageDetailPool.remove(at: indexPath.item)
        rootVC.imagePool.remove(at: indexPath.item)
        rootVC.imageCollectionView.reloadData()
        
    }
    
}
