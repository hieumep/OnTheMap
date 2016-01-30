//
//  DBClient.swift
//  On The Map
//
//  Created by Hieu Vo on 1/22/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//
import Foundation
import UIKit

class DBClient : NSObject{
    
    var session : NSURLSession
    var myInfo = StudentObject()
    
    override init() {
        session = NSURLSession.sharedSession()
    }    
    
    func dataTaskWithRequest(request:NSMutableURLRequest, subSetData:Bool, completionHandler: (result: AnyObject!, error: NSError?) -> Void) -> NSURLSessionDataTask {
               /* 4. Make the request */
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
           
            /* GUARD: Was there an error? */
            guard (error == nil) else {
                print("There was an error with your request: \(error)")
                completionHandler(result: nil,error: error)
                return
            }
            
            /* GUARD: Did we get a successful 2XX response? */
            guard let statusCode = (response as? NSHTTPURLResponse)?.statusCode where statusCode >= 200 && statusCode <= 299 else {
                if let response = response as? NSHTTPURLResponse {
                    if response.statusCode == 403 {
                        let errorString = [NSLocalizedDescriptionKey:"Invalid Email or Passowrd"]
                        completionHandler(result: nil, error:NSError(domain: "Connect sever", code: 403, userInfo: errorString))
                        return
                    }
                    print("Your request returned an invalid response! Status code: \(response.statusCode)!")
                } else if let response = response {
                    print("Your request returned an invalid response! Response: \(response)!")
                } else {
                    print("Your request returned an invalid response!")
                }
                completionHandler(result: nil, error: NSError(domain: "fail response", code: 7, userInfo: [NSLocalizedDescriptionKey: "Your request returned an invalid response"]))
                return
            }
            
            /* GUARD: Was there any data returned? */
            guard let data = data else {
                print("No data was returned by the request!")
                return
            }
            if subSetData {
                let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
                DBClient.parseJSONWithCompletionHandler(newData, completionHandler: completionHandler)
            }else {
                DBClient.parseJSONWithCompletionHandler(data, completionHandler: completionHandler)
            }
            
            
        }
        
        /* 7. Start the request */
        task.resume()
        
        return task
    }
    
    /* helper function : check JSON object return */
    class func parseJSONWithCompletionHandler(data: NSData, completionHandler: (result: AnyObject!, error: NSError?) -> Void) {
        
        var parsedResult: AnyObject!
        do {
            parsedResult = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
        } catch {
            let userInfo = [NSLocalizedDescriptionKey : "Could not parse the data as JSON: '\(data)'"]
            completionHandler(result: nil, error: NSError(domain: "parseJSONWithCompletionHandler", code: 1, userInfo: userInfo))
        }
        
        completionHandler(result: parsedResult, error: nil)
    }
    
    /* Helper function: Given a dictionary of parameters, convert to a string for a url */
    class func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }
    
    class func sharedInstance() -> DBClient{
        struct Singleton {
            static var sharedInstance = DBClient()
        }
        return Singleton.sharedInstance
    }
    
}
