//
//  HomeTableViewController.swift
//  SmartLife
//
//  Created by Conner Simmons on 4/19/16.
//  Copyright © 2016 Conner Simmons. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
    
    var timer : NSTimer!
    private var commHelper : CommunicationHelper!
    
    let cellReuseID = "Cell"
    let lightsCellNibName = "LightsTableViewCell"
    let garageCellNibName = "GarageTableViewCell"
    let tempHumCellNibName = "TempHumidityTableViewCell"
    let motionCellNibName = "MotionTableViewCell"
    
    let arduinoURL = "http://192.168.1.101/"
    
    var kitchenStatus = "?"
    var bathroomStatus = "?"
    var fahrenheit = "?"
    var celsius = "?"
    var humidity = "?"
    var garageStatus1 = "?"
    var garageStatus2 = "?"
    var bedroomMotionStatus = "?"
    var bedroomLastSeen : NSDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = .None
        
        commHelper = CommunicationHelper.sharedInstance
        
        let jsonResults = commHelper.performRestCall("\(arduinoURL)$0")
        handleResultsOfWebCall(jsonResults)
        
        self.timer = NSTimer(timeInterval: 2.0, target: self, selector: #selector(HomeTableViewController.refresh(_:)), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(self.timer, forMode: NSDefaultRunLoopMode)
        
        self.refreshControl?.backgroundColor = UIColor.blackColor()
        self.refreshControl?.tintColor = UIColor.whiteColor()
        self.refreshControl?.addTarget(self, action: #selector(HomeTableViewController.refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Refresh Control
    
    func refresh(sender:AnyObject) {
        let jsonResults = commHelper.performRestCall("\(arduinoURL)$0")
        print(jsonResults)
        handleResultsOfWebCall(jsonResults)
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
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
            
            cell.garageDoorStatus.text = garageStatus1
            if garageStatus1 == "Open" {
                cell.garageDoorSwitch.setOn(true, animated: true)
            } else if garageStatus1 == "Closed" {
                cell.garageDoorSwitch.setOn(false, animated: true)
            }
            
            cell.garageDoorStatus2.text = garageStatus2
            if garageStatus2 == "Open" {
                cell.garageDoorSwitch2.setOn(true, animated: true)
            } else if garageStatus2 == "Closed" {
                cell.garageDoorSwitch2.setOn(false, animated: true)
            }
            
            return cell
        case 2:
            tableView.registerNib(UINib(nibName: tempHumCellNibName, bundle: nil), forCellReuseIdentifier: cellReuseID)
            let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseID, forIndexPath: indexPath) as! TempHumidityTableViewCell
            
            if cell.unitSwitch.on {
                if celsius == "ERROR" {
                    cell.currentTemp.text = "\(celsius)"
                }
                else {
                    cell.currentTemp.text = "\(celsius) °C"
                }
            } else {
                if fahrenheit == "ERROR" {
                    cell.currentTemp.text = "\(fahrenheit)"
                }
                else {
                    cell.currentTemp.text = "\(fahrenheit) °F"
                }
            }
            //cell.tempStr = fahrenheit
            //print(temperature)
            //cell.currentTemp.text = "\(temperatureRound(temperature)) °F"
            
            if humidity == "ERROR" {
                cell.currentHumidity.text = "\(humidity)"
            }
            else {
                cell.currentHumidity.text = "\(humidity) %"
            }
            
            return cell
        case 3:
            tableView.registerNib(UINib(nibName: motionCellNibName, bundle: nil), forCellReuseIdentifier: cellReuseID)
            let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseID, forIndexPath: indexPath) as! MotionTableViewCell
            
            cell.bedroomStatus.text = bedroomMotionStatus
            if bedroomLastSeen != nil {
                cell.bedroomLastSeen.text = bedroomLastSeen.shortDateTimeStyle()
            } else {
                cell.bedroomLastSeen.text = "N/A"
            }

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
        view.backgroundColor = UIColor.blackColor()
        return view
    }
    
    
    // MARK: - Utility Methods
    
    func handleResultsOfWebCall(jsonResults : NSDictionary) {
        
        //let jsonResults = (try! NSJSONSerialization.JSONObjectWithData(theData, options: [])) as! NSDictionary
        
        let theSensors = jsonResults["arduino"] as! NSArray
        for i in 0..<theSensors.count {
            let sensor = theSensors[i] as! NSDictionary
            let key = sensor["key"] as! String
            let value = sensor["value"] as! String
            
            if key == "kitchenLED" {
                if value == "1" {
                    kitchenStatus = "On"
                } else if value == "0" {
                    kitchenStatus = "Off"
                }
                else {
                    kitchenStatus = "ERROR"
                }
            } else if key == "bathroomLED" {
                if value == "1" {
                    bathroomStatus = "On"
                } else if value == "0" {
                    bathroomStatus = "Off"
                }
            } else if key == "temperatureF" {
                if value == " NAN" {
                    fahrenheit = "ERROR"
                }
                else {
                   fahrenheit = valueRound(value)
                }
            } else if key == "temperatureC" {
                if value == " NAN" {
                    celsius = "ERROR"
                }
                else {
                    celsius = valueRound(value)
                }
            } else if key == "humidity" {
                if value == " NAN" {
                    humidity = "ERROR"
                }
                else {
                    humidity = valueRound(value)
                }
            } else if key == "garage1" {
                if value == "Open" {
                    garageStatus1 = "Open"
                } else if value == "Closed" {
                    garageStatus1 = "Closed"
                } else {
                    garageStatus1 = "ERROR"
                }
            } else if key == "garage2" {
                if value == "Open" {
                    garageStatus2 = "Open"
                } else if value == "Closed" {
                    garageStatus2 = "Closed"
                }
            } else if key == "motion" {
                if value == "1" {
                    bedroomMotionStatus = "Detected"
                    bedroomLastSeen = NSDate()
                } else {
                    bedroomMotionStatus = "None"
                }
            }
            
            
        }
        
        tableView.reloadData()
    }
    
    func showAlert(alertMessage : String) {
        let alertController = UIAlertController(title: "Error", message: alertMessage, preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        return
    }

    private func valueRound(str : String) -> String {
        let temp = Double(str)
        return String(Int(round(temp!)))
    }
}
