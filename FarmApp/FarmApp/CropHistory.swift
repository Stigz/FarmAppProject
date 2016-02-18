//
//  CropHistory.swift
//  FarmApp
//
//  Created by Molly Driscoll on 2/16/16.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import Foundation
import UIKit

class CropHistory: NSObject, NSCoding {
    var numCrops: Int!
    var crops: [Crop]!
    
    init(numCrops: Int, crops: [Crop]){
        super.init()
        self.numCrops = numCrops
        self.crops = crops
    
    }
    
    required init(coder decoder: NSCoder) {
        super.init()
        self.numCrops = decoder.decodeObjectForKey("CropHistory_numCrops") as! Int
        self.crops = decoder.decodeObjectForKey("CropHistory_crops") as! [Crop]
  
    }
    
    //Encode object to memory -- for archiving
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(numCrops, forKey: "CropHistory_numCrops")
        aCoder.encodeObject(crops, forKey: "CropHistory_crops")
        
    }

}