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


    private var allPossiblePlants = [Plant]()
    
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
        
        plant1.plant_weight = 50
        plant3.plant_weight = 60

        let variety1 = Variety(name: "Golden", bestSeasons: [], notes: [], bedHistory: BedHistory(), plant: plant1)
        let variety2 = Variety(name: "Red", bestSeasons: [], notes: [], bedHistory: BedHistory(), plant: plant2)
        let variety3 = Variety(name: "Extra Spicy", bestSeasons: [], notes: [], bedHistory: BedHistory(), plant: plant3)
        let variety4 = Variety(name: "Vampire Repellant", bestSeasons: [], notes: [], bedHistory: BedHistory(), plant: plant4)
       
        variety1.varietyWeight = 50
        variety1.varietyWeight = 40
        //Setup plant varieties

        plant1.varieties.append(variety1)
        plant2.varieties.append(variety2)
        plant3.varieties.append(variety3)
        plant4.varieties.append(variety4)
        allPossiblePlants = [plant1,plant2,plant3,plant4]
        //Make temp crops
        let crop1 = Crop(datePlanted: Date(year: 2016,month: 1,day: 1),datesHarvested: [],notes: "test",variety: variety1, finalHarvest: Date(year: 2016,month: 1,day: 1))
        let crop2 = Crop(datePlanted: Date(year: 2016,month: 1,day: 1),datesHarvested: [],notes: "test2",variety: variety2, finalHarvest: Date(year: 2016,month: 1,day: 1))
        let crop3 = Crop(datePlanted: Date(year: 2016,month: 1,day: 1),datesHarvested: [],notes: "test3",variety: variety3, finalHarvest: Date(year: 2016,month: 1,day: 1))
        let crop4 = Crop(datePlanted: Date(year: 2016,month: 1,day: 1),datesHarvested: [],notes: "test4",variety: variety4, finalHarvest: Date(year: 2016,month: 1,day: 1))
        let crop5 = Crop(datePlanted: Date(year: 2016,month: 1,day: 1),datesHarvested: [],notes: "test5",variety: variety4, finalHarvest: Date(year: 2016,month: 1,day: 1))
        //Make temp beds
        let bed1 = Bed(id: 1, currentCrop: nil, cropHistory: CropHistory(numCrops: 1,crops: [crop1]))
        let bed2 = Bed(id: 2, currentCrop: crop1, cropHistory: CropHistory(numCrops: 2,crops: [crop3,crop2]))
        let bed3 = Bed(id: 3, currentCrop: crop4, cropHistory: CropHistory(numCrops: 3,crops: [crop3,crop1,crop2]))
        let bed4 = Bed(id: 4, currentCrop: crop3, cropHistory: CropHistory(numCrops: 4,crops: [crop1,crop4,crop2,crop5]))
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
    
    //Returns current crop for a bed
    func getCurrentCropForBed(sectNum : Int, bedNum : Int) -> Crop?{
        return getBed(sectNum, bedNum: bedNum).currentCrop
    }
    
    //Returns crop at a history index
    func getCropFromHistory(sectNum: Int, bedNum : Int, index : Int) -> Crop{
        return getBed(sectNum, bedNum: bedNum).cropHistory.crops[index]
    }
    
    //Harvest a crop for the final time
    func finalHarvestForBed(sectNum: Int, bedNum: Int, dateHarvested: Date){
        let harvestBed = getBed(sectNum, bedNum: bedNum)
        harvestBed.currentCrop!.finalHarvest = dateHarvested
        harvestBed.cropHistory.crops.insert(harvestBed.currentCrop!, atIndex: 0)
        harvestBed.cropHistory.numCrops!++
        harvestBed.currentCrop = nil
    }

    //Harvest a crop in a given bed
    func harvestCropForBed(sectNum: Int, bedNum: Int, dateHarvested: Date){
        let harvestBed = getBed(sectNum, bedNum: bedNum)
        harvestBed.currentCrop!.datesHarvested.append(dateHarvested)
    }
    
    //Return list of beds for a section
    func getBedsForSect(sectNum: Int) -> [Bed]{
        return sections[sectNum-1].beds
    }
    
    //Return the requested bed
    func getBed(sectNum: Int, bedNum: Int) -> Bed{
        return sections[sectNum-1].beds[bedNum-1]
    }
    
    //Return list of all plants
    func getAllPossiblePlants() -> [Plant]{
        return allPossiblePlants
    }
    
    //Adds a crop to the specified bed
    func addCrop(crop : Crop, bedNum : Int, sectNum : Int){
        let bed = getBed(sectNum, bedNum: bedNum)
        bed.currentCrop = crop
    }
    
    //Updates the notes for the current crop in a bed
    func updateNotesForCurrentCrop(sectNum: Int, bedNum : Int, notes: String){
        getCurrentCropForBed(sectNum, bedNum: bedNum)!.notes=notes
    }
    
    //Updates the notes for a crop in a history
    func updateNotesForCropInHistory(sectNum: Int, bedNum : Int, index: Int, notes: String){
        getCropFromHistory(sectNum, bedNum: bedNum, index: index).notes=notes
    }
    
    func getTotalWeight() -> Int{
        var totalWeight = 0
        for i in 1...sections.count{
            if(sections[i].sectionWeight != nil){
            totalWeight +=  sections[i].sectionWeight
            }
        }
        return totalWeight
    }
}
