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
            displayError("Must Enter a Location")
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
        stopActivityIndicator()
    }
    
    //Still have problem it request few times not only one
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(manager.location!){(placemarks, error) in
            if let error = error {
                self.displayError(error.localizedDescription)
                return
            }
            
            if placemarks!.count > 0 {
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
