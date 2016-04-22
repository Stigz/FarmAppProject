//
//  Variety.swift
//  FarmApp
//
//  Created by Molly Driscoll on 2/17/16.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import Foundation
class Variety: NSObject, NSCoding{
    var plant: Plant!
    var name : String!
    var bestSeasons : [String]!
    var notes : String!
    var bedHistory : [BedHistory]!
    var varietyWeight : Int!
    
    //Default init method
    init(name: String, bestSeasons : [String], notes : String, bedHistory: [BedHistory], plant: Plant?, varietyWeight: Int){
        super.init()
        self.name = name
        self.bestSeasons = bestSeasons
        self.notes = notes
        self.bedHistory = bedHistory
        self.plant = plant
        self.varietyWeight = varietyWeight
    }
    
    //Decode object from memory -- for archiving (saving) albums
    required init(coder decoder: NSCoder) {
        super.init()
        self.name = decoder.decodeObjectForKey("variety_name") as! String
        self.bestSeasons = decoder.decodeObjectForKey("variety_seasons") as! [String]
        self.notes = decoder.decodeObjectForKey("variety_notes") as! String
        self.bedHistory = decoder.decodeObjectForKey("variety_bedHistory") as! [BedHistory]
        self.plant = decoder.decodeObjectForKey("variety_plant") as! Plant
        self.varietyWeight = decoder.decodeObjectForKey("variety_weight") as! Int
    }
    
    
    
    //Encode object to memory -- for archiving
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "variety_name")
        aCoder.encodeObject(bestSeasons, forKey: "variety_seasons")
        aCoder.encodeObject(notes, forKey: "variety_notes")
        aCoder.encodeObject(bedHistory, forKey: "variety_bedHistory")
        aCoder.encodeObject(plant, forKey: "variety_plant")
        aCoder.encodeObject(varietyWeight, forKey: "variety_weight")
    }
    
    func encodeForDB() -> NSMutableDictionary{
        let theDict = NSMutableDictionary()
        theDict.setValue(plant.name, forKey: "Plant_Name")
        theDict.setValue(name, forKey: "Variety_Name")
        if bestSeasons != []{
            let bestSeasonsDict = NSMutableDictionary()
            var count = 0
            while count < bestSeasons.count {
                bestSeasonsDict.setValue(bestSeasons[count], forKey: "Best_Season_\(count)")
                count++
            }
            theDict.setValue(bestSeasonsDict, forKey: "Best_Seasons")
        }
        theDict.setValue(notes, forKey: "Variety_Notes")
        if bedHistory != []{
            let bedHistoryDict = NSMutableDictionary()
            var count = 0
            while count < bedHistory.count {
                bedHistoryDict.setValue(bedHistory[count].encodeForDB(), forKey: "Bed_\(count)")
                count++
            }
            theDict.setValue(bedHistoryDict, forKey: "Bed_History")
        }
        theDict.setValue(varietyWeight, forKey: "Total_Weight")
        return theDict
    }
    
    
}
