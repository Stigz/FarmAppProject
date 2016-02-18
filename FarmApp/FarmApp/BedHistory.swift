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
    var dates : [Date]!
    var beds : [Bed]!
    
    
    init(date: Date, bed: Bed){
        super.init()
       dates = [date]
       beds = [bed]
        
    }
    override init(){
        super.init()
        dates = []
        beds = []
    }
    required init(coder decoder: NSCoder) {
        super.init()
        self.dates = decoder.decodeObjectForKey("BH_dates") as! [Date]
        self.beds = decoder.decodeObjectForKey("BH_beds") as! [Bed]
        
    }
    
    //Encode object to memory -- for archiving
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(dates, forKey: "BH_dates")
        aCoder.encodeObject(beds, forKey: "BH_beds")
    }
    
    func print() -> String{
        var retStr = ""
        for i in 0...(dates.count - 1) {
            retStr += "\(dates[i].printSlash())" + " Bed: " + beds[i].getID() + "\n"
        }
        return retStr
    }

}