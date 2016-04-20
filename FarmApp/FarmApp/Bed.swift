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
    var bedWeight : Int!
    var sectID : Int!
    var bedKey : String!
    
    //need to add bed id into the constructor
    //Default init method

    init(id: Int, currentCrop : Crop?, cropHistory : CropHistory, sectID : Int, bedKey : String){

        super.init()
        self.id = id
        self.currentCrop = currentCrop
        self.cropHistory = cropHistory
        self.sectID = sectID
        self.bedKey = bedKey
    }
    
    //Decode object from memory -- for archiving (saving) albums
    required init(coder decoder: NSCoder) {
        super.init()
        self.id = decoder.decodeObjectForKey("bed_id") as! Int
        self.currentCrop = decoder.decodeObjectForKey("bed_currCrop") as? Crop
        self.cropHistory = decoder.decodeObjectForKey("bed_cropHist") as! CropHistory
        self.bedWeight = decoder.decodeObjectForKey("bed_weight") as! Int
    }
    
    //Encode object to memory -- for archiving
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "bed_id")
        aCoder.encodeObject(currentCrop, forKey: "bed_currCrop")
        aCoder.encodeObject(cropHistory, forKey: "bed_cropHist")
        aCoder.encodeObject(bedWeight, forKey: "bed_weight")
    }
    
    //Description of section
    override var description : String{
        return "Bed: \(id)" +
        "Current Crop: \(currentCrop)"
    }
    
    func getID() -> String{
        return "\(id)"
    }
    
    func encodeForDB() -> NSMutableDictionary{
        let theDict = NSMutableDictionary()
        theDict.setValue(id, forKey: "Bed_Id")
        theDict.setValue(currentCrop!.encodeForDB(), forKey: "Current_Crop")
        theDict.setValue(cropHistory.encodeForDB(), forKey: "Crop_History")
        theDict.setValue(bedWeight, forKey: "Bed_Weight")
        theDict.setValue(sectID, forKey: "Sect_ID")
        return theDict
    }

}
