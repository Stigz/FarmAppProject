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
    
    //Default init method 
    init(id: Int, beds : [Bed], numBeds : Int){
        super.init()
        self.id = id
        self.beds = beds
        self.numBeds = numBeds
    }
    
    //Decode object from memory -- for archiving (saving) albums
    required init(coder decoder: NSCoder) {
        super.init()
        self.id = decoder.decodeObjectForKey("sect_id") as! Int
        self.beds = decoder.decodeObjectForKey("sect_bedList") as! [Bed]
        self.numBeds = decoder.decodeObjectForKey("sect_numBeds") as! Int
    }
    
    //Encode object to memory -- for archiving
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: "sect_id")
        aCoder.encodeObject(beds, forKey: "sect_bedList")
        aCoder.encodeObject(numBeds, forKey: "sect_numBeds")
    }
    
    //Description of section
    override var description : String{
        return "Section: \(id)" +
        "# Beds \(numBeds)"
    }

}
