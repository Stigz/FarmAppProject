//
//  PersistencyManager.swift
//  FarmApp
//
//  Created by Patrick Little on 10/02/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit

class PersistencyManager: NSObject {
    
    private var sections = [Section]()
    
    override init() {
        super.init()
        //TO-DO: Make it so we don't have to hard code these
        hardCodeSections()
    }
    
    //TO-DO: Make it so we don't have to hard code these
    func hardCodeSections(){
        //Make temp crops
        let crop1 = Crop(datePlanted: "2016-01-01",dateHarvested: "2016-01-01",notes: ["test"],variety: "Wheat")
        let crop2 = Crop(datePlanted: "2016-01-01",dateHarvested: "2016-01-01",notes: ["test2"],variety: "Corn")
        let crop3 = Crop(datePlanted: "2016-01-01",dateHarvested: "2016-01-01",notes: ["test3"],variety: "Barley")
        let crop4 = Crop(datePlanted: "2016-01-01",dateHarvested: "2016-01-01",notes: ["test4"],variety: "Garlic")
        //Make temp beds
        let bed1 = Bed(id: 1, currentCrop: "Corn", cropHistory: CropHistory(numCrops: 1,crops: [crop1]))
        let bed2 = Bed(id: 2, currentCrop: "Wheat", cropHistory: CropHistory(numCrops: 2,crops: [crop1,crop2]))
        let bed3 = Bed(id: 3, currentCrop: "Garlic", cropHistory: CropHistory(numCrops: 3,crops: [crop3,crop1,crop2]))
        let bed4 = Bed(id: 4, currentCrop: "Barley", cropHistory: CropHistory(numCrops: 4,crops: [crop1,crop4,crop2,crop3]))
        //Make temp sects
        let sect1 = Section(id: 1,beds: [bed1],numBeds: 1)
        let sect2 = Section(id: 2,beds: [bed1,bed2],numBeds: 2)
        let sect3 = Section(id: 3,beds: [bed1,bed2,bed3],numBeds: 3)
        let sect4 = Section(id: 4,beds: [bed1,bed2,bed3,bed4],numBeds: 4)
        sections = [sect1,sect2,sect3,sect4]
    }
    
    //Return section list
    func getSects() -> [Section]{
        return sections
        
    }

}
