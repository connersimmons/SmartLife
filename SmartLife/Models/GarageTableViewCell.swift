//
//  GarageTableViewCell.swift
//  SmartLife
//
//  Created by Conner Simmons on 4/19/16.
//  Copyright © 2016 Conner Simmons. All rights reserved.
//

import UIKit

class GarageTableViewCell: UITableViewCell {

    @IBOutlet weak var garageDoorStatus: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var garageDoorSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        self.layer.cornerRadius = 8
        //webView.backgroundColor = UIColor.clearColor()
        //webView.opaque = false
        //webView.userInteractionEnabled = false
        webView.hidden = true
    }
    
    @IBAction func garageDoorSwitchPressed(sender: AnyObject) {
        let ledSwitch = sender as! UISwitch
        
        var commandURL = NSURL()
        
        if ledSwitch.on {
            print("Garage Door: Opening...")
            commandURL = NSURL(string: "http://192.168.1.101/$5")!
        } else {
            print("Garage Door: Closing...")
            commandURL = NSURL(string: "http://192.168.1.101/$6")!
        }
        
        let urlRequest = NSURLRequest(URL: commandURL)
        webView.loadRequest(urlRequest)
    }
}
