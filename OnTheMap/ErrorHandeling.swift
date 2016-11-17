//
//  ErrorHandeling.swift
//  OnTheMap
//
//  Created by Zachary Collins on 11/6/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//


enum AlertErrorTypes: String{
    case InvalidLocation = "Location cannot be found, please try a new location."
    case TooManySimilarLocations = "Multiple results for the location you are searching for, try being more specific."
    case NonValiURL = "The url you entered is not a valid url, please try a valid url."
}
