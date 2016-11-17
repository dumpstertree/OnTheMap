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
    
    
    @IBOutlet weak var locationTextField: UITextField!
    let locationTextDelegate = LocationTextDelegate()
    var enteredLocation: CLLocation!

    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = locationTextDelegate
    }
    
    
    @IBAction func FindOnMap(_ sender: AnyObject) {
       getAddressToCoordinates( address: locationTextField.text! )
    }
    
    func getAddressToCoordinates(address: String) {
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address, completionHandler: { (placemarks, error) -> Void in
           
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
    
    func segue( location: CLLocation ){
        enteredLocation = location
        performSegue(withIdentifier: "FindOnMap", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FindOnMap"{
            let nextView = segue.destination as! URLEnterViewController
            nextView.enteredLocation = enteredLocation
            nextView.enteredLocationSearchTerm = locationTextField.text!
        }
    }
}
