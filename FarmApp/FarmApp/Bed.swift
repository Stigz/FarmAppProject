//
//  Bed.swift
//  FarmApp
//
//  Created by Patrick Little on 15/02/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit

class Bed: NSObject {
    
    var id : Int!
    var currentCrop : String!
    var numCropsInHistory : Int!
    var cropHistory : [String]!
    
    //Default init method
    init(id: Int, currentCrop : String, numCropsInHistory : Int, cropHistory : [String]){
        super.init()
        self.id = id
        self.currentCrop = currentCrop
        self.numCropsInHistory = numCropsInHistory
        self.cropHistory = cropHistory
    }
    
    //Description of section
    override var description : String{
        return "Bed: \(id)" +
        "# Crops: \(numCropsInHistory)" +
        "Current Crop: \(currentCrop)"
    }

}
