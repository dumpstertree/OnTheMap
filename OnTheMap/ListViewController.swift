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

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        DispatchQueue.main.async{
            self.tableView.reloadData()
        }
        print(appDelegate.retrieveData().count)
    }
    
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
        
        cell.textLabel?.text = "\(firstName) \(lastName)"
        cell.detailTextLabel?.text = postedUrl
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        print(appDelegate.retrieveData().count)
        print("pass1")
        return appDelegate.retrieveData().count
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ShowWebView", sender: nil)
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
                //Return ERROR
                return
            }
            
            nextView.targetUrl = url
        }
    }
}
