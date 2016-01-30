//
//  DetailLocationViewController.swift
//  On The Map
//
//  Created by Hieu Vo on 1/23/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import UIKit
import MapKit

class DetailLocationViewController : UIViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    
    var location : CLLocationCoordinate2D?
    var searchString : String?
    var tapRecognizer: UITapGestureRecognizer? = nil
    var textViewDelegate = TextViewDelegate()
    
    @IBOutlet weak var mediaURL: UITextView!
    
    var mapViewDelegate = MapViewDelegate()
    
    override func viewDidAppear(animated: Bool) {
        mapView.delegate = mapViewDelegate
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer!.numberOfTapsRequired = 1
        mediaURL.delegate = textViewDelegate
        addKeyboardDismissRecognizer()
        // add pin and zoom to location
        if location != nil {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location!
            mapView.addAnnotation(annotation)
            mapView.zoomEnabled = true
            //set zoom
            let span = MKCoordinateSpanMake(0.5, 0.5)
            let region = MKCoordinateRegionMake(location!, span)
            self.mapView.setRegion(region, animated: true)
            
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        removeKeyboardDismissRecognizer()
    }
    
    @IBAction func submitTouchUp(sender: AnyObject) {
        var moreInfo = StudentObject()
        moreInfo.mapString = searchString!
        moreInfo.latitude = (location?.latitude)! as Double
        moreInfo.longitude = (location?.longitude)! as Double
        if !mediaURL.text.isEmpty {
            moreInfo.mediaURL = mediaURL.text
            DBClient.sharedInstance().postStudentLocation(moreInfo){ (success,error) in
                if success {
                    dispatch_async(dispatch_get_main_queue(),{
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    })
                }else{
                    self.displayError(error)
                }
            }
        }else{
            let error = NSError(domain: "Detail Location View", code: 7, userInfo: [NSLocalizedDescriptionKey:"URL is invalid/empty"])
            displayError(error)
        }
    }
    
    @IBAction func cancelTouchUp(sender: AnyObject) {        
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func displayError(error: NSError?) {
        dispatch_async(dispatch_get_main_queue(), {
            let alertVC = UIAlertController(title:"", message: error?.localizedDescription, preferredStyle: .Alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler : nil)
            alertVC.addAction(dismissAction)
            self.presentViewController(alertVC, animated: true, completion: nil)
        })
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
