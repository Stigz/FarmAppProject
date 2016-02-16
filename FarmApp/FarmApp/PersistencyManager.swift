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
        let sect1 = Section(id: 1,beds: ["Bed 1"],numBeds: 1)
        let sect2 = Section(id: 2,beds: ["Bed 1","Bed 2"],numBeds: 2)
        let sect3 = Section(id: 3,beds: ["Bed 1","Bed 2","Bed 3"],numBeds: 3)
        let sect4 = Section(id: 4,beds: ["Bed 1","Bed 2","Bed 3","Bed 4"],numBeds: 4)
        sections = [sect1,sect2,sect3,sect4]
    }
    
    //Return section list
    func getSects() -> [Section]{
        return sections
        
    }

}
