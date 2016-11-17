//
//  CustomPinDetail.swift
//  OnTheMap
//
//  Created by Zachary Collins on 11/17/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import Foundation
import MapKit

class CustomPin : NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var name: String
    var location: String
    var url: URL
    
    init(coordinate: CLLocationCoordinate2D, name: String, location: String, url: URL) {
        self.coordinate = coordinate
        self.name = name
        self.location = location
        self.url = url
    }
}
