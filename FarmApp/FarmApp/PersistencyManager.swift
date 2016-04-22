//
//  PersistencyManager.swift
//  FarmApp
//
//  Created by Patrick Little on 10/02/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit
import Firebase

class PersistencyManager: NSObject {
    
    private var sections = [Section]()
    private var allPossiblePlants = [Plant]()



    
    override init() {
        super.init()
        //TO-DO: Make it so we don't have to hard code these
        //hardCodeSections()
    }
    
    //TO-DO: Make it so we don't have to hard code these
//   
//    func hardCodeSections(){
//    
//        let plant1 = Plant(name: "Wheat",bestSeasons: ["Winter"],notes: "",varieties: [], weight: 50)
//        let plant2 = Plant(name: "Corn",bestSeasons: ["Fall"],notes: "",varieties: [], weight: 0)
//        let plant3 = Plant(name: "Barley",bestSeasons: ["Summer"],notes: "",varieties: [], weight: 60)
//        let plant4 = Plant(name: "Garlic",bestSeasons: ["Spring"],notes: "",varieties: [], weight: 0)
//
//        let variety1 = Variety(name: "Golden", bestSeasons: ["Winter"], notes: "", bedHistory: [], plant: plant1, varietyWeight: 50)
//        let variety2 = Variety(name: "Red", bestSeasons: ["Fall"], notes: "", bedHistory: [], plant: plant2, varietyWeight: 0)
//        let variety3 = Variety(name: "Extra Spicy", bestSeasons: ["Spring"], notes: "", bedHistory: [], plant: plant3, varietyWeight: 60)
//        let variety4 = Variety(name: "Vampire Repellant", bestSeasons: ["Summer"], notes: "", bedHistory: [], plant: plant4, varietyWeight: 0)
//      
//
//       
//        variety1.varietyWeight = 50
//        variety3.varietyWeight = 60
//        //Setup plant varieties
//
//        plant1.varieties.append(variety1)
//        plant2.varieties.append(variety2)
//        plant3.varieties.append(variety3)
//        plant4.varieties.append(variety4)
//        allPossiblePlants = [plant1,plant2,plant3,plant4]
//        //Make temp crops
//        let crop1 = Crop(datePlanted: Date(year: 2016,month: 1,day: 1),datesHarvested: [Date(year: 2016,month: 1,day: 1),Date(year: 2016,month: 1,day: 1)],notes: "test",variety: variety1, finalHarvest: Date(year: 2016,month: 1,day: 1), harvestWeights: [10,10], totalWeight: 20, varietyName: variety1.name)
//        let crop2 = Crop(datePlanted: Date(year: 2016,month: 1,day: 1),datesHarvested: [],notes: "test2",variety: variety2, finalHarvest: Date(year: 2016,month: 1,day: 1), harvestWeights: [], totalWeight: 0, varietyName : variety2.name)
//        let crop3 = Crop(datePlanted: Date(year: 2016,month: 1,day: 1),datesHarvested: [],notes: "test3",variety: variety3, finalHarvest: Date(year: 2016,month: 1,day: 1), harvestWeights: [], totalWeight: 0, varietyName : variety3.name)
//        let crop4 = Crop(datePlanted: Date(year: 2016,month: 1,day: 1),datesHarvested: [],notes: "test4",variety: variety4, finalHarvest: Date(year: 2016,month: 1,day: 1), harvestWeights: [], totalWeight: 0, varietyName : variety4.name)
//        let crop5 = Crop(datePlanted: Date(year: 2016,month: 1,day: 1),datesHarvested: [],notes: "test5",variety: variety4, finalHarvest: Date(year: 2016,month: 1,day: 1), harvestWeights: [], totalWeight: 0, varietyName : variety4.name)
//        //Make temp beds
//        let bed1 = Bed(id: 1, currentCrop: nil, cropHistory: CropHistory(numCrops: 1,crops: [crop1]), sectID : 0)
//        let bed2 = Bed(id: 2, currentCrop: crop1, cropHistory: CropHistory(numCrops: 2,crops: [crop3,crop2]), sectID :0)
//        let bed3 = Bed(id: 3, currentCrop: crop4, cropHistory: CropHistory(numCrops: 3,crops: [crop3,crop1,crop2]), sectID : 0)
//        let bed4 = Bed(id: 4, currentCrop: crop3, cropHistory: CropHistory(numCrops: 4,crops: [crop1,crop4,crop2,crop5]), sectID : 0)
//
//        //Make temp sects
//        let sect1 = Section(id: 1,beds: [bed1],numBeds: 1, sectionWeight: 0)
//        
//        let sect2 = Section(id: 2,beds: [bed1,bed2],numBeds: 2, sectionWeight: 0)
//        let sect3 = Section(id: 3,beds: [bed1,bed2,bed3],numBeds: 3, sectionWeight: 0)
//        let sect4 = Section(id: 4,beds: [bed1,bed2,bed3,bed4],numBeds: 4, sectionWeight: 0)
//
//        
//        sections = [sect1,sect2,sect3,sect4]
////        
////        let ref = Firebase(url: "https://glowing-torch-4644.firebaseio.com")
////        let sectionsRef = ref.childByAppendingPath("SectionsTest")
////        for section in sections {
////            let sectionRef = sectionsRef.childByAppendingPath("Section_\(section.id)")
////            sectionRef.setValue(section.encodeForDB())
////            let bedsRef = sectionRef.childByAppendingPath("Beds")
////            for bed in section.beds {
////                let bedRef = bedsRef.childByAutoId()
////                bedRef.setValue(bed.encodeForDB())
////            }
////        }
//
//        
//
//        
//        //Set bed histories
//        variety1.bedHistory.append(BedHistory(date: Date(year: 2016,month: 1,day: 1),sectID: bed1.sectID, bedID: bed1.id))
//        variety2.bedHistory.append(BedHistory(date: Date(year: 2016,month: 1,day: 1),sectID: bed2.sectID, bedID: bed2.id))
//        variety1.bedHistory.append(BedHistory(date: Date(year: 2016,month: 1,day: 1),sectID: bed3.sectID, bedID: bed3.id))
//        variety1.bedHistory.append(BedHistory(date: Date(year: 2016,month: 1,day: 1),sectID: bed4.sectID, bedID: bed4.id))
//    }

    
    //Return section list
    func getSects() -> [Section]{
        return sections
        
    }
    
