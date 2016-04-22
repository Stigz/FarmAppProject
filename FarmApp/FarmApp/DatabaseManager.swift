//
//  DatabaseManager.swift
//  FarmApp
//
//  Created by Patrick Little on 4/19/16.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit
import Firebase

class DatabaseManager: NSObject {
    
    let ref = Firebase(url: "https://glowing-torch-4644.firebaseio.com")
    
    func saveSectionsToDB(){
        let sectionsRef = ref.childByAppendingPath("Sections_Test")
        sectionsRef.setValue(nil)
        for section in LibraryAPI.sharedInstance.getSects() {
            let sectionRef = sectionsRef.childByAppendingPath("Section_\(section.id)")
            sectionRef.setValue(section.encodeForDB())
        }
    }
    
    func savePlantsToDB(){
        let plantsRef = ref.childByAppendingPath("Plants_Test")
        plantsRef.setValue(nil)
        for plant in LibraryAPI.sharedInstance.getAllPossiblePlants(){
            let plantRef = plantsRef.childByAppendingPath("\(plant.name)")
            plantRef.setValue(plant.encodeForDB())
        }
    }

    
}
