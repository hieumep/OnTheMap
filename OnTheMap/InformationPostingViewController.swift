//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Hieu Vo on 1/23/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import UIKit
import CoreLocation


class InformationPostingViewController : UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var locationText: UITextView!
    
    let textViewDelegate = TextViewDelegate()
    var location : (CLLocationCoordinate2D)? = nil
    let locationManager = CLLocationManager()
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    override func viewDidLoad() {
        
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        self.tabBarController?.tabBar.hidden = true
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer!.numberOfTapsRequired = 1
        locationText.delegate = textViewDelegate
        addKeyboardDismissRecognizer()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardDismissRecognizer()
    }

    @IBAction func currentLocationTouchUp(sender: AnyObject) {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
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
                    self.sentLocationToDetailMap(placemark)
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
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!){(placemarks, error) in
            if let error = error {
                self.displayError(error.localizedDescription)
                return
            }
            
            if placemarks!.count >= 0 {
                let placemark = placemarks![0] as CLPlacemark
                self.locationManager.stopUpdatingLocation()
                self.sentLocationToDetailMap(placemark)
            } else {
                self.displayError("Problem with the data received from geocoder")
            }
        }
    }
    
    func sentLocationToDetailMap(placeMark : CLPlacemark){
        let location = placeMark.location?.coordinate
        let detailLocationVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetaiLocationViewController") as! DetailLocationViewController
        detailLocationVC.location = location
        detailLocationVC.searchString = placeMark.locality
        self.navigationController?.pushViewController(detailLocationVC, animated: true)    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        displayError(error.localizedDescription)
    }
    
    func addKeyboardDismissRecognizer() {
        self.view.addGestureRecognizer(tapRecognizer!)
    }
    
    func removeKeyboardDismissRecognizer() {
        self.view.removeGestureRecognizer(tapRecognizer!)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    
}
