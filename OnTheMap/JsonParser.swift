//
//  JsonParser.swift
//  OnTheMap
//
//  Created by Zachary Collins on 10/30/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import Foundation

class JsonParser{
    
    static func parseAsDictionary( data: Data) ->  [String:AnyObject]?{
        
        let parsedResult: [String:AnyObject]!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String:AnyObject]
        }
        catch {
            return nil
        }
        
        return parsedResult
    }
    
    static func parseArray( data: Data) -> [AnyObject]?{
        
        let parsedResult: [AnyObject]!
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [AnyObject]
        }
        catch {
            return nil
        }
        
        return parsedResult
    }
}
