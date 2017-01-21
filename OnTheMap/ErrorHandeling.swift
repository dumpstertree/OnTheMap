//
//  ErrorHandeling.swift
//  OnTheMap
//
//  Created by Zachary Collins on 11/6/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//


enum AlertErrorTypes: String{
    case InvalidLogin = "The username or password you entered are incorrect"
    case InvalidLocation = "Location cannot be found, please try a new location."
    case TooManySimilarLocations = "Multiple results for the location you are searching for, try being more specific."
    case UserInvalidURL = "The url you entered is not a valid url, please try a valid url."
    case URLNotValid = "The URL trying to be loaded is not valid."
}
