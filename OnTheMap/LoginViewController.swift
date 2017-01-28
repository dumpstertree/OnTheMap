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
    let usernameTextDelegate = DismissibleTextFieldDelegate()
    let passwordTextDelegate = DismissibleTextFieldDelegate()
    
    // Outlets
    @IBOutlet weak var UsernameTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    @IBOutlet weak var LoginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // Overide
    override func viewWillAppear(_ animated: Bool) {
        UsernameTextField.delegate = usernameTextDelegate
        PasswordTextField.delegate = passwordTextDelegate
        lockUI(lock: false)
    }
    
    // Actions
    @IBAction func login(_ sender: AnyObject) {
        
        lockUI(lock: true)
        
        // Login GET
        let request = UdacityClient.createLoginRequest(userName: UsernameTextField.text!, password: PasswordTextField.text!)
        let _ = UdacityClient.taskForGETMethod( request: request, completionHandlerForGET: { results, error in
            
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
            
            // Account Data GET
            let request = UdacityClient.createAccountRequest()
            let _ =  UdacityClient.taskForGETMethod( request: request, completionHandlerForGET: { results, error in
                
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
                
                self.login(login: true)
            })
        } )
    }
    
    // Helper
    private func checkForErrors( error: Error? ) -> Bool {
       
        if error != nil {
            AlertDisplay.display( alertText: error!.localizedDescription , controller: self)
            return true
        }
        
        return false
    }
    private func lockUI( lock: Bool ){
        if lock{
            activityIndicator.startAnimating()
            UsernameTextField.isEnabled = false
            PasswordTextField.isEnabled = false
            LoginButton.isEnabled       = false
        }
        else{
            activityIndicator.stopAnimating()
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
