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
   
    
    var datePlanted: [Int]!
    var dateHarvested: [Int]!
    
    var notes : [String]!
    var variety: String!
    
    var image : UIImage!
    //do we want a crop to have to be initialized with an image?
    init(datePlanted: [Int], dateHarvested: [Int], notes : [String], variety : String, image : UIImage){
        super.init()
        self.datePlanted = datePlanted
        self.dateHarvested = dateHarvested
        self.notes = notes
        self.variety = variety
        self.image = image
    }
    
    required init(coder decoder: NSCoder) {
        super.init()
        self.datePlanted = decoder.decodeObjectForKey("crop_dPlanted") as! [Int]
        self.dateHarvested = decoder.decodeObjectForKey("crop_dHarvested") as! [Int]
        self.notes = decoder.decodeObjectForKey("crop_notes") as! [String]
        self.variety = decoder.decodeObjectForKey("crop_variety") as! String
        self.image = decoder.decodeObjectForKey("crop_image") as! UIImage
    }
    
    //Encode object to memory -- for archiving
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(datePlanted, forKey: "bed_dPlanted")
        aCoder.encodeObject(dateHarvested, forKey: "crop_dHarvested")
        aCoder.encodeObject(notes, forKey: "crop_notes")
        aCoder.encodeObject(variety, forKey: "crop_variety")
        aCoder.encodeObject(image, forKey: "crop_image")
    }
    
    override var description : String{
        return "Date planted: \(datePlanted)," +
            "Date Harvested: \(dateHarvested)," +
        "Variety: \(variety)"
    }

    
    

    
}