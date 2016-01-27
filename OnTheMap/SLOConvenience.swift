//
//  SLOConvenience.swift
//  On The Map
//
//  Created by Hieu Vo on 1/23/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import Foundation

// Student Locaction Objects Convenience
extension DBClient {
    //get list of student from Server
    func getListStudentObjects (completionHandler : (Result:[StudentObject]?, error:NSError?) -> Void){
        let arguments = [
            DBClient.Arguments.limit : 100,
          //  DBClient.Arguments.order : "-updateAt"
        ]
        let urlString = DBClient.Methods.studentMethods + DBClient.escapedParameters(arguments)
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        self.dataTaskWithRequest(request, subSetData: false){(JSONResult,error) in
            if let error = error {
                print(error)
                completionHandler(Result: nil, error: error)
            }else{
                if let result = JSONResult[DBClient.JSONResponseKey.results] as? [[String:AnyObject]] {
                    let studentObjects = StudentObject.SOFromResults(result)
                    completionHandler(Result: studentObjects, error: nil)
                }else{
                    completionHandler(Result: nil, error: NSError(domain: "get Student Objects", code: 1, userInfo: [NSLocalizedDescriptionKey: "Can't get list of students"]))
                }
            }
        }
    }
    
    // Post student information to Server
    func postStudentLocation ( moreInfo : StudentObject, completionHandler : (success : Bool, error: NSError?) -> Void){
        myInfo.mapString = moreInfo.mapString
        myInfo.mediaURL = moreInfo.mediaURL
        myInfo.latitude  = moreInfo.latitude
        myInfo.longitude = moreInfo.longitude
        let request = NSMutableURLRequest(URL: NSURL(string: DBClient.Methods.studentMethods)!)
        request.HTTPMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let httpBody = "{\"uniqueKey\": \"\(myInfo.uniqueKey)\", \"firstName\": \"\(myInfo.firstName)\", \"lastName\": \"\(myInfo.lastName)\",\"mapString\": \"\(myInfo.mapString)\", \"mediaURL\": \"\(myInfo.mediaURL)\",\"latitude\": \(myInfo.latitude), \"longitude\": \(myInfo.longitude)}"       
        request.HTTPBody = httpBody.dataUsingEncoding(NSUTF8StringEncoding)
        self.dataTaskWithRequest(request, subSetData: false){(JSONResult,error) in
            if let error = error {
                print(error)
                completionHandler(success: false, error: error)
            }else{
                if let objectId = JSONResult[DBClient.JSONResponseKey.objectId] as? String {
                    self.myInfo.objectId = objectId
                    completionHandler(success: true, error: nil)
                }
            }
        }
    }
}
