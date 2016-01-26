//
//  DBConstant.swift
//  On The Map
//
//  Created by Hieu Vo on 1/22/16.
//  Copyright © 2016 Hieu Vo. All rights reserved.
//

extension DBClient{
    struct Constants {
        static let baseURL = "https://www.udacity.com/api/"
    }
    
    struct Methods{
        static let session = "session"
        static let userData = "users/"
        static let studentMethods = "https://api.parse.com/1/classes/StudentLocation"
    }
    
    struct JSONBody {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        static let FacebookMoblie = "facebook_mobile"
        static let accessToken = "access_token"
    }
    
    struct Arguments{
        static let limit = "limit"
        static let order = "order"
    }
    
    struct StudentObjectkeys {
        static let objectId = "objectID"
        static let uniqueKey = "uniqueKey"
        static let firstName = "firstName"
        static let lastName = "lastName"
        static let mapString = "mapString"
        static let mediaURL = "mediaURL"
        static let latitude = "latitude"
        static let longitude = "longitude"
    }
    
    struct JSONResponseKey {
        static let Account = "account"
        static let userID = "key"
        static let results = "results"
        static let firstName = "first_name"
        static let lastName = "last_name"
        static let objectId = "objectId"
        static let user = "user"
    }
}
