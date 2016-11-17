//
//  Constants.swift
//  OnTheMap
//
//  Created by Zachary Collins on 10/30/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import Foundation
struct Constants {
    
    struct UdacityAPI{
        
        static let SessionURL: URL =  NSURL(string: "https://www.udacity.com/api/session")! as URL
        static let Method: String = "https://www.udacity.com/api/session"
        static let MethodType: String = "POST"

        struct LoginKeys{
            static let MethodKey:   String = "udacity"
            static let UsernameKey: String = "username"
            static let PasswordKey: String = "password"
            
            static let SessionKey: String = "session"
            static let ExperationKey: String = "expiration"
            static let IDKey: String = "id"
            static let AccountKey: String = "account"
            static let AccountKeyKey: String = "key"
            static let RegisteredKey: String = "registered"
        }
        
        struct LoginValues{
            static var ExperationValue: String = ""
            static var IDValue: String = ""
            static var AccountKeyValue: Int = -1
            static var RegisteredValue: Int = -1
        }
    }
    
    struct ParseAPI{
        static let ParseApplicationID: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTApiKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
}
