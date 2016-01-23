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
        static let userData = "users/{id}"
    }
    
    struct JSONBody {
        static let Udacity = "udacity"
        static let Username = "username"
        static let Password = "password"
        static let FacebookMoblie = "facebook_mobile"
        static let accessToken = "access_token"
    }
    
    struct JSONResponseKey {
        static let Account = "account"
        static let userID = "key"
    }
}
