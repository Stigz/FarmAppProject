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
    var dateHarvested: Date!
    
    var notes : [String]!
    var plant: Plant!
    
    //do we want a crop to have to be initialized with an image?
    init(datePlanted: Date, dateHarvested: Date, notes : [String], plant : Plant){
        super.init()
        self.datePlanted = datePlanted
        self.dateHarvested = dateHarvested
        self.notes = notes
        self.plant = plant
    }
    
    required init(coder decoder: NSCoder) {
        super.init()
        self.datePlanted = decoder.decodeObjectForKey("crop_dPlanted") as! Date
        self.dateHarvested = decoder.decodeObjectForKey("crop_dHarvested") as! Date
        self.notes = decoder.decodeObjectForKey("crop_notes") as! [String]
        self.plant = decoder.decodeObjectForKey("crop_plant") as! Plant
    }
    
    //Encode object to memory -- for archiving
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(datePlanted, forKey: "bed_dPlanted")
        aCoder.encodeObject(dateHarvested, forKey: "crop_dHarvested")
        aCoder.encodeObject(notes, forKey: "crop_notes")
        aCoder.encodeObject(plant, forKey: "crop_plant")
    }
    
    override var description : String{
        return "Date planted: \(datePlanted)," +
            "Date Harvested: \(dateHarvested)," +
        "Plant: \(plant.name)"
    }

    
    

    
}