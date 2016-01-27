//
//  MapViewController.swift
//  On The Map
//
//  Created by Hieu Vo on 1/23/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import Foundation
import MapKit

class MapViewController : UIViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    
    var studentObjects = [StudentObject]()
    var mapViewDelegate = MapViewDelegate()
    
    override func viewDidLoad() {
        
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = false
        self.tabBarController?.tabBar.hidden = false
        mapView.delegate = mapViewDelegate
        loadPinOnMap()
    }
    
    @IBAction func ReloadPinOnTheMap(sender: AnyObject) {
        loadPinOnMap()
    }
    
    @IBAction func logoutTouchUp(sender: AnyObject) {
        if FBSDKAccessToken.currentAccessToken() != nil {
            removeFbData()
            self.dismissViewControllerAnimated(true, completion: nil)
        }else{
            DBClient.sharedInstance().logoutUdacity(self){(success,error) in
                if success {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }else{
                    self.displayError(error)
                }
            }
        }
    }
    
    //Log out with facebook login
    func removeFbData() {
        //Remove FB Data
        let fbManager = FBSDKLoginManager()
        fbManager.logOut()
        FBSDKAccessToken.setCurrentAccessToken(nil)
    }
    
    func displayError(error: NSError?) {
        dispatch_async(dispatch_get_main_queue(), {
            let alertVC = UIAlertController(title:"", message: error?.localizedDescription, preferredStyle: .Alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler : nil)
            alertVC.addAction(dismissAction)
            self.presentViewController(alertVC, animated: true, completion: nil)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // add Pin annotation on the map
    func loadPinOnMap(){
        DBClient.sharedInstance().getListStudentObjects(){(results,error) in
            if let studentObjects = results {
                self.studentObjects = studentObjects
                dispatch_async(dispatch_get_main_queue()){
                    var annotations = [MKPointAnnotation]()
                    
                    for studentObject in self.studentObjects {
                        
                        // Notice that the float values are being used to create CLLocationDegree values.
                        // This is a version of the Double type.
                        let lat = CLLocationDegrees(studentObject.latitude)
                        let long = CLLocationDegrees(studentObject.longitude)
                        
                        // The lat and long are used to create a CLLocationCoordinates2D instance.
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        
                        let first = studentObject.firstName
                        let last = studentObject.lastName
                        let mediaURL = studentObject.mediaURL
                        
                        // Here we create the annotation and set its coordiate, title, and subtitle properties
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = coordinate
                        annotation.title = "\(first) \(last)"
                        annotation.subtitle = mediaURL
                        
                        // Finally we place the annotation in an array of annotations.
                        annotations.append(annotation)
                    }
                    
                    // When the array is complete, we add the annotations to the map.
                    self.mapView.addAnnotations(annotations)
                }
            }else{
                self.displayError(error)
            }
        }
    } 
    
}