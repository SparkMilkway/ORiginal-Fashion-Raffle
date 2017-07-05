//
//  bountyQuestViewController.swift
//  FashionRaffle
//
//  Created by Mac on 6/20/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import MapKit


var myLocation = [String]()
var myBountyAmount = Int()

class bountyQuestViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var bountyAmount: UISlider!
    
    @IBOutlet weak var bounty: UILabel!
    
    @IBOutlet weak var map: MKMapView!
    
    let locationManager = CLLocationManager()

    @IBOutlet weak var locationSwitch: UISwitch!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bountyAmount.maximumValue = Float((Profile.currentUser?.tickets)!)
        locationSwitch.isOn = false
        map.isHidden = true
        locationManager.delegate = self
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func bountySetting(_ sender: UISlider) {
        bounty.text = "Bounty " + String(Int(round(bountyAmount.value)))
        myBountyAmount = Int(round(bountyAmount.value))
        print(round(bountyAmount.value))
    }
   
    @IBAction func useLocation(_ sender: UISwitch) {
        if (sender.isOn == true) {
            map.isHidden = false
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
            
            myLocation = [String(self.locationManager.location!.coordinate.latitude),
                               String(self.locationManager.location!.coordinate.longitude)]
           
            
        } else {
            map.isHidden = true
            myLocation = [""]
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.02, 0.02)
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let region = MKCoordinateRegion(center: center, span: span)
        
        // self.currentLocation.setRegion(region, animated: true)
        
        self.locationManager.stopUpdatingLocation()
        map.setRegion(region, animated: true)
        self.map.showsUserLocation = true
        
    }
  
}
