//
//  MotionTableViewCell.swift
//  SmartLife
//
//  Created by Conner Simmons on 4/21/16.
//  Copyright © 2016 Conner Simmons. All rights reserved.
//

import UIKit

class MotionTableViewCell: UITableViewCell {

    @IBOutlet weak var bedroomStatus: UILabel!
    @IBOutlet weak var bedroomLastSeen: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
