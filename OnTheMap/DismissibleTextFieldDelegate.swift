//
//  DismissibleTextFieldDelegate.swift
//  OnTheMap
//
//  Created by Zachary Collins on 1/22/17.
//  Copyright © 2017 dumpstertree. All rights reserved.
//

import Foundation
import UIKit

class DismissibleTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
