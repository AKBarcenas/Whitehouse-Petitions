//
//  MasterViewController.swift
//  Whitehouse Petitions
//
//  Created by Alex on 12/29/15.
//  Copyright © 2015 Alex Barcenas. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    // Holds the dictionaries that contain information about each petition.
    var objects = [[String: String]]()
    
    /*
     * Function Name: viewDidLoad
     * Parameters: None
     * Purpose: This method tries to retrieve petitions from a government website. If the petitions
     *   cannot be retrieved or if they cannot be parsed, then an error will be displayed.
     * Return Value: None
     */

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let urlString: String
        
        if navigationController?.tabBarItem.tag == 0 {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
        }
        
        else {
            urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
        }
        
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) { [unowned self] in
            // Checks if a valid URL is gotten.
            if let url = NSURL(string: urlString) {
                // Checks if data was successfully retrieved.
                if let data = try? NSData(contentsOfURL: url, options: []) {
                    // Holds the data in JSON format.
                    let json = JSON(data: data)
                    
                    // Checks if the data is parsable.
                    if json["metadata"]["responseInfo"]["status"].intValue == 200 {
                        self.parseJSON(json)
                    }
                    
                    else {
                        self.showError()
                    }
                }
                
                else {
                    self.showError()
                }
            }
            
            else {
                self.showError()
            }
        }
    }
    
    /*
     * Function Name: parseJSON
     * Parameters: json - data that is formatted in the JSON format.
     * Purpose: This method takes each petition and puts the information in each petition into a dictionary.
     *   Each dictionary is then stored into an array of petitions in dictionary format.
     * Return Value: None
     */
    
    func parseJSON(json: JSON) {
        for result in json["results"].arrayValue {
            let title = result["title"].stringValue
            let body = result["body"].stringValue
            let sigs = result["signatureCount"].stringValue
            let obj = ["title": title, "body": body, "sigs": sigs]
            objects.append(obj)
        }
        
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            self.tableView.reloadData()
        }
    }
    
    /*
     * Function Name: showError
     * Parameters: None
     * Purpose: This method brings up an alert view controller letting the user know that an error has occurred.
     * Return Value: None
     */
    
    func showError() {
        dispatch_async(dispatch_get_main_queue()) { [unowned self] in
            let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
            self.presentViewController(ac, animated: true, completion: nil)
        }
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
                controller.detailItem = object
                controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    /*
     * Function Name: tableView
     * Parameters: tableView - the table view that this method was called on.
     *   indexPath - index path that locates a row in the table.
     * Purpose: This method creates cells for a petition that contains the petition's title and body.
     * Return Value: None
     */
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object["title"]
        cell.detailTextLabel!.text = object["body"]
        return cell
    }

}

