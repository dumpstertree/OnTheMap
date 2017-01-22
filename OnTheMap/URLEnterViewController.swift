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
            
            let request = ParseClient.createLocationRequest(mapString: enteredLocationSearchTerm, mediaURL: urlTextField.text!, lat: enteredLocation.coordinate.latitude, lon: enteredLocation.coordinate.longitude)
            ParseClient.taskForPOSTMethod(request: request, completionHandlerForGET: { data, error in
                if self.checkForErrors(error: error){
                    return
                }
                self.performSegue(withIdentifier: "unwindToMainView", sender: self)
            })
        }
            
        // Invalid URL
        else{
            AlertDisplay.display(alertErrorType: .UserInvalidURL, controller: self)
        }
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToMainView", sender: self)
    }
    
    
    // Helper
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
