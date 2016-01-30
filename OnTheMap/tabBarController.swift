//
//  tabBarController.swift
//  On The Map
//
//  Created by Hieu Vo on 1/28/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import UIKit

class tabBarController : UITabBarController{
    
    override func viewWillAppear(animated: Bool) {
        
    }
    
    
    override func viewDidLoad() {
        loadStudentObjects()
    }
    
    func loadStudentObjects (){
        DBClient.sharedInstance().getListStudent(){(success,error) in
            if !success{
                self.displayError(error)
            }else{
                
            }
        }
    }
    
    func displayError(error: NSError?) {
        dispatch_async(dispatch_get_main_queue(), {
            let alertVC = UIAlertController(title:"", message: error?.localizedDescription, preferredStyle: .Alert)
            let dismissAction = UIAlertAction(title: "Dismiss", style: .Cancel, handler : nil)
            alertVC.addAction(dismissAction)
            self.presentViewController(alertVC, animated: true, completion: nil)
        })
    }


}
