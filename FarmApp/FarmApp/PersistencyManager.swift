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
        let bed1 = Bed(id: 1, currentCrop: "Corn", numCropsInHistory: 1, cropHistory: ["More Corn A Year Ago"])
        let bed2 = Bed(id: 2, currentCrop: "Wheat", numCropsInHistory: 2, cropHistory: ["Corn A Year Ago", "Wheat 2y ago"])
        let bed3 = Bed(id: 3, currentCrop: "Garlic", numCropsInHistory: 3, cropHistory: ["Corn A Year Ago", "Wheat 2y ago", "Garlic 3y ago"])
        let bed4 = Bed(id: 4, currentCrop: "Barley", numCropsInHistory: 4, cropHistory: ["Corn A Year Ago", "Wheat 2y ago", "Garlic 3y ago", "Barley 4y ago"])
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
