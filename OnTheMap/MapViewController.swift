//
//  MapViewController.swift
//  On The Map
//
//  Created by Hieu Vo on 1/23/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import UIKit
import MapKit

class MapViewController : UIViewController, Refeshable {
    
   
    var mapViewDelegate = MapViewDelegate()
    var activityIndicator = UIActivityIndicatorView()
    
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
        self.tabBarController?.tabBar.hidden = false
        activityIndicator = UIActivityIndicatorView(frame: view.frame)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        mapView.delegate = mapViewDelegate      
        loadStudentObjects()
    }
    
    
    func refesh(){
        let annotationsToRemove = mapView.annotations.filter { $0 !== mapView.userLocation }
        mapView.removeAnnotations( annotationsToRemove )
        loadStudentObjects()
    }    
    
    func displayError(error: NSError?) {
        stopActivityIndicator()
        let alertVC = Alert(controller: self, message: error?.localizedDescription)
        alertVC.present()        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // add Pin annotation on the map
    func loadPinOnMap(){
        var index  = 0
        var annotations = [MKPointAnnotation]()
        for studentObject in DBStudent.sharedInstance().studentObjects {
            
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
            index += 1
        }
        
        // When the array is complete, we add the annotations to the map.
        self.mapView.addAnnotations(annotations)
        stopActivityIndicator()        
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
    
    func loadStudentObjects (){
        startActivityIndicator()
        DBClient.sharedInstance().getListStudent(){(success,error) in
            if !success{
                self.displayError(error)
            }else{
                self.loadPinOnMap()
            }
        }
    }


}
