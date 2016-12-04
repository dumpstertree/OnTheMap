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
    
    // Outlets
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var mapView: MKMapView!
    
    // Passed Variables
    var enteredLocation: CLLocation!
    var enteredLocationSearchTerm: String!
    
    // Runtime Variables
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
        
        // Submit and return to TabView
        if checkIfValidURL(urlString: urlTextField.text! ){
           // Unwind To MapView
            performSegue(withIdentifier: "unwindToMainView", sender: self)
        }
        
        // Invalid URL
        else{
            // Display ERROR
            AlertDisplay.display(alertErrorType: .UserInvalidURL, controller: self)
        }
    }
    
    
    func zoomCamera(){
        
        // Create Region
        let centerCoordinate = CLLocationCoordinate2DMake(enteredLocation.coordinate.latitude, enteredLocation.coordinate.longitude)
        let coordinateSpan = MKCoordinateSpanMake(20, 20)
        let viewRegion = MKCoordinateRegionMake(centerCoordinate, coordinateSpan)
        
        // Zoom Camera
        mapView.setRegion(viewRegion, animated: false)
    }
    func createPin(){
        
        // Create Pin
        let dropPin = MKPointAnnotation()
        
        // Place at postion
        dropPin.coordinate = CLLocationCoordinate2DMake(enteredLocation.coordinate.latitude, enteredLocation.coordinate.longitude)
       
        // Add title
        dropPin.title = enteredLocationSearchTerm
        
        // Add Pin to map
        mapView.addAnnotation(dropPin)
    }
    func checkIfValidURL(urlString: String) -> Bool {
       
        // create NSURL instance
        if let url = URL(string: urlString) {
            // check if your application can open the NSURL instance
            return UIApplication.shared.canOpenURL(url)
        }
        
        return false
    }
}
