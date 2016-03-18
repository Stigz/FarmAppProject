//
//  DatabaseManager.swift
//  FarmApp
//
//  Created by Nicolas Lanker on 3/18/16.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit
import Firebase
class DatabaseManager: NSObject {
    
    override init() {
        super.init()
    }
    
    func saveToDatabase () {
        let ref = Firebase(url: "https://glowing-torch-4644.firebaseio.com")
        let beds = LibraryAPI.sharedInstance.getBedsForSect(1)
        let sects = LibraryAPI.sharedInstance.getSects()
        print(beds)
        print(sects)
        ref.childByAutoId()
    }
    
    

}
