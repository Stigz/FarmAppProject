//
//  LibraryAPI.swift
//  FarmApp
//
//  Created by Patrick Little on 9/02/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import Foundation

class LibraryAPI: NSObject {
    
    private let persistencyManager : PersistencyManager
    private let databaseManager : DatabaseManager
    
    override init() {
        persistencyManager = PersistencyManager()
        databaseManager = DatabaseManager()
        super.init()
    }
    
    //Create class variable as computed type
    // This is so you don't have to instantiate
    // LibraryAPI to call it
    class var sharedInstance: LibraryAPI {
        //Struct called singleton
        struct Singleton {
            //Static -- only exists once -- never called
            //again once initialized
            static let instance = LibraryAPI()
        }
        //4 Return computed type property
        return Singleton.instance
    }
    
    
    //Ask persistency manager for sections
    func getSects() -> [Section]{
        return persistencyManager.getSects()
    }
    
    func setPlants(plants: [Plant]){
        persistencyManager.setPlants(plants)
    }

    //Ask persistency manager for a crop
    func getCurrentCropForBed(sectNum : Int, bedNum : Int) -> Crop?{
        return persistencyManager.getCurrentCropForBed(sectNum, bedNum: bedNum)
    }
    

    //Ask persistency manager for a crop from a history
    func getCropFromHistory(sectNum: Int, bedNum : Int, index : Int) -> Crop{
        return persistencyManager.getCropFromHistory(sectNum, bedNum: bedNum, index: index)
    }

    //Ask persistency manager for a list of all plants
    func getAllPossiblePlants() -> [Plant]{
        return persistencyManager.getAllPossiblePlants()
    }
    
    //Ask persistency manager for a bed list of a sect
    func getBedsForSect(sectNum: Int) -> [Bed]{
            return persistencyManager.getBedsForSect(sectNum)
    }
    
    //Ask persistency manager for a given bed
    func getBed(sectNum: Int, bedNum: Int) -> Bed{
        return persistencyManager.getBed(sectNum, bedNum: bedNum)
    }
    
    //Ask persistency manager to do final harvest
    func finalHarvestForBed(sectNum: Int, bedNum: Int, dateHarvested: Date, harvestWeight: Int){
        persistencyManager.finalHarvestForBed(sectNum, bedNum: bedNum, dateHarvested: dateHarvested, harvestWeight: harvestWeight)
    }
    
    //Ask persistency manager to harvest crop
    func harvestCropForBed(sectNum: Int, bedNum: Int, dateHarvested: Date, harvestWeight: Int){
        persistencyManager.harvestCropForBed(sectNum, bedNum: bedNum, dateHarvested: dateHarvested, harvestWeight: harvestWeight)
    }

    
    
    //Ask persistency manager to add crop
    func addCrop(crop : Crop, bedNum : Int, sectNum : Int){
        persistencyManager.addCrop(crop, bedNum: bedNum, sectNum: sectNum)
    }
    
    //Ask Manager to update the notes for the current crop in a bed
    func updateNotesForCurrentCrop(sectNum: Int, bedNum : Int, notes: String){
        persistencyManager.updateNotesForCurrentCrop(sectNum, bedNum: bedNum, notes: notes)
    }
    
    //Ask manager to update the notes for a crop in a history
    func updateNotesForCropInHistory(sectNum: Int, bedNum : Int, index: Int, notes: String){
        persistencyManager.updateNotesForCropInHistory(sectNum, bedNum: bedNum, index: index, notes: notes)
    }
    
    //Ask manager for list of all currently planted plants
    func getCurrentPlants() -> [Plant]{
        return persistencyManager.getCurrentPlants()
    }
    
    //Ask to update variety notes
    func updateNotesForVariety(plant : String, variety : String, notes: String){
        persistencyManager.updateNotesForVariety(plant, variety: variety, notes: notes)
    }
    
    //Ask to update plant notes
    func updateNotesForPlant(plant: String, notes : String){
        persistencyManager.updateNotesForPlant(plant, notes: notes)
    }
    
    func addPlant(plantName: String){
        persistencyManager.addPlant(plantName)
    }
    
    func addVariety(name: String, plant: Plant){
        persistencyManager.addVariety(name, plant: plant)
    }
    
    func addSection(){
        persistencyManager.addSection()
    }
    
    func addBed(bedID: Int, sectID: Int){
        persistencyManager.addBed(bedID, sectID: sectID)
    }
    
    func updateVarietyBedHistory(variety :Variety, bedNum: Int, sectNum: Int, date: Date){
        persistencyManager.updateVarietyBedHistory(variety, bedNum: bedNum, sectNum: sectNum, date: date)
    }
    
    func deleteSection(id: Int){
        persistencyManager.deleteSection(id)
    }
    
    func deleteBed(SectNum: Int, BedNum: Int){
        persistencyManager.deleteBed(SectNum, bedNum: BedNum)
    }
    
    func editPlantName(plant :Plant, newName :String){
        persistencyManager.editPlantName(plant, newName: newName)
    }
    
    func editVarietyName(variety: Variety, newName: String){
        persistencyManager.editVarietyName(variety, newName: newName)
    }
    
    func setSections(sections : [Section]){
        persistencyManager.setSections(sections)
    }

    func saveAllDataToDB(){
        databaseManager.saveSectionsToDB()
        databaseManager.savePlantsToDB()
    }
    

}