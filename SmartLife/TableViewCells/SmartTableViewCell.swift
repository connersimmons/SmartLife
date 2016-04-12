//
//  SmartTableViewCell.swift
//  SmartLife
//
//  Created by Conner Simmons on 4/12/16.
//  Copyright © 2016 Conner Simmons. All rights reserved.
//

import UIKit

class SmartTableViewCell: UITableViewCell {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        backgroundImageView.layer.cornerRadius = 5
    }

}
