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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
