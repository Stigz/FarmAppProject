//
//  Date.swift
//  FarmApp
//
//  Created by Molly Driscoll on 2/17/16.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import Foundation
import UIKit

class Date: NSObject, NSCoding{
    
    var year : Int!
    var month : Int!
    var day : Int!
    
    //Default init method
    init(year: Int, month : Int, day : Int){
        super.init()
        self.year = year
        self.month = month
        self.day = day
    }
    
    //Decode object from memory -- for archiving (saving) albums
    required init(coder decoder: NSCoder) {
        super.init()
        self.day = decoder.decodeObjectForKey("day") as! Int
        self.month = decoder.decodeObjectForKey("month") as! Int
        self.year = decoder.decodeObjectForKey("Year") as! Int
    }
    
    //Encode object to memory -- for archiving
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(day, forKey: "day")
        aCoder.encodeObject(month, forKey: "month")
        aCoder.encodeObject(year, forKey: "year")
    }
    
    //Description of section
     func print() -> String{
        return "Year: \(year)" +
        "Month: \(month)" + "Day: \(day)"
        
    }
    func printSlash() -> String{
    return "\(month)/" + "\(day)/" + "\(year)"
    }
    
}
