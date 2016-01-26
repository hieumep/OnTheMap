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
    
    @IBOutlet weak var mediaURL: UITextView!
    
    var mapViewDelegate = MapViewDelegate()
    
    override func viewDidAppear(animated: Bool) {
        mapView.delegate = mapViewDelegate
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
                }
            }
        }
    }
    
    @IBAction func cancelTouchUp(sender: AnyObject) {        
        navigationController?.popToRootViewControllerAnimated(true)
    }
}
