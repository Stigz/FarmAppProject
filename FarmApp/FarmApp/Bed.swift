//
//  Bed.swift
//  FarmApp
//
//  Created by Patrick Little on 15/02/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit

class Bed: NSObject, NSCoding{
    
    var id : Int!
    var currentCrop : Crop?
    var cropHistory : CropHistory!
    
    //Default init method
    init(id: Int, currentCrop : Crop, cropHistory : CropHistory){
        super.init()
        self.id = id
        self.currentCrop = currentCrop
        self.cropHistory = cropHistory
    }
    
    //Decode object from memory -- for archiving (saving) albums
    required init(coder decoder: NSCoder) {
        super.init()
        self.id = decoder.decodeObjectForKey("bed_id") as! Int
        self.currentCrop = decoder.decodeObjectForKey("bed_currCrop") as? Crop
        self.cropHistory = decoder.decodeObjectForKey("bed_cropHist") as! CropHistory
    }
    
    //Encode object to memory -- for archiving
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "bed_id")
        aCoder.encodeObject(currentCrop, forKey: "bed_currCrop")
        aCoder.encodeObject(cropHistory, forKey: "bed_cropHist")
    }
    
    //Description of section
    override var description : String{
        return "Bed: \(id)" +
        "Current Crop: \(currentCrop)"
    }
    
    func getID() -> String{
        return "\(id)"
    }

}
