//
//  LightsTableViewCell.swift
//  SmartLife
//
//  Created by Conner Simmons on 4/19/16.
//  Copyright © 2016 Conner Simmons. All rights reserved.
//

import UIKit

class LightsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var kitchenStatus: UILabel!
    @IBOutlet weak var bathroomStatus: UILabel!
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var kitchenSwitch: UISwitch!
    @IBOutlet weak var bathroomSwitch: UISwitch!
    
    private var commHelper : CommunicationHelper!
    
    let arduinoURL = "http://192.168.1.101/"
    
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
    
    @IBAction func kitchenSwitchPressed(sender: AnyObject) {
        let ledSwitch = sender as! UISwitch
        
        var commandURL = NSURL()
        
        if ledSwitch.on {
            print("Kithcen LED: ON")
            kitchenStatus.text = "On"
            commandURL = NSURL(string: "\(arduinoURL)$1")!
        } else {
            print("Kitchen LED: OFF")
            kitchenStatus.text = "Off"
            commandURL = NSURL(string: "\(arduinoURL)$2")!
        }
        
        let urlRequest = NSURLRequest(URL: commandURL)
        webView.loadRequest(urlRequest)
    }
    
    @IBAction func bathroomSwitchPressed(sender: AnyObject) {
        let ledSwitch = sender as! UISwitch
        
        var commandURL = NSURL()
        
        if ledSwitch.on {
            print("Bathroom LED: ON")
            bathroomStatus.text = "On"
            commandURL = NSURL(string: "\(arduinoURL)$3")!
        } else {
            print("Bathroom LED: OFF")
            bathroomStatus.text = "Off"
            commandURL = NSURL(string: "\(arduinoURL)$4")!
        }
        
        let urlRequest = NSURLRequest(URL: commandURL)
        webView.loadRequest(urlRequest)
    }
}
