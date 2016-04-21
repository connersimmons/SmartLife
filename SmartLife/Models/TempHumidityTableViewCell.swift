//
//  TempHumidityTableViewCell.swift
//  SmartLife
//
//  Created by Conner Simmons on 4/19/16.
//  Copyright © 2016 Conner Simmons. All rights reserved.
//

import UIKit

class TempHumidityTableViewCell: UITableViewCell {

    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var currentHumidity: UILabel!
    @IBOutlet weak var unitSwitch: UISwitch!
    
    var tempStr : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func unitSwitchPressed(sender: AnyObject) {
        let unitSwitch = sender as! UISwitch
        
        if unitSwitch.on {
            let celsius = convertToCelsius(Int(tempStr)!)
            currentTemp.text = "\(String(celsius)) °C"
        } else {
            let fahrenheit = Int(tempStr)
            if let f = fahrenheit {
                currentTemp.text = "\(String(f)) °F"
            }
        }
    }
    
    func convertToCelsius(fahrenheit: Int) -> Int {
        return Int(5.0 / 9.0 * (Double(fahrenheit) - 32.0))
    }
}
