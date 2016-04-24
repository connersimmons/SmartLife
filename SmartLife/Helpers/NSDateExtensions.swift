//
//  NSDateExtensions.swift
//  SmartLife
//
//  Created by Conner Simmons on 4/21/16.
//  Copyright © 2016 Conner Simmons. All rights reserved.
//

import Foundation

/// Extension holding new methods for NSDate.
extension NSDate {
    
    /// Translates an NSDate object to have a short date style and short time style.
    /// Example output: 11/23/15 at 6:50 PM
    ///
    /// - returns: human readable date and time string
    func shortDateTimeStyle() -> String {
        let formatter = NSDateFormatter()
        formatter.dateStyle = .ShortStyle
        formatter.timeStyle = .ShortStyle
        
        return formatter.stringFromDate(self)
    }
    
}