//
//  BedHistory.swift
//  FarmApp
//
//  Created by Molly Driscoll on 2/17/16.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import Foundation
import UIKit

class BedHistory: NSObject, NSCoding {
    var data : (Date, Int, Int)!
    
    
    init(date: Date, sectID : Int, bedID: Int){
        super.init()
        data = (date,sectID, bedID)
        
    }
    
    required init(coder decoder: NSCoder) {
        super.init()
        let date = decoder.decodeObjectForKey("BH_date") as! Date
        let sectID = decoder.decodeObjectForKey("sectID") as! Int
        let bedID = decoder.decodeObjectForKey("bedID") as! Int

        data = (date, sectID, bedID)
        
    }
    
    //Encode object to memory -- for archiving
    func encodeWithCoder(aCoder: NSCoder) {
        let date = data.0
        let bedID = data.1
        let sectID = data.2
        aCoder.encodeObject(date, forKey: "BH_date")
        aCoder.encodeObject(bedID, forKey: "bedID")
        aCoder.encodeObject(sectID, forKey: "sectID")

    }
    
    func encodeForDB() -> NSMutableDictionary{
        let theDict = NSMutableDictionary()
        theDict.setValue(data.0.encodeForDB(), forKey: "BH_Date")
        theDict.setValue(data.1, forKey: "BH_Sect_ID")
        theDict.setValue(data.2, forKey: "BH_Bed_ID")
        return theDict
    }

}