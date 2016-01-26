//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Hieu Vo on 1/23/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import UIKit
import CoreLocation


class InformationPostingViewController : UIViewController{
    
    @IBOutlet weak var locationText: UITextView!
    var location : (CLLocationCoordinate2D)? = nil
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        self.tabBarController?.tabBar.hidden = true
    }
    @IBAction func findOnTheMapTouchUp(sender: AnyObject) {
        if locationText.text.isEmpty {
            displayError("Must Enter a Location")
        }else{
            getLocation(locationText.text)
        }
    }
    
    func getLocation(locationText : String){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(locationText){(placemarks,error) in
            if error != nil {
                self.displayError("Invalid location")

            }else {
                if placemarks?.count > 0 {
                    let placemark = placemarks![0]
                    let location = placemark.location?.coordinate
                    let detailLocationVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetaiLocationViewController") as! DetailLocationViewController
                    detailLocationVC.location = location
                    detailLocationVC.searchString = self.locationText.text
                    self.navigationController?.pushViewController(detailLocationVC, animated: true)
                }
            }
        }
    }
    
    func displayError(errorString : String){
        let alertVC = UIAlertController(title: nil, message: errorString, preferredStyle: .Alert)
        let alerAction = UIAlertAction(title: "Dismiss", style:.Cancel, handler: nil)
        alertVC.addAction(alerAction)
        self.presentViewController(alertVC, animated: true, completion: nil)
    }
    
}
