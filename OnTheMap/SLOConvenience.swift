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
    func getListStudentObjects (completionHandler : (Result:[StudentObject]?, error:NSError?) -> Void){
        let arguments = [
            DBClient.Arguments.limit : 100,
            DBClient.Arguments.order : "-updateAt"
        ]
        let urlString = DBClient.Methods.studentMethods + DBClient.escapedParameters(arguments)
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        self.dataTaskWithRequest(request, subSetData: false){(JSResult,error) in
            if let error = error {
                print(error)
                completionHandler(Result: nil, error: error)
            }else{
                if let result = JSResult[DBClient.JSONResponseKey.results] as? [[String:AnyObject]] {
                    let studentObjects = StudentObject.SOFromResults(result)
                    completionHandler(Result: studentObjects, error: nil)
                }else{
                    completionHandler(Result: nil, error: NSError(domain: "get Student Objects", code: 1, userInfo: [NSLocalizedDescriptionKey: "Can't get list of students"]))
                }
            }
        }
    }
}
