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
        static let UserDataMethod: String = "https://www.udacity.com/api/users/"

        struct Methods{
            
        }
        
        struct MethodTypes{
            static let POSTMethodType: String = "POST"
            static let PUTMethodType: String = "PUT"
            static let GETMethodType: String = "GET"
        }
        
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
            static var AccountKeyValue: String = "-1"
            static var RegisteredValue: Bool = false
        }
        
        struct AccountKeys{
            static let UserKey: String = "user"
            static let FirstNameKey: String = "first_name"
            static let LastNameKey: String = "last_name"
        }
        
        struct AccountValues{
            static var FirstNameValue: String = ""
            static var LastNameValue: String = ""
        }
    }
    
    struct ParseAPI{
        
        struct MethodTypes{
            static let POSTMethodType: String = "POST"
            static let PUTMethodType: String = "PUT"
            static let GETMethodType: String = "GET"
        }
        
        static let ParseApplicationID: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RESTApiKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
    }
    
    static func logOut(){
        Constants.UdacityAPI.LoginValues.AccountKeyValue = "-1"
        Constants.UdacityAPI.LoginValues.IDValue = ""
        Constants.UdacityAPI.LoginValues.ExperationValue = ""
        Constants.UdacityAPI.LoginValues.RegisteredValue = false
        Constants.UdacityAPI.AccountValues.FirstNameValue = ""
        Constants.UdacityAPI.AccountValues.LastNameValue = ""
    }
}
