//
//  Variety.swift
//  FarmApp
//
//  Created by Molly Driscoll on 2/17/16.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import Foundation
class Variety: NSObject, NSCoding{
    
    var name : String!
    var bestSeasons : [String]!
    var notes : [String]!
    var bedHistory : BedHistory!
    
    //Default init method
    init(name: String, bestSeasons : [String], notes : [String], bedHistory: BedHistory){
        super.init()
        self.name = name
        self.bestSeasons = bestSeasons
        self.notes = notes
        self.bedHistory = bedHistory
    }
    
    //Decode object from memory -- for archiving (saving) albums
    required init(coder decoder: NSCoder) {
        super.init()
        self.name = decoder.decodeObjectForKey("variety_name") as! String
        self.bestSeasons = decoder.decodeObjectForKey("variety_seasons") as! [String]
        self.notes = decoder.decodeObjectForKey("variety_notes") as! [String]
        self.bedHistory = decoder.decodeObjectForKey("variety_bedHistory") as! BedHistory
    }
    
    //Encode object to memory -- for archiving
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "variety_name")
        aCoder.encodeObject(bestSeasons, forKey: "variety_seasons")
        aCoder.encodeObject(notes, forKey: "variety_notes")
        aCoder.encodeObject(bedHistory, forKey: "variety_bedHistory")
    }
    
    func printBedHistory() -> String{
        return bedHistory.print()
    }
    
}
