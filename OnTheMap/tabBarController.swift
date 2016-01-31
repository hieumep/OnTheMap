//
//  tabBarController.swift
//  On The Map
//
//  Created by Hieu Vo on 1/28/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import UIKit

class tabBarController : UITabBarController{
    // Learn this ideas from other student
    override func viewDidLoad() {
        let logoutButton = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logoutTouchUp")
        let newLocationButton = UIBarButtonItem(image: UIImage(named: "Pin"), style: .Plain, target: self, action: "newLocationTouchUp")
        let refeshButton = UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refeshTouchUp")
        let rightButtons = [refeshButton,newLocationButton]
        
        navigationItem.setLeftBarButtonItem(logoutButton, animated: true)
        navigationItem.setRightBarButtonItems(rightButtons, animated: true)
    }
    
    func logoutTouchUp() {
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
    
    func refeshTouchUp(){
        let activeTab = viewControllers![selectedIndex] as! Refeshable
        activeTab.refesh()
    }
    
    func newLocationTouchUp(){
        let informationPostVC = storyboard?.instantiateViewControllerWithIdentifier("informationPostingViewController") as! InformationPostingViewController
       /// presentViewController(detaiLocationVC, animated: true, completion: nil)
        navigationController?.pushViewController(informationPostVC, animated: true)
    }
}
