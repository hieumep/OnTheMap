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
    func authenticateWithViewController(hostViewController: UIViewController, infoUser : [String:String], completionHandler: (success: Bool, error: NSError?) -> Void) {
        getSessionUdacity(infoUser) {(success,error) in
            if success {
                self.getUserData(self.myInfo.uniqueKey){(success, error) in
                    if success {
                        completionHandler(success: true, error: nil)
                    }else{
                        completionHandler(success: false, error: error)
                    }
                }
            }else{
                completionHandler(success: false, error: error)
            }
        }
        
    }
    
    // authenticate with Facebook Login 
    func authenticateWithFacebook(hostViewController:UIViewController, accessToken : String, completionHandler : (success:Bool, error:NSError?) -> Void){
        getUserIDViaFacebookLogin(accessToken){(success,error) in
            if success {
                self.getUserData(self.myInfo.uniqueKey){(success, error) in
                    if success {
                        completionHandler(success: true, error: nil)
                    }else{
                        completionHandler(success: false, error: error)
                    }
                }
            }else{
                completionHandler(success: false, error: error)
            }
        }
    }
    
    //get userId via login Udacity
    func getSessionUdacity(infoUser:[String:String],completionHandler : (success : Bool, error : NSError?) -> Void){
        let urlString  = DBClient.Constants.baseURL + DBClient.Methods.session
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let httpBody = "{\"\(DBClient.JSONBody.Udacity)\": {\"\(DBClient.JSONBody.Username)\": \"\(infoUser[DBClient.JSONBody.Username]!)\", \"\(DBClient.JSONBody.Password)\": \"\(infoUser[DBClient.JSONBody.Password]!)\"}}"
      //  request.HTTPBody = "{\"udacity\": {\"username\": \"voquanghieu@gmail.com\", \"password\": \"vqhieu1984\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = httpBody.dataUsingEncoding(NSUTF8StringEncoding)
        self.dataTaskWithRequest(request,subSetData: true){(JSONResult, error) in
            if let error = error {
                print(error.localizedDescription)
                completionHandler(success: false, error: error)
            }else{
                guard let account = JSONResult[DBClient.JSONResponseKey.Account] as? [String:NSObject] else {
                    completionHandler(success: false, error: error)
                    return
                }
                if let userID = account[DBClient.JSONResponseKey.userID] as? String {
                      self.myInfo.uniqueKey = userID
                    completionHandler(success: true, error: nil)
                }
            }
        }
    }
    
    //get userID via login facebook
    func getUserIDViaFacebookLogin(accessToken : String!, completionHandler : (success:Bool, error: NSError?) -> Void){
        let urlString  = DBClient.Constants.baseURL + DBClient.Methods.session
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = "{\"facebook_mobile\": {\"access_token\": \"\(accessToken)\"}}".dataUsingEncoding(NSUTF8StringEncoding)
        self.dataTaskWithRequest(request,subSetData: true){(JSONResult, error) in
            if let error = error {
                print(error.localizedDescription)
                completionHandler(success: false, error: error)
            }else{
                guard let account = JSONResult[DBClient.JSONResponseKey.Account] as? [String:NSObject] else {
                    completionHandler(success: false, error: error)
                    return
                }
                if let userID = account[DBClient.JSONResponseKey.userID] as? String {
                    self.myInfo.uniqueKey = userID
                    completionHandler(success: true, error: nil)
                }
            }
        }
    }
    
    //Get user information from Udacity
    func getUserData(userID : String, completionHandler : (success:Bool, error : NSError?) -> Void) {
        let urlString = DBClient.Constants.baseURL + DBClient.Methods.userData + "\(userID)"
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        self.dataTaskWithRequest(request, subSetData: true){(JSONResult,error) in
            if let error = error {
                print(error.localizedDescription)
                completionHandler(success: false, error: error)
            }else{
                guard let account = JSONResult[DBClient.JSONResponseKey.user] as? [String:NSObject] else {
                    completionHandler(success: false, error: error)
                    return
                }
                if let firstName = account[DBClient.JSONResponseKey.firstName] as? String {
                    self.myInfo.firstName = firstName
                    if let lastName = account[DBClient.JSONResponseKey.lastName] as? String{
                        self.myInfo.lastName = lastName
                        completionHandler(success: true, error: nil)
                    }
                }
            }
        }
    }    
    
    func logoutUdacity(hostViewController : UIViewController, completionHandler : (success:Bool, error:NSError?) -> Void){
        let urlString  = DBClient.Constants.baseURL + DBClient.Methods.session
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        self.dataTaskWithRequest(request,subSetData: true){(JSONResult, error) in
            if let error = error {
                print(error)
                completionHandler(success: false,error: error)
            }else{
                completionHandler(success: true, error: nil)
            }
        }
    }
}
