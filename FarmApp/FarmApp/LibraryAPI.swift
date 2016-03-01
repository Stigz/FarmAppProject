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
    
    override init() {
        persistencyManager = PersistencyManager()
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
    
    //Ask persistency manager to harvest crop
    func harvestCropForBed(sectNum: Int, bedNum: Int, dateHarvested: Date){
        persistencyManager.harvestCropForBed(sectNum, bedNum: bedNum, dateHarvested: dateHarvested)
    }
    
    //Ask persistency manager to add crop
    func addCrop(crop : Crop, bedNum : Int, sectNum : Int){
        persistencyManager.addCrop(crop, bedNum: bedNum, sectNum: sectNum)
    }

}