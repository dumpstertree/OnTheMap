//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Zachary Collins on 10/30/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    // Instance Variables
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
        super.viewDidLoad()
        refreshData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowWebView"{
            let nextView = segue.destination as! WebViewController
            guard let url = NSURL(string: MapView.selectedAnnotations[0].subtitle!! ) as? URL else{
                AlertDisplay.display(alertErrorType: AlertErrorTypes.URLNotValid, controller: self)
                return
            }
            
            nextView.targetUrl = url
        }
    }
    
    // Actions
    @IBAction func addLocationButtonClicked(_ sender: AnyObject) {
        performSegue(withIdentifier: "addLocation", sender: self)
    }
    @IBAction func refreshDataButtonClicked(_ sender: AnyObject) {
        refreshData()
    }
    @IBAction func logoutButtonClicked(_ sender: AnyObject) {
        Constants.logOut()
        dismiss(animated: true, completion: nil)
    }
    @IBAction func unwindToMainView(segue: UIStoryboardSegue){
        refreshData()
    }
    
    // Helper
    private func refreshData(){
        
        // Display Load Visual
        displayLoadVisual(display: true)
        lockUI(locked: true)
        
        ParseClient.taskForGETMethod(request: ParseClient.createLoginRequest(), completionHandlerForGET: { data, error in
            
            // Basic Error
            if self.checkForErrors( error: error ){
                return
            }
            
            // Store Data
            self.saveData(dictionary: data as! [String: AnyObject])
            
            // Remove Old Annotations
            self.MapView.removeAnnotations(self.MapView.annotations)
            
            // Create new Annotations
            self.createPins()
            
            // Dismiss Load visual
            self.displayLoadVisual(display: false)
            self.lockUI(locked: false)
            
        })
    }
    private func createPins( ){
        
        let data = self.appDelegate.retrieveData()
        for i in 0..<data.count{
            
            let firstName = data[i].firstName
            let lastName = data[i].lastName
            let lon = data[i].lon
            let lat = data[i].lat
            let mediaURL = data[i].mediaURL
            
            // Convert to Coordinate2D
            let location = CLLocationCoordinate2DMake(lat, lon)
            
            // Create Pin
            let dropPin = MKPointAnnotation()
            dropPin.coordinate = location
            dropPin.title = "\(firstName) \(lastName)"
            dropPin.subtitle = mediaURL
            
            // Add Pin to map
            DispatchQueue.main.async() { () -> Void in
                self.MapView.addAnnotation(dropPin)
            }
        }
    }
    private func lockUI( locked: Bool ){
        DispatchQueue.main.async() { () -> Void in
            self.addLocationToolbarItem.isEnabled = !locked
            self.refreshToolbarItem.isEnabled = !locked
            self.logoutToolbarItem.isEnabled = !locked
            self.tabToolbarItem.isEnabled = !locked
        }
    }
    private func displayLoadVisual( display: Bool ){
        DispatchQueue.main.async() { () -> Void in
            self.loadingView.isHidden = !display
            self.loadingLabel.isHidden = !display
        }
    }
    private func saveData( dictionary: [String:AnyObject]){
        
        var data: [StudentInformation] = []
        
        if let results = dictionary["results"] as? [[String:AnyObject]] {
            for each in results{
                let newStudentInfo = StudentInformation( dictionary: each )
                data.append(newStudentInfo)
            }
        }
        
        appDelegate.storeData(newData: data)
    }
    private func checkForErrors( error: Error? ) -> Bool {
        
        if error != nil {
            AlertDisplay.display( alertText: error!.localizedDescription , controller: self)
            return true
        }
        
        return false
    }
    func checkURLValidity( string: String) -> Bool{
        if let url = NSURL(string: string ) as? URL {
            return  UIApplication.shared.canOpenURL(url)
        }
        return false
    }
}

// Mapkit Delegates
extension MapViewController: MKMapViewDelegate{

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
        
        if checkURLValidity(string: (view.annotation?.subtitle!)!){
            performSegue(withIdentifier: "ShowWebView", sender: nil)
        }
        else{
            AlertDisplay.display(alertErrorType: .URLNotValid, controller: self)
        }
    }
}
