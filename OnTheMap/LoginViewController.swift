//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Zachary Collins on 10/30/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var LoginButton: UIButton!

    // Overide
    override func viewWillAppear(_ animated: Bool) {
        unlockUI()
    }
    
    // Actions
    @IBAction func Login(_ sender: AnyObject) {
        
        // Lock UI
        lockUI()
        
        // Task
        let request = MakeLoginRequest()
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
           
            // Basic ERROR catch
            if error != nil {
                AlertDisplay.display( alertText: nil , controller: self)
                self.DenyLogin()
                return
            }
            
            // Remove first 5 bits
            let newData = data?.subdata(in: 5..<(data!.count) as Range)
            if let parsedResult = JsonParser.parseAsDictionary(data: newData!) {
                
                // Display ERROR to user
                if parsedResult["status"] != nil {
                    AlertDisplay.display( alertText: parsedResult["error"] as? String, controller: self)
                    self.DenyLogin()
                    return
                }
                
                // Store Session Values
                if let session = parsedResult[Constants.UdacityAPI.LoginKeys.SessionKey] as? [String:AnyObject] {
                    Constants.UdacityAPI.LoginValues.ExperationValue = session[Constants.UdacityAPI.LoginKeys.ExperationKey] as! String
                    Constants.UdacityAPI.LoginValues.IDValue = session[Constants.UdacityAPI.LoginKeys.IDKey] as! String
                    self.AcceptLogin()
                    return
                }
            }
        }
        task.resume()
    }
    
    
    func MakeLoginRequest() -> URLRequest {
        let request = NSMutableURLRequest(url: Constants.UdacityAPI.SessionURL)
        request.httpMethod = Constants.UdacityAPI.MethodType
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = "{\"udacity\": {\"username\": \"\(UsernameTextField.text!)\", \"password\": \"\(PasswordTextField.text!)\"}}".data(using: String.Encoding.utf8)
        
        return request as URLRequest
    }
    func DenyLogin(){
        unlockUI()
    }
    func AcceptLogin(){
        DispatchQueue.main.async() { () -> Void in
            self.performSegue(withIdentifier: "Login", sender: nil)
        }
    }
  
    func lockUI(){
        UsernameTextField.isEnabled = false
        PasswordTextField.isEnabled = false
        LoginButton.isEnabled = false
    }
    func unlockUI(){
        UsernameTextField.isEnabled = true
        PasswordTextField.isEnabled = true
        LoginButton.isEnabled = true
    }
}
