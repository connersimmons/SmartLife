//
//  HomeTableViewController.swift
//  SmartLife
//
//  Created by Conner Simmons on 4/19/16.
//  Copyright © 2016 Conner Simmons. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    let cellReuseID = "Cell"
    let lightsCellNibName = "LightsTableViewCell"
    let garageCellNibName = "GarageTableViewCell"
    
    let arduinoURL = "http://192.168.1.101/"
    
    var kitchenStatus = "?"
    var bathroomStatus = "?"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
        
        performRestCall()
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        switch indexPath.section {
        case 0:
            tableView.registerNib(UINib(nibName: lightsCellNibName, bundle: nil), forCellReuseIdentifier: cellReuseID)
            let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseID, forIndexPath: indexPath) as! LightsTableViewCell
            
            cell.kitchenStatus.text = kitchenStatus
            if kitchenStatus == "On" {
                cell.kitchenSwitch.setOn(true, animated: true)
            } else {
                cell.kitchenSwitch.setOn(false, animated: true)
            }
            
            cell.bathroomStatus.text = bathroomStatus
            if bathroomStatus == "On" {
                cell.bathroomSwitch.setOn(true, animated: true)
            } else {
                cell.bathroomSwitch.setOn(false, animated: true)
            }
            return cell
        case 1:
            tableView.registerNib(UINib(nibName: garageCellNibName, bundle: nil), forCellReuseIdentifier: cellReuseID)
            let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseID, forIndexPath: indexPath) as! GarageTableViewCell
            return cell
        default:
            break
        }
        
        return UITableViewCell()
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 175
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.clearColor()
        return view
    }
    
    
    
    
    private func performRestCall() {        
        let urlRequest = NSMutableURLRequest(URL: NSURL(string: arduinoURL)!)
        urlRequest.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalAndRemoteCacheData
        urlRequest.HTTPMethod = "GET"
        urlRequest.setValue("application/json; charset=utf=8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(urlRequest) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) in
            
            dispatch_async(dispatch_get_main_queue(), {
                if let anError = error {
                    //error getting data
                    self.showAlert(anError.localizedDescription)
                } else {
                    //process JSON
                    self.handleResultsOfWebCall(data!)
                }
            })
            return
        }
        task.resume() //you need to call this
    }
    
    func handleResultsOfWebCall(theData : NSData) {
        
        let jsonResults = (try! NSJSONSerialization.JSONObjectWithData(theData, options: [])) as! NSDictionary
        
        let theSensors = jsonResults["arduino"] as! NSArray
        for i in 0..<theSensors.count {
            let sensor = theSensors[i] as! NSDictionary
            let key = sensor["key"] as! String
            let value = sensor["value"] as! String
            
            if (key == "kitchenLED") {
                if value == "1" {
                    kitchenStatus = "On"
                } else {
                    kitchenStatus = "Off"
                }
            } else if (key == "bathroomLED"){
                if value == "1" {
                    bathroomStatus = "On"
                } else {
                    bathroomStatus = "Off"
                }
            }
        }
        //lastUpdate = NSDate()
        //saveSettings()
        //updateDisplayWithCurrentReadings()
        
        tableView.reloadData()
    }
    
    
    func showAlert(alertMessage : String) {
        let alertController = UIAlertController(title: "Error", message: alertMessage, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        return
    }
    
    
    private func setup() {
        
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
