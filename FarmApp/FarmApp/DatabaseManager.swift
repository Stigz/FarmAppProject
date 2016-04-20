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
        for section in LibraryAPI.sharedInstance.getSects() {
            let sectionRef = sectionsRef.childByAppendingPath("Section_\(section.id)")
            sectionRef.setValue(section.encodeForDB())
            let bedsRef = sectionRef.childByAppendingPath("Beds")
            for bed in section.beds {
                let bedRef = bedsRef.childByAutoId()
                bedRef.setValue(bed.encodeForDB())
            }
        }
    }
    
    func savePlantsToDB(){
        let plantsRef = ref.childByAppendingPath("Plants_Test")
        for plant in LibraryAPI.sharedInstance.getAllPossiblePlants(){
            let plantRef = plantsRef.childByAppendingPath("\(plant.name)")
            plantRef.setValue(plant.encodeForDB())
            let varietiesRef = plantRef.childByAppendingPath("Varieties")
            for variety in plant.varieties{
                let varietyRef = varietiesRef.childByAutoId()
                varietyRef.setValue(variety.encodeForDB())
            }
        }
    }

    
}
