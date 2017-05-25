//
//  visitorBrandViewController.swift
//  
//
//  Created by Mac on 5/25/17.
//
//

import UIKit

class visitorBrandViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var visitorBrandsCV: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return followingBrands.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let brandCell = collectionView.dequeueReusableCell(withReuseIdentifier: "brand", for: indexPath) as! brandCollectionViewCell
        
        brandCell.brandImage.image = UIImage(named: "background")
        brandCell.layer.cornerRadius = 50
        brandCell.brandImage.contentMode = .scaleAspectFit
        
        return brandCell
    }

}
