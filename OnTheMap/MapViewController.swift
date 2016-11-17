//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Zachary Collins on 10/30/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    // Outlets
    @IBOutlet weak var MapView: MKMapView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var addLocationToolbarItem: UIBarButtonItem!
    @IBOutlet weak var refreshToolbarItem: UIBarButtonItem!
    @IBOutlet weak var logoutToolbarItem: UIBarButtonItem!
    @IBOutlet weak var tabToolbarItem: UITabBarItem!
    
    // Override
    override func viewDidLoad() {
        MapView.delegate = self
        RefreshData()
        super.viewDidLoad()
    }
    
    // Actions
    @IBAction func addLocationButtonClicked(_ sender: AnyObject) {
        performSegue(withIdentifier: "addLocation", sender: self)
    }
    @IBAction func refreshDataButtonClicked(_ sender: AnyObject) {
        RefreshData()
    }
    @IBAction func logoutButtonClicked(_ sender: AnyObject) {
        Constants.UdacityAPI.LoginValues.AccountKeyValue = -1
        Constants.UdacityAPI.LoginValues.IDValue = ""
        Constants.UdacityAPI.LoginValues.ExperationValue = ""
        Constants.UdacityAPI.LoginValues.RegisteredValue = -1
        dismiss(animated: true, completion: nil)
    }
    @IBAction func unwindToMainView(segue: UIStoryboardSegue){
        RefreshData()
    }
  
    // Mapkit Delegates
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "UserPosition"
        
        // Create new View
        if let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) {
            annotationView.annotation = annotation
            return annotationView
        }
            
            // Reuse View
        else{
            
            // Edit View
            let annotationView = MKPinAnnotationView(annotation:annotation, reuseIdentifier:identifier)
            annotationView.isEnabled = true
            annotationView.canShowCallout = true
            annotationView.animatesDrop = true
            
            // Apply Changes
            let btn = UIButton(type: .detailDisclosure)
            annotationView.rightCalloutAccessoryView = btn
            return annotationView
        }
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let url = view.annotation?.subtitle!
        performSegue(withIdentifier: "ShowWebView", sender: nil)
    }
    
    // Other
    func RefreshData(){
        
        // Display Load Visual
        displayLoadVisual(display: true)
        lockUI(locked: true)
        
        // Task
        let request = MakeLoginRequest()
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            
            // Basic Error
            if error != nil {
                AlertDisplay.display(alertText: nil, controller: self)
                self.displayLoadVisual(display: false)
                self.lockUI(locked: false)
                return
            }
            
            // Parse
            if let parsedResult = JsonParser.parseAsDictionary(data: data!) {
                if let results = parsedResult["results"] as? [[String:AnyObject]] {
                   
                    // Store Data
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.storeData( newData: results )
                    
                    // Create Pin for each
                    for each in results{
                        guard let longitude = each["longitude"] as? Double else {
                            continue
                        }
                        guard let latitude = each["latitude"]  as? Double else {
                            continue
                        }
                        guard let firstName = each["firstName"] as? String else{
                            continue
                        }
                        guard let lastname = each["lastName"] as? String else{
                            continue
                        }
                        guard let postedUrl = each["mediaURL"] as? String else{
                            continue
                        }
                        
                        self.CreatePin(latitude: latitude, longitude: longitude, pinTitle: "\(firstName) \(lastname)", postedUrl: postedUrl)
                    }
                }
                
                // Dismiss Load visual
                self.displayLoadVisual(display: false)
                self.lockUI(locked: false)
            }
        }
        task.resume()
    }
    func MakeLoginRequest() -> URLRequest {
        let request = NSMutableURLRequest(url: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100")! as URL)
        request.addValue(Constants.ParseAPI.ParseApplicationID, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Constants.ParseAPI.RESTApiKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        return request as URLRequest
    }
    func CreatePin( latitude: Double, longitude: Double, pinTitle: String, postedUrl: String ){
        
        // Convert to Coordinate2D
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        
        // Create Pin
        let dropPin = MKPointAnnotation()
        dropPin.coordinate = location
        dropPin.title = pinTitle
        dropPin.subtitle = postedUrl
        
        // Add Pin to map
        DispatchQueue.main.async() { () -> Void in
            self.MapView.addAnnotation(dropPin)
        }
    }
    
    func lockUI( locked: Bool ){
        DispatchQueue.main.async() { () -> Void in
            self.addLocationToolbarItem.isEnabled = !locked
            self.refreshToolbarItem.isEnabled = !locked
            self.logoutToolbarItem.isEnabled = !locked
            self.tabToolbarItem.isEnabled = !locked
        }
    }
    func displayLoadVisual( display: Bool ){
        DispatchQueue.main.async() { () -> Void in
            self.loadingView.isHidden = !display
            self.loadingLabel.isHidden = !display
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowWebView"{
            
            let nextView = segue.destination as! WebViewController
            guard let url = NSURL(string: MapView.selectedAnnotations[0].subtitle!! ) as? URL else{
                //Return ERROR
                return
            }
            
            nextView.targetUrl = url
        }
    }
    
}
