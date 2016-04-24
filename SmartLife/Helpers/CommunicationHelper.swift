//
//  CommunicationHelper.swift
//  SmartLife
//
//  Created by Conner Simmons on 4/20/16.
//  Copyright © 2016 Conner Simmons. All rights reserved.
//

import Foundation
import Alamofire
import Alamofire_Synchronous

class CommunicationHelper {
    
    private var requestSent = false
    
    class var sharedInstance: CommunicationHelper {
        struct Singleton {
            static let instance = CommunicationHelper()
        }
        
        return Singleton.instance
    }
    
    func performRestCall(urlString : String) -> NSDictionary {
        var jsonResults = NSDictionary()
        let response = Alamofire.request(.GET, urlString, parameters: nil).responseJSON()
        if let json = response.result.value {
            jsonResults = json as! NSDictionary
        }
        
        return jsonResults
    }
}

