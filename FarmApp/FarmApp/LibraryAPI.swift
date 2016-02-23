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

}
