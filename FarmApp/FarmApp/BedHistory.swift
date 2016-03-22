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
    var data : (Date, Bed)!
    
    
    init(date: Date, bed: Bed){
        super.init()
        data = (date,bed)
        
    }
    
    required init(coder decoder: NSCoder) {
        super.init()
        let date = decoder.decodeObjectForKey("BH_date") as! Date
        let bed = decoder.decodeObjectForKey("BH_bed") as! Bed
        data = (date,bed)
        
    }
    
    //Encode object to memory -- for archiving
    func encodeWithCoder(aCoder: NSCoder) {
        let date = data.0
        let bed = data.1
        aCoder.encodeObject(date, forKey: "BH_dates")
        aCoder.encodeObject(bed, forKey: "BH_beds")
    }

}