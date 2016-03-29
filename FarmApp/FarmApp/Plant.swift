//
//  Plant.swift
//  FarmApp
//
//  Created by Molly Driscoll on 2/20/16.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import Foundation
import UIKit

class Plant: NSObject, NSCoding{
    
    var name : String!
    var bestSeasons : [String]!
    var notes : String!
    var varieties : [Variety]!
    var plant_weight : Int!
    
    //Default init method
    init(name: String, bestSeasons : [String], notes : String, varieties: [Variety], weight: Int){
        super.init()
        self.name = name
        self.bestSeasons = bestSeasons
        self.notes = notes
        self.varieties = varieties
        self.plant_weight = weight
    }
    
    //Decode object from memory -- for archiving (saving) albums
    required init(coder decoder: NSCoder) {
        super.init()
        self.name = decoder.decodeObjectForKey("plant_name") as! String
        self.bestSeasons = decoder.decodeObjectForKey("plant_seasons") as! [String]
        self.notes = decoder.decodeObjectForKey("plant_notes") as! String
        self.varieties = decoder.decodeObjectForKey("plant_varieties") as! [Variety]
        self.plant_weight = decoder.decodeObjectForKey("plant_weight") as! Int
    }
    
    //Encode object to memory -- for archiving
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "plant_name")
        aCoder.encodeObject(bestSeasons, forKey: "plant_seasons")
        aCoder.encodeObject(notes, forKey: "plant_notes")
        aCoder.encodeObject(varieties, forKey: "plant_varieties")
        aCoder.encodeObject(plant_weight, forKey: "plant_weight")

    }
    
 
    
}
