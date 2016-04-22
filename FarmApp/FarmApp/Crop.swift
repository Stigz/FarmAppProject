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
    var varietyName : String!
    var notes : String?
    var variety: Variety!
    
    var harvestWeights : [Int]!
    var totalWeight : Int!
    
    //do we want a crop to have to be initialized with an image?
    init(datePlanted: Date, datesHarvested: [Date], notes : String?, variety: Variety, finalHarvest : Date?, harvestWeights: [Int], totalWeight: Int, varietyName: String){
        super.init()
        self.datePlanted = datePlanted
        self.datesHarvested = datesHarvested
        self.notes = notes
        self.variety = variety
        self.finalHarvest = finalHarvest
        self.harvestWeights = harvestWeights
        self.totalWeight = totalWeight
        self.varietyName = varietyName
    }
    
    required init(coder decoder: NSCoder) {
        super.init()
        self.datePlanted = decoder.decodeObjectForKey("crop_dPlanted") as! Date
        self.datesHarvested = decoder.decodeObjectForKey("crop_dHarvested") as! [Date]
        self.notes = decoder.decodeObjectForKey("crop_notes") as? String
        self.variety = decoder.decodeObjectForKey("crop_Variety") as! Variety
        self.finalHarvest = decoder.decodeObjectForKey("crop_fHarvest") as? Date
        self.harvestWeights = decoder.decodeObjectForKey("crop_harvestWeights") as! [Int]
        self.totalWeight = decoder.decodeObjectForKey("crop_totalWeight") as! Int
    }
    
    //Encode object to memory -- for archiving
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(datePlanted, forKey: "bed_dPlanted")
        aCoder.encodeObject(datesHarvested, forKey: "crop_dHarvested")
        aCoder.encodeObject(notes, forKey: "crop_notes")
        aCoder.encodeObject(variety, forKey: "crop_Variety")
        aCoder.encodeObject(harvestWeights, forKey: "crop_harvestWeights")
        aCoder.encodeObject(totalWeight, forKey: "crop_totalWeight")
        aCoder.encodeObject(finalHarvest, forKey: "crop_fHarvest")
    }
    
    override var description : String{
        return "Date planted: \(datePlanted)," +
            "Date Harvested: \(finalHarvest)," +
        "Variety: \(variety.name)"
    }

    func encodeForDB() -> NSMutableDictionary{
        let theDict = NSMutableDictionary()
        theDict.setValue(datePlanted.encodeForDB(), forKey: "Date_Planted")
        if datesHarvested != []{
            let datesHarvestedDict = NSMutableDictionary()
            var count = 0
            while count < datesHarvested.count {
                datesHarvestedDict.setValue(datesHarvested[count].encodeForDB(), forKey: "Harvest_Date_\(count)")
                count++
            }
            theDict.setValue(datesHarvestedDict, forKey: "Dates_Harvested")
            let weightsHarvestedDict = NSMutableDictionary()
            count = 0
            while count < harvestWeights.count {
                weightsHarvestedDict.setValue(harvestWeights[count], forKey: "Harvest_Weight_\(count)")
                count++
            }
            theDict.setValue(weightsHarvestedDict, forKey: "Weights_Harvested")
        }
        theDict.setValue(finalHarvest?.encodeForDB(), forKey: "Final_Harvest")
        theDict.setValue(notes, forKey: "Notes")
        theDict.setValue(varietyName, forKey: "Variety_Name")
        theDict.setValue(totalWeight, forKey: "Total_Weight")
        return theDict
    }
    

    
}