    func setSections(sections : [Section]){
        self.sections = sections
    }
    
    func setPlants(plants : [Plant]){
        self.allPossiblePlants = plants
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
    func finalHarvestForBed(sectNum: Int, bedNum: Int, dateHarvested: Date, harvestWeight: Int){
        let harvestBed = getBed(sectNum, bedNum: bedNum)
        harvestBed.currentCrop!.finalHarvest = dateHarvested
        harvestBed.currentCrop!.totalWeight=harvestBed.currentCrop!.totalWeight+harvestWeight
        harvestBed.currentCrop!.variety.varietyWeight=harvestBed.currentCrop!.variety.varietyWeight+harvestWeight
        harvestBed.currentCrop!.variety.plant.plant_weight=harvestBed.currentCrop!.variety.plant.plant_weight+harvestWeight
        harvestBed.cropHistory.crops.insert(harvestBed.currentCrop!, atIndex: 0)
        harvestBed.cropHistory.numCrops!++
        harvestBed.currentCrop = nil
    }

    //Harvest a crop in a given bed
    func harvestCropForBed(sectNum: Int, bedNum: Int, dateHarvested: Date, harvestWeight: Int){
        let harvestBed = getBed(sectNum, bedNum: bedNum)
        harvestBed.currentCrop!.datesHarvested.append(dateHarvested)
        harvestBed.currentCrop!.harvestWeights.append(harvestWeight)
        harvestBed.currentCrop!.totalWeight=harvestBed.currentCrop!.totalWeight+harvestWeight
        harvestBed.currentCrop!.variety.varietyWeight=harvestBed.currentCrop!.variety.varietyWeight+harvestWeight
        harvestBed.currentCrop!.variety.plant.plant_weight=harvestBed.currentCrop!.variety.plant.plant_weight+harvestWeight
        
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
        allPossiblePlants.sortInPlace({ $0.name.localizedCaseInsensitiveCompare($1.name) == .OrderedAscending})
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
    
    //Return list of all plants currently planted in the farm
    func getCurrentPlants() -> [Plant]{
        var thePlants : [Plant] = []
        for sect in getSects() {
            for bed in sect.beds {
                if let theCrop = bed.currentCrop{
                    if !thePlants.contains(theCrop.variety.plant) {
                        thePlants.append(theCrop.variety.plant)
                    }
                }
            }
        }
        return thePlants
    }
    
    //Updates the notes for a given plant
    func updateNotesForPlant(plant: String, notes : String){
        for plants in getAllPossiblePlants() {
            if plants.name == plant {
                plants.notes = notes
            }
        }
    }
    
    //Updates the notes of a given variety
    func updateNotesForVariety(plant : String, variety : String, notes: String){
        for plants in getAllPossiblePlants() {
            if plants.name == plant{
                for varietys in plants.varieties{
                    if varietys.name == variety{
                        varietys.notes = notes
                    }
                }
            }
        }
    }
    
    func addPlant(plantName: String){
        let newPlant = Plant(name: plantName, bestSeasons: [], notes: "", varieties: [], weight: 0)
        allPossiblePlants.append(newPlant)
        
    }
    
    func addVariety(vName: String, plant: Plant){
          let nVariety = Variety(name: vName, bestSeasons: [], notes: "", bedHistory: [], plant: plant, varietyWeight: 0)
        //do i need the persistent plant
        
        let persistentPlant = allPossiblePlants[allPossiblePlants.indexOf(plant)!]
        persistentPlant.varieties.append(nVariety)
        
        
    }
    
    func addSection(){
        let newSect = Section(id: sections.count + 1, beds: [], numBeds: 0, sectionWeight: 0)
        sections.append(newSect)
        
    }
    
    func addBed(bedID: Int, sectID: Int){
        let newBed = Bed(id: bedID, currentCrop: nil, cropHistory: CropHistory(numCrops: 0,crops: []), sectID: sectID)

        sections[sectID].beds.append(newBed)
    }
    
    func updateVarietyBedHistory(variety :Variety, bedNum: Int, sectNum: Int, date: Date){
        let bed = sections[sectNum - 1].beds[bedNum - 1]
        let bedHistory = BedHistory(date: date, sectID: bed.sectID, bedID: bed.id)
        var persistentVariety = variety
        for plant in allPossiblePlants{
            if(plant.varieties.indexOf(variety) != 0){
                persistentVariety = plant.varieties[plant.varieties.indexOf(variety)!]
            }
        }
        persistentVariety.bedHistory.append(bedHistory)
        
        
    }
    
    func getTotalWeight() -> Float{
        var totalWeight : Float = 0
        for i in 1...sections.count{
            if(sections[i].sectionWeight != nil){
            totalWeight +=  sections[i].sectionWeight as! Float
            }
        }
        return totalWeight
    }
    
    func deleteSection(id : Int){
        for i in id...sections.count - 1 {
            sections[i].id = i
            for bed in sections[i].beds{
                bed.sectID = i
            }
        }
        sections.removeAtIndex(id)
    }
    
    func deleteBed(sectNum :Int, bedNum :Int){
        for i in bedNum...sections[sectNum - 1].beds.count - 1 {
            sections[sectNum - 1].beds[i].id = i
        }
        sections[sectNum - 1].beds.removeAtIndex(bedNum)
    }
    
    func editPlantName(plant : Plant, newName :String){
        let editIndex = allPossiblePlants.indexOf(plant)
        allPossiblePlants[editIndex!].name = newName
    }
    
    func editVarietyName(variety : Variety, newName: String){
        let plantIndex = allPossiblePlants.indexOf(variety.plant)
        let varietyIndex = allPossiblePlants[plantIndex!].varieties.indexOf(variety)
        allPossiblePlants[plantIndex!].varieties[varietyIndex!].name = newName
    }
    
}
