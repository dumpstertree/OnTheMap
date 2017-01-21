//
//  URLEnterViewController.swift
//  OnTheMap
//
//  Created by Zachary Collins on 10/30/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//


import UIKit
import MapKit

class URLEnterViewController: UIViewController, MKMapViewDelegate {
    
    // External Refrence
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let session = URLSession.shared
    
    // Outlets
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    // Instance Variables
    var enteredLocation: CLLocation!
    var enteredLocationSearchTerm: String!
    var textFieldDelegate = LocationTextDelegate()
    
    // Override
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        urlTextField.delegate = textFieldDelegate
        
        zoomCamera()
        createPin()
    }
    
    // Actions
    @IBAction func Submit(_ sender: AnyObject) {
        
        // Valid URL
        if checkIfValidURL(urlString: urlTextField.text! ){
            
            var request: NSMutableURLRequest!
            if appDelegate.alreadyPosted{
                request = createRequest(methodType: "PUT", method: "https://parse.udacity.com/parse/classes/StudentLocation/"+Constants.UdacityAPI.LoginValues.AccountKeyValue)
            }
            else{
                request = createRequest(methodType: "PUT", method: "https://parse.udacity.com/parse/classes/StudentLocation/"+Constants.UdacityAPI.LoginValues.AccountKeyValue)
                //request = createRequest(methodType: "POST", method: "https://parse.udacity.com/parse/classes/StudentLocation")
            }
            
            let task = session.dataTask(with: request as URLRequest) { data, response, error in
                if self.checkForErrors(error: error){
                    return
                }
                print(NSString(data: data!, encoding: String.Encoding.utf8.rawValue)!)
                print(response)
                self.appDelegate.alreadyPosted = true
                self.performSegue(withIdentifier: "unwindToMainView", sender: self)
            }
            task.resume()
        }
            
            // Invalid URL
        else{
            AlertDisplay.display(alertErrorType: .UserInvalidURL, controller: self)
        }
    }
    
    // Helper
    private func createRequest( methodType: String, method: String ) -> NSMutableURLRequest {
        print(method)
        let request = NSMutableURLRequest(url: URL(string: method)!)
        request.httpMethod = methodType
        request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json",                         forHTTPHeaderField: "Content-Type")
        
        let uniqueKey = Constants.UdacityAPI.LoginValues.AccountKeyValue
        let firstName = Constants.UdacityAPI.AccountValues.FirstNameValue
        let lastName  = Constants.UdacityAPI.AccountValues.LastNameValue
        let mapString = enteredLocationSearchTerm!
        let mediaURL  = urlTextField.text!
        let latitude  = enteredLocation.coordinate.latitude
        let longitude = enteredLocation.coordinate.longitude
        
        request.httpBody = "{\"uniqueKey\": \"\(uniqueKey)\", \"firstName\": \"\(firstName)\" , \"lastName\": \"\(lastName)\",\"mapString\": \"\(mapString)\", \"mediaURL\": \"\(mediaURL)\",\"latitude\": \(latitude), \"longitude\": \(longitude)}".data(using: String.Encoding.utf8)
        
        return request
    }
    private func zoomCamera(){
        
        // Create Region
        let centerCoordinate = CLLocationCoordinate2DMake(enteredLocation.coordinate.latitude, enteredLocation.coordinate.longitude)
        let coordinateSpan = MKCoordinateSpanMake(20, 20)
        let viewRegion = MKCoordinateRegionMake(centerCoordinate, coordinateSpan)
        
        // Zoom Camera
        mapView.setRegion(viewRegion, animated: false)
    }
    private func createPin(){
        
        // Create Pin
        let dropPin = MKPointAnnotation()
        
        // Place at postion
        dropPin.coordinate = CLLocationCoordinate2DMake(enteredLocation.coordinate.latitude, enteredLocation.coordinate.longitude)
        
        // Add title
        dropPin.title = enteredLocationSearchTerm
        
        // Add Pin to map
        mapView.addAnnotation(dropPin)
    }
    private func checkIfValidURL(urlString: String) -> Bool {
        
        // create NSURL instance
        if let url = URL(string: urlString) {
            // check if your application can open the NSURL instance
            return UIApplication.shared.canOpenURL(url)
        }
        
        return false
    }
    private func checkForErrors( error: Error? ) -> Bool {
        
        if error != nil {
            AlertDisplay.display( alertText: error!.localizedDescription , controller: self)
            return true
        }
        
        return false
    }
}
