//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Zachary Collins on 10/30/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    //Instance Variables
    let session = URLSession.shared
    
    // Outlets
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var LoginButton: UIButton!

    // Overide
    override func viewWillAppear(_ animated: Bool) {
        lockUI(lock: false)
    }
    
    // Actions
    @IBAction func Login(_ sender: AnyObject) {
        
        lockUI(lock: true)
        
        // Login GET
        let _ = taskForGETMethod( request: makeLoginRequest(), completionHandlerForGET: { results, error in
            
            if self.checkForErrors(error: error) {
                self.login(login: false)
                return
            }
            
            guard let data = results as? [String:AnyObject] else{
                self.login(login: false)
                return
            }
            
            // Save Session Data
            if let sessionData = data[Constants.UdacityAPI.LoginKeys.SessionKey]{
                guard let experation = sessionData[Constants.UdacityAPI.LoginKeys.ExperationKey] as? String else{
                    return
                }
                guard let id = sessionData[Constants.UdacityAPI.LoginKeys.IDKey] as? String else{
                    return
                }
                Constants.UdacityAPI.LoginValues.ExperationValue = experation
                Constants.UdacityAPI.LoginValues.IDValue = id
            }
            else{
                self.login(login: false)
                return
            }
            
            // Save Account Data
            if let accountData = data[Constants.UdacityAPI.LoginKeys.AccountKey]{
                guard let key = accountData[Constants.UdacityAPI.LoginKeys.AccountKeyKey] as? String else{
                    return
                }
                guard let registered = accountData[Constants.UdacityAPI.LoginKeys.RegisteredKey] as? Bool else{
                    return
                }
                Constants.UdacityAPI.LoginValues.AccountKeyValue = key
                Constants.UdacityAPI.LoginValues.RegisteredValue = registered
            }
            else{
                self.login(login: false)
                return
            }
            
            print(data)
            // Account Data GET
            let _ = self.taskForGETMethod( request: self.makeAccountRequest(), completionHandlerForGET: { results, error in
                
                if self.checkForErrors(error: error) {
                    self.login(login: false)
                    return
                }
                
                guard let data = results as? [String:AnyObject] else{
                    return
                }
                
                // Save Account Data
                if let userData = data[Constants.UdacityAPI.AccountKeys.UserKey] {
                    guard let firstName = userData[Constants.UdacityAPI.AccountKeys.FirstNameKey] as? String else{
                        return
                    }
                    guard let lastName = userData[Constants.UdacityAPI.AccountKeys.LastNameKey] as? String else{
                        return
                    }
                    Constants.UdacityAPI.AccountValues.FirstNameValue = firstName
                    Constants.UdacityAPI.AccountValues.LastNameValue = lastName
                }
                else{
                    self.login(login: false)
                    return
                }
                
                print(data)
                
                self.login(login: true)
            })
        } )
    }
    
    // Helper
    private func taskForGETMethod( request: URLRequest, completionHandlerForGET: @escaping (_ result: AnyObject?, _ error: NSError?) -> Void) -> URLSessionDataTask {
        
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
    private func checkForErrors( error: Error? ) -> Bool {
       
        if error != nil {
            AlertDisplay.display( alertText: error!.localizedDescription , controller: self)
            return true
        }
        
        return false
    }
    private func removeBits( bits: Int, data: Data ) -> Data {
        return data.subdata(in: bits..<(data.count) as Range)
    }
    private func makeLoginRequest() -> URLRequest {
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.udacity.com/api/session")! as URL )
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(UsernameTextField.text!)\", \"password\": \"\(PasswordTextField.text!)\"}}".data(using: String.Encoding.utf8)
        return request as URLRequest
    }
    private func makeAccountRequest() -> URLRequest {
        let url = URL(string: "\(Constants.UdacityAPI.UserDataMethod)\(Constants.UdacityAPI.LoginValues.AccountKeyValue)")! as URL
        let request = NSMutableURLRequest(url: url)
        return request as URLRequest
    }
    private func lockUI( lock: Bool ){
        if lock{
            UsernameTextField.isEnabled = false
            PasswordTextField.isEnabled = false
            LoginButton.isEnabled       = false
        }
        else{
            UsernameTextField.isEnabled = true
            PasswordTextField.isEnabled = true
            LoginButton.isEnabled       = true
        }
    }
    private func login( login: Bool ){
        if login{
            DispatchQueue.main.async() { () -> Void in
                self.performSegue(withIdentifier: "Login", sender: nil)
            }
        }
        else{
            AlertDisplay.display(alertErrorType: AlertErrorTypes.InvalidLogin, controller: self)
        }
        
        lockUI(lock: false)
    }
}
