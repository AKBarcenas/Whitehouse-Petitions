//
//  DetailViewController.swift
//  Whitehouse Petitions
//
//  Created by Alex on 12/29/15.
//  Copyright © 2015 Alex Barcenas. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    // The web view used to display things on the detail controller.
    var webView: WKWebView!
    // The item that we want to display.
    var detailItem: [String: String]!
    
    /*
     * Function Name: loadView
     * Parameters: None
     * Purpose: This method creates a web view and assigns it to the web view property of the
     *   detail controller.
     * Return Value: None
     */
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    /*
    * Function Name: viewDidLoad
    * Parameters: None
    * Purpose: This method uses HTML to display and format the body of the petition inside of the web view.
    * Return Value: None
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard detailItem != nil else { return }
        
        // Checks if the item has a body value.
        if let body = detailItem["body"] {
            var html = "<html>"
            html += "<head>"
            html += "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"
            html += "<style> body { font-size: 150%; } </style>"
            html += "</head>"
            html += "<body>"
            html += body
            html += "</body>"
            html += "</html>"
            webView.loadHTMLString(html, baseURL: nil)
        }
    }
}
