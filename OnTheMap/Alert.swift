//
//  Alert.swift
//  On The Map
//
//  Created by Hieu Vo on 1/30/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import Foundation

// Learn this ideas from other student
struct Alert {
    
    let alertController: UIAlertController
    let presentingController: UIViewController
    
    init(controller: UIViewController, message: String?) {
        
        alertController = UIAlertController(title: "", message: message, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Dismiss", style: .Cancel, handler: nil)
        alertController.addAction(action)
        
        presentingController = controller
    }
    
    func present() {
        dispatch_async(dispatch_get_main_queue()) {
            self.presentingController.presentViewController(self.alertController, animated: true, completion: nil)
        }
    }
}