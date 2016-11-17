//
//  NotificationDisplay.swift
//  OnTheMap
//
//  Created by Zachary Collins on 11/6/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import Foundation
import UIKit
class AlertDisplay {
    
    
    static func display( alertText: String?, controller: UIViewController ) {
    
         OperationQueue.main.addOperation {
            
            var alertController : UIAlertController!
            
            // Set alert Text
            if alertText == nil{
                alertController = UIAlertController(title: "", message: "Something went wrong." , preferredStyle: UIAlertControllerStyle.alert)
            }
            else{
                alertController = UIAlertController(title: "", message: alertText , preferredStyle: UIAlertControllerStyle.alert)
            }
            
            // Add Dismiss
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            // Display
            controller.present(alertController, animated: true, completion: nil)
        }
    }
    static func display( alertErrorType: AlertErrorTypes, controller: UIViewController ) {
        
        OperationQueue.main.addOperation {
            
            // Set alert Text
            let alertController = UIAlertController(title: "", message: alertErrorType.rawValue, preferredStyle: UIAlertControllerStyle.alert)
            
            // Add Dismiss
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
            
            // Display
            controller.present(alertController, animated: true, completion: nil)
        }
    }
}
