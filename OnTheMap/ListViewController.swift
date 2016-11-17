//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Zachary Collins on 10/31/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import Foundation
import UIKit

class ListViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource  {

    // Table View Delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) 
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let data = appDelegate.retrieveData()[indexPath.item]
        
        guard let firstName = data["firstName"] as? String else{
            return cell
        }
        guard let lastName = data["lastName"] as? String else{
            return cell
        }
        guard let postedUrl = data["mediaURL"] as? String else{
            return cell
        }
        
        print("pass")
        cell.textLabel?.text = "\(firstName) \(lastName)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.retrieveData().count
    }
}
