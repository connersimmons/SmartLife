//
//  GarageTableViewCell.swift
//  SmartLife
//
//  Created by Conner Simmons on 4/19/16.
//  Copyright © 2016 Conner Simmons. All rights reserved.
//

import UIKit

class GarageTableViewCell: UITableViewCell {

    var timer = NSTimer()
    
    @IBOutlet weak var garageDoorStatus: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var garageDoorSwitch: UISwitch!
    
    @IBOutlet weak var garageDoorStatus2: UILabel!
    @IBOutlet weak var garageDoorSwitch2: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        //self.layer.cornerRadius = 8
        //webView.backgroundColor = UIColor.clearColor()
        //webView.opaque = false
        //webView.userInteractionEnabled = false
        webView.hidden = true
    }
    
    @IBAction func garageDoorSwitchPressed(sender: AnyObject) {
        let ledSwitch = sender as! UISwitch
        
        var commandURL = NSURL()
        
        if ledSwitch.on {
            garageDoorStatus.text = "Opening..."
            commandURL = NSURL(string: "http://192.168.1.101/$5")!
        } else {
            garageDoorStatus.text = "Closing..."
            commandURL = NSURL(string: "http://192.168.1.101/$6")!
        }
        
        let urlRequest = NSURLRequest(URL: commandURL)
        webView.loadRequest(urlRequest)
    }
    
    @IBAction func garageDoorSwitch2Pressed(sender: AnyObject) {
        let ledSwitch = sender as! UISwitch
        
        var commandURL = NSURL()
        
        if ledSwitch.on {
            garageDoorStatus2.text = "Opening..."
            commandURL = NSURL(string: "http://192.168.1.101/$7")!
        } else {
            garageDoorStatus2.text = "Closing..."
            commandURL = NSURL(string: "http://192.168.1.101/$8")!
        }
        
        let urlRequest = NSURLRequest(URL: commandURL)
        webView.loadRequest(urlRequest)
    }
}
