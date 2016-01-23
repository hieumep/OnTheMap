//
//  MapViewController.swift
//  On The Map
//
//  Created by Hieu Vo on 1/23/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import Foundation
import MapKit

class MapViewController : UIViewController, MKMapViewDelegate{
    @IBOutlet weak var mapView: MKMapView!
   
    override func viewDidLoad() {
        
    }
    
    @IBAction func logoutTouchUp(sender: AnyObject) {
        if FBSDKAccessToken.currentAccessToken() != nil {
            let loginFB = FBSDKLoginManager()
            loginFB.logOut()
            self.dismissViewControllerAnimated(true, completion: nil)
        }else{
            DBClient.sharedInstance().logoutUdacity(self){(success,error) in
                if success {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }else{
                    print(error)
                }
            }
        }
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }}