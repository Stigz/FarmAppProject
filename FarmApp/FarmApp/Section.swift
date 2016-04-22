//
//  Section.swift
//  FarmApp
//
//  Created by Patrick Little on 10/02/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit

class Section: NSObject, NSCoding {
    
    var id : Int!
    var beds : [Bed]!
    var numBeds : Int!
    var sectionWeight : Float!
    
    //Default init method 
    init(id: Int, beds : [Bed], numBeds : Int, sectionWeight : Float){
        super.init()
        self.id = id
        self.beds = beds
        self.numBeds = numBeds
        self.sectionWeight = sectionWeight
    }
    
    //Decode object from memory -- for archiving (saving) albums
    required init(coder decoder: NSCoder) {
        super.init()
        self.id = decoder.decodeObjectForKey("sect_id") as! Int
        self.beds = decoder.decodeObjectForKey("sect_bedList") as! [Bed]
        self.numBeds = decoder.decodeObjectForKey("sect_numBeds") as! Int
        self.sectionWeight = decoder.decodeObjectForKey("sect_weight") as! Float
    }
    
    //Encode object to memory -- for archiving
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "sect_id")
        aCoder.encodeObject(beds, forKey: "sect_bedList")
        aCoder.encodeObject(numBeds, forKey: "sect_numBeds")
         aCoder.encodeObject(sectionWeight, forKey: "sect_weight")
    }
    
    //Description of section
    override var description : String{
        return "Section: \(id)" +
        "# Beds \(numBeds)"
    }
    
    func encodeForDB() -> NSMutableDictionary{
        let theDict = NSMutableDictionary()
        theDict.setValue(id, forKey: "Sect_ID")
        theDict.setValue(sectionWeight, forKey: "Sect_Weight")
        theDict.setValue(numBeds, forKey: "Num_Beds")
        if beds != []{
            let bedsDict = NSMutableDictionary()
            var count = 0
            while count < beds.count {
                bedsDict.setValue(beds[count].encodeForDB(), forKey: "Bed_\(count)")
                count++
            }
            theDict.setValue(bedsDict, forKey: "Beds")
        }
        return theDict
    }
    

}
