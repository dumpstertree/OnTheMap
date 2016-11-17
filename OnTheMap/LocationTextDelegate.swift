//
//  LocationTextDelegate.swift
//  OnTheMap
//
//  Created by Zachary Collins on 11/6/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import Foundation
import UIKit

class LocationTextDelegate: NSObject, UITextFieldDelegate {
    
    var firstTime = true
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if firstTime{
            textField.text = ""
            firstTime = false
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
