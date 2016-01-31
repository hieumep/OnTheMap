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
    
    var activityIndicator = UIActivityIndicatorView()
    @IBOutlet weak var locationText: UITextView!
    
    let textViewDelegate = TextViewDelegate()
    var location : (CLLocationCoordinate2D)? = nil
    let locationManager = CLLocationManager()
    var tapRecognizer: UITapGestureRecognizer? = nil
    
    override func viewDidLoad() {
        activityIndicator = UIActivityIndicatorView(frame: view.frame)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
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
        startActivityIndicator()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    @IBAction func findOnTheMapTouchUp(sender: AnyObject) {
        if locationText.text.isEmpty {
            let error = NSError(domain: "location Text", code: 8, userInfo: [NSLocalizedDescriptionKey:"Text field is empty"])
            self.displayError(error)
        }else{
            startActivityIndicator()
            getLocation(locationText.text)
        }
    }
    
   
    @IBAction func cancelTouchUp(sender: AnyObject) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func getLocation(locationText : String){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(locationText){(placemarks,error) in
            if error != nil {
                let error = NSError(domain: "geoCoder", code: 8, userInfo: [NSLocalizedDescriptionKey:"Problem with the data received from geocoder"])
                self.displayError(error)
            }else {
                if placemarks?.count > 0 {
                    let placemark = placemarks![0]                    
                    self.sentLocationToDetailMap(placemark,currentLocation: false)
                }
            }
        }
    }
    
    func displayError(error: NSError?) {
        let alertVC = Alert(controller: self, message: error?.localizedDescription)
        alertVC.present()
    }
    
    //Still have problem it request few times not only one
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(manager.location!){(placemarks, error) in
            if let error = error {
                self.displayError(error)
                return
            }
            
            if placemarks!.count > 0 {
                let placemark = placemarks![0] as CLPlacemark
                self.locationManager.stopUpdatingLocation()
                self.sentLocationToDetailMap(placemark, currentLocation: true)
            } else {
                let error = NSError(domain: "geoCoder", code: 8, userInfo: [NSLocalizedDescriptionKey:"Problem with the data received from geocoder"])
                self.displayError(error)
            }
        }
    }
    
    
    
    func sentLocationToDetailMap(placeMark : CLPlacemark, currentLocation : Bool){
        let location = placeMark.location?.coordinate
        let detailLocationVC = self.storyboard?.instantiateViewControllerWithIdentifier("DetaiLocationViewController") as! DetailLocationViewController
        detailLocationVC.location = location
        if currentLocation {
            detailLocationVC.searchString = placeMark.locality
        }else{
            detailLocationVC.searchString = self.locationText.text
        }
        self.navigationController?.pushViewController(detailLocationVC, animated: true)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        displayError(error)
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

    func startActivityIndicator(){
        for view in self.view.subviews{
            view.alpha = 0.3
        }
        self.view.addSubview(activityIndicator)
        self.view.bringSubviewToFront(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator(){
        for view in self.view.subviews{
            view.alpha = 1
        }
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
    }
    
}
