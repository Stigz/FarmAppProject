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
        //Make temp plants
        let plant1 = Plant(name: "Wheat",bestSeasons: [],notes: [],varieties: [])
        let plant2 = Plant(name: "Corn",bestSeasons: [],notes: [],varieties: [])
        let plant3 = Plant(name: "Barley",bestSeasons: [],notes: [],varieties: [])
        let plant4 = Plant(name: "Garlic",bestSeasons: [],notes: [],varieties: [])
        //Make temp varieties
        /*let variety1 = Variety(name: "Wheat", bestSeasons: [], notes: [], bedHistory: BedHistory(), plant: plant1)
        let variety2 = Variety(name: "Corn", bestSeasons: [], notes: [], bedHistory: BedHistory(), plant: plant2)
        let variety3 = Variety(name: "Barley", bestSeasons: [], notes: [], bedHistory: BedHistory(), plant: plant3)
        let variety4 = Variety(name: "Garlic", bestSeasons: [], notes: [], bedHistory: BedHistory(), plant: plant4)*/
        //Make temp crops
        let crop1 = Crop(datePlanted: Date(year: 2016,month: 1,day: 1),dateHarvested: Date(year: 2016,month: 1,day: 1),notes: ["test"],plant: plant1)
        let crop2 = Crop(datePlanted: Date(year: 2016,month: 1,day: 1),dateHarvested: Date(year: 2016,month: 1,day: 1),notes: ["test2"],plant:
            plant2)
        let crop3 = Crop(datePlanted: Date(year: 2016,month: 1,day: 1),dateHarvested: Date(year: 2016,month: 1,day: 1),notes: ["test3"],plant:
            plant3)
        let crop4 = Crop(datePlanted: Date(year: 2016,month: 1,day: 1),dateHarvested: Date(year: 2016,month: 1,day: 1),notes: ["test4"],plant:
            plant4)
        //Make temp beds
        let bed1 = Bed(id: 1, currentCrop: crop2, cropHistory: CropHistory(numCrops: 1,crops: [crop1]))
        let bed2 = Bed(id: 2, currentCrop: crop1, cropHistory: CropHistory(numCrops: 2,crops: [crop1,crop2]))
        let bed3 = Bed(id: 3, currentCrop: crop4, cropHistory: CropHistory(numCrops: 3,crops: [crop3,crop1,crop2]))
        let bed4 = Bed(id: 4, currentCrop: crop3, cropHistory: CropHistory(numCrops: 4,crops: [crop1,crop4,crop2,crop3]))
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
