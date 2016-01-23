//
//  DBConvenience.swift
//  On The Map
//
//  Created by Hieu Vo on 1/22/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import Foundation
import UIKit

extension DBClient{
    
    // authenticate with login {user, password}
    func authenticateWithViewController(hostViewController: UIViewController, infoUser : [String:String], completionHandler: (success: Bool, errorString: String?) -> Void) {
        getSessionUdacity(infoUser) {(success,error) in
            if success {
                print ("\(self.userID)")
                completionHandler(success: true, errorString: nil)
            }else{
                completionHandler(success: false, errorString: error)
            }
        }
        
    }
    
    // authenticate with Facebook Login 
    func authenticateWithFacebook(hostViewController:UIViewController, accessToken : String, completionHandler : (success:Bool, errorString:String?) -> Void){
        getUserIDViaFacebookLogin(accessToken){(success,error) in
            if success {
                print ("\(self.userID)")
                completionHandler(success: true, errorString: nil)
            }else{
                completionHandler(success: false, errorString: error)
            }
        }        
    }
    
    //get userId via login Udacity
    func getSessionUdacity(infoUser:[String:String],completionHandler : (success : Bool, error : String?) -> Void){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
      //  let httpBody = "{\"\(DBClient.JSONBody.Udacity)\": {\"\(DBClient.JSONBody.Username)\": \"\(infoUser[DBClient.JSONBody.Username]!)\", \"\(DBClient.JSONBody.Password)\": \"\(infoUser[DBClient.JSONBody.Password]!)\"}}"
        request.HTTPBody = "{\"udacity\": {\"username\": \"voquanghieu@gmail.com\", \"password\": \"vqhieu1984\"}}".dataUsingEncoding(NSUTF8StringEncoding)        
        //request.HTTPBody = httpBody.dataUsingEncoding(NSUTF8StringEncoding)
        self.dataTaskWithRequest(request){(JSONResult, error) in
            if let error = error {
                print(error)
                completionHandler(success: false, error: "Can't get session from Udacity")
            }else{
                guard let account = JSONResult[DBClient.JSONResponseKey.Account] as? [String:NSObject] else {
                    completionHandler(success: false, error: "Can't get Account form JSON data")
                    return
                }
                if let userID = account[DBClient.JSONResponseKey.userID] as? String {
                    self.userID = userID
                    completionHandler(success: true, error: nil)
                }
            }
        }
    }
    
    //get userID via login facebook
    func getUserIDViaFacebookLogin(accessToken : String!, completionHandler : (success:Bool, error:String?) -> Void){
        let request = NSMutableURLRequest(URL: NSURL(string: "https://www.udacity.com/api/session")!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //  let httpBody = "{\"\(DBClient.JSONBody.Udacity)\": {\"\(DBClient.JSONBody.Username)\": \"\(infoUser[DBClient.JSONBody.Username]!)\", \"\(DBClient.JSONBody.Password)\": \"\(infoUser[DBClient.JSONBody.Password]!)\"}}"
        request.HTTPBody = "{\"facebook_mobile\": {\"access_token\": \"\(accessToken)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        //request.HTTPBody = httpBody.dataUsingEncoding(NSUTF8StringEncoding)
        self.dataTaskWithRequest(request){(JSONResult, error) in
            if let error = error {
                print(error)
                completionHandler(success: false, error: "Can't get session from Udacity")
            }else{
                guard let account = JSONResult[DBClient.JSONResponseKey.Account] as? [String:NSObject] else {
                    completionHandler(success: false, error: "Can't get Account form JSON data")
                    return
                }
                if let userID = account[DBClient.JSONResponseKey.userID] as? String {
                    self.userID = userID
                    completionHandler(success: true, error: nil)
                }
            }
        }
    }
}