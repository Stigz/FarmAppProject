//
//  LibraryAPI.swift
//  FarmApp
//
//  Created by Patrick Little on 9/02/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import Foundation

class LibraryAPI: NSObject {
    
    override init() {
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
    
    func getBeds() -> [String]{
        return ["1","2","3","4","5"]
    }

}
