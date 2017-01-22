//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Zachary Collins on 10/31/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import Foundation
import UIKit

class ListViewController:  UIViewController {

    // Instance Variables
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    // Outlets
    @IBOutlet weak var tableView: UITableView!

    // Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ShowWebView"{
            
            let nextView = segue.destination as! WebViewController
            guard let currentIndex = tableView.indexPathForSelectedRow else{
                return
            }
            guard let row = tableView.cellForRow(at: currentIndex) else{
                return
            }
            guard let url = NSURL(string: row.detailTextLabel!.text! ) as? URL else{
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
    
    // Helper Functions
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
    private func refreshData(){
        
        ParseClient.taskForGETMethod(request: ParseClient.createLoginRequest(), completionHandlerForGET: { data, error in
            
            // Basic Error
            if self.checkForErrors( error: error ){
                return
            }
            
            // Store Data
            self.saveData(dictionary: data as! [String: AnyObject])
        
            // Reload
            self.tableView.reloadData()
            
        })
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

// Table View Extension
extension ListViewController:  UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let data = appDelegate.retrieveData()
        
        let firstName = data[indexPath.row].firstName
        let lastName = data[indexPath.row].lastName
        let mediaURL = data[indexPath.row].mediaURL
        
        cell.textLabel?.text = "\(firstName) \(lastName)"
        cell.detailTextLabel?.text = mediaURL
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.retrieveData().count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if checkURLValidity( string: (tableView.cellForRow(at: indexPath)?.detailTextLabel?.text)! ){
            performSegue(withIdentifier: "ShowWebView", sender: nil)
        }
        else{
            AlertDisplay.display(alertErrorType: .URLNotValid, controller: self)
        }
    }
}
