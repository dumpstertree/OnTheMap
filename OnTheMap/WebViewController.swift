//
//  WebViewController.swift
//  OnTheMap
//
//  Created by Zachary Collins on 11/17/16.
//  Copyright © 2016 dumpstertree. All rights reserved.
//

import UIKit
import MapKit

class WebViewController: UIViewController {
    
    var targetUrl: URL!
    
    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        let request = URLRequest(url: targetUrl)
        webView.loadRequest( request )
    }
    @IBAction func dismiss(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
}