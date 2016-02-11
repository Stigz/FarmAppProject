//
//  Section.swift
//  FarmApp
//
//  Created by Patrick Little on 10/02/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit

class Section: NSObject {
    
    var id : Int!
    var beds : [String]!
    var numBeds : Int!
    
    //Default init method 
    init(id: Int, beds : [String], numBeds : Int){
        super.init()
        self.id = id
        self.beds = beds
        self.numBeds = numBeds
    }
    
    //Description of section
    override var description : String{
        return "Section: \(id)" +
        "# Beds \(numBeds)"
    }

}
