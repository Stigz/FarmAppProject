//
//  Crop.swift
//  FarmApp
//
//  Created by Molly Driscoll on 2/16/16.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import Foundation
import UIKit

class Crop: NSObject, NSCoding{
   
    
    var datePlanted: Date!
    var datesHarvested: [Date]!
    var finalHarvest : Date?
    
    var notes : String!
    var variety: Variety!
    
    //do we want a crop to have to be initialized with an image?
    init(datePlanted: Date, datesHarvested: [Date], notes : String, variety: Variety, finalHarvest : Date?){
        super.init()
        self.datePlanted = datePlanted
        self.datesHarvested = datesHarvested
        self.notes = notes
        self.variety = variety
        self.finalHarvest = finalHarvest
    }
    
    required init(coder decoder: NSCoder) {
        super.init()
        self.datePlanted = decoder.decodeObjectForKey("crop_dPlanted") as! Date
        self.datesHarvested = decoder.decodeObjectForKey("crop_dHarvested") as! [Date]
        self.notes = decoder.decodeObjectForKey("crop_notes") as! String
        self.variety = decoder.decodeObjectForKey("crop_Variety") as! Variety
        self.finalHarvest = decoder.decodeObjectForKey("crop_fHarvest") as! Date
    }
    
    //Encode object to memory -- for archiving
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(datePlanted, forKey: "bed_dPlanted")
        aCoder.encodeObject(datesHarvested, forKey: "crop_dHarvested")
        aCoder.encodeObject(notes, forKey: "crop_notes")
        aCoder.encodeObject(variety, forKey: "crop_Variety")
        aCoder.encodeObject(finalHarvest, forKey: "crop_fHarvest")
    }
    
    override var description : String{
        return "Date planted: \(datePlanted)," +
            "Date Harvested: \(finalHarvest)," +
        "Variety: \(variety.name)"
    }

    
    

    
}