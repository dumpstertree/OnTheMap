//
//  StudentInformation.swift
//  OnTheMap
//
//  Created by Zachary Collins on 1/15/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import Foundation
struct StudentInformation{
    
    let firstName: String
    let lastName: String
    let lon: Double
    let lat: Double
    let mediaURL: String
    
    init ( dictionary: [String:AnyObject]){
        
        if let firstName = dictionary["firstName"] as? String {
            self.firstName = firstName
        }
        else{
            self.firstName = ""
        }
       
        if let lastName = dictionary["lastName"] as? String {
             self.lastName = lastName
        }
        else{
             self.lastName = ""
        }
        
        if let longitude = dictionary["longitude"] as? Double {
             self.lon = longitude
        }
        else{
            self.lon = 0
        }
        
        if let latitude = dictionary["latitude"]  as? Double {
             self.lat = latitude
        }
        else{
            self.lat = 0
        }
        
        if let postedUrl = dictionary["mediaURL"] as? String {
            self.mediaURL = postedUrl
        }
        else{
            self.mediaURL = ""
        }
    }
}
