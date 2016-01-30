//
//  DBStudent.swift
//  On The Map
//
//  Created by Hieu Vo on 1/28/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

import Foundation
class DBStudent : NSObject { 
    
    var studentObjects = [StudentObject]()
    
    class func sharedInstance() -> DBStudent {
        struct Singleton {
            static var sharedInstance = DBStudent()
        }
        return Singleton.sharedInstance
    }
}
