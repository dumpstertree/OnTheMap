//
//  ParseClient.swift
//  OnTheMap
//
//  Created by Zachary Collins on 1/21/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import Foundation
class UdacityClient{

    // Requests
    static public func createLoginRequest(  userName: String, password: String ) -> URLRequest{
        var request = URLRequest(url: NSURL(string: "https://www.udacity.com/api/session")! as URL )
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(userName)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)
        return request
    }
    static public func createAccountRequest() -> URLRequest {
        let url = URL(string: "\(Constants.UdacityAPI.UserDataMethod)\(Constants.UdacityAPI.LoginValues.AccountKeyValue)")! as URL
        let request = NSMutableURLRequest(url: url)
        return request as URLRequest
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
            
            // Cut first 5 bits
            let newData = self.removeBits(bits: 5, data: data)
            guard let parsedResult = JsonParser.parseAsDictionary(data: newData) else {
                return completionHandlerForGET( nil, nil)
            }
            
            return completionHandlerForGET( parsedResult as AnyObject?, nil)
        }
        
        task.resume()
        return task
    }
    
    // Helpers
    static private func removeBits( bits: Int, data: Data ) -> Data {
        return data.subdata(in: bits..<(data.count) as Range)
    }
}
