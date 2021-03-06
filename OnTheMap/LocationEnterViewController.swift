//
//  LocationEnterView.swift
//  OnTheMap
//
//  Created by Zachary Collins on 10/30/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import UIKit
import MapKit

class LocationEnterViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Instance Variables
    let locationTextDelegate = LocationTextDelegate()
    var enteredLocation: CLLocation!

    // Override
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = locationTextDelegate
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FindOnMap"{
            let nextView = segue.destination as! URLEnterViewController
            nextView.enteredLocation = enteredLocation
            nextView.enteredLocationSearchTerm = locationTextField.text!
        }
    }
    
    // Actions
    @IBAction func findOnMap(_ sender: AnyObject) {
       getAddressToCoordinates( address: locationTextField.text! )
    }
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToMainView", sender: self)
    }
    
    // Helpers
    private func getAddressToCoordinates(address: String) {
        
        activityIndicator.startAnimating();
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
           
            self.activityIndicator.stopAnimating()
            
            // Error Check
            if error != nil {
                AlertDisplay.display(alertErrorType: .InvalidLocation, controller: self)
                return
            }
            
            // Get first available location
            if placemarks!.count == 1 {
                guard let location = placemarks![0].location else {
                    return
                }
                
                // Move to next Scene
                self.segue( location: location)
            }
            
            else{
                AlertDisplay.display(alertErrorType: .TooManySimilarLocations, controller: self)
            }
        })
    }
    private func segue( location: CLLocation ){
        enteredLocation = location
        performSegue(withIdentifier: "FindOnMap", sender: nil)
    }
}
