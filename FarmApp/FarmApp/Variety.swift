//
//  Variety.swift
//  FarmApp
//
//  Created by Molly Driscoll on 2/17/16.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import Foundation
class variety: NSObject, NSCoding{
    
    var name : String!
    var harvestDate : Date!
    var plantingDate : Date!
    var bedHistory : BedHistory!
    
    //Default init method
    init(name: String, harvestDate : Date, plantingDate : Date){
        super.init()
        self.name = name
        self.harvestDate = harvestDate
        self.plantingDate = plantingDate
    }
    
    //Decode object from memory -- for archiving (saving) albums
    required init(coder decoder: NSCoder) {
        super.init()
        self.name = decoder.decodeObjectForKey("variety_name") as! String
        self.harvestDate = decoder.decodeObjectForKey("variety_harvestDate") as! Date
        self.plantingDate = decoder.decodeObjectForKey("variety_plantingDate") as! Date
    }
    
    //Encode object to memory -- for archiving
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "variety_name")
        aCoder.encodeObject(harvestDate, forKey: "variety_harvestDate")
        aCoder.encodeObject(plantingDate, forKey: "variety_plantingDate")
    }
    
    func printBedHistory() -> String{
        return bedHistory.print()
    }
    //add bedHistory
    func addBedHistory(date: Date, bed: Bed){
        bedHistory.add(date, bed: bed)
    }
    
    func initBedHistory(date: Date, bed: Bed){
        bedHistory = BedHistory(date: date, bed: bed)
    }
    
}
