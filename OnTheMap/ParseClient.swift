//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Zachary Collins on 1/22/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import Foundation

class ParseClient {
    
    // Request
    static public func createLoginRequest() -> URLRequest {
        let request = NSMutableURLRequest(url: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100")! as URL)
        request.addValue(Constants.ParseAPI.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ParseAPI.RESTApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        return request as URLRequest
    }
    static public func createLocationRequest( mapString: String, mediaURL: String, lat:Double, lon: Double ) -> URLRequest {
        
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json",                         forHTTPHeaderField: "Content-Type")
        
        let uniqueKey = Constants.UdacityAPI.LoginValues.AccountKeyValue
        let firstName = Constants.UdacityAPI.AccountValues.FirstNameValue
        let lastName  = Constants.UdacityAPI.AccountValues.LastNameValue
        let mapString = mapString
        let mediaURL  = mediaURL
        let latitude  = lat
        let longitude = lon
        
        request.httpBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\" , \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: String.Encoding.utf8)
        
        return request
    }
    
    // Tasks
    static public func taskForGETMethod( request: URLRequest, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            // Check for Error
            guard error == nil else {
                completionHandlerForGET(nil, error as NSError?)
                return
            }
            
            // Unwrap Data
            guard let data = data else {
                completionHandlerForGET( nil, nil)
                return
            }
            
            print("-         -1")
            guard let parsedResult = JsonParser.parseAsDictionary(data: data) else {
                return completionHandlerForGET( nil, nil)
            }
            print("-         -2")
            
            return completionHandlerForGET( parsedResult as AnyObject?, nil)
        }
        
        task.resume()
        return task
    }
    static public func taskForPOSTMethod( request: URLRequest, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {

        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            // Check for Error
            guard error == nil else {
                completionHandlerForGET(nil, error as NSError?)
                return
            }
            
            // Unwrap Data
            guard let data = data else {
                completionHandlerForGET( nil, nil)
                return
            }
            
            guard let parsedResult = JsonParser.parseAsDictionary(data: data) else {
                return completionHandlerForGET( nil, nil)
            }
            
            return completionHandlerForGET( parsedResult as AnyObject?, nil)
        }
        
        task.resume()
        return task
    }
}
