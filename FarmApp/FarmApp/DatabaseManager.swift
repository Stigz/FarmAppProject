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
    
    func addCropToDatabase(datePlanted: Date, datesHarvested: [Date], notes : String?, variety: Variety, finalHarvest : Date?){
        let ref = Firebase(url: "https://glowing-torch-4644.firebaseio.com")
        var crop = LibraryAPI.sharedInstance.getCurrentCropForBed(3, bedNum:3)
        var cropForDatabase = ["DatePlanted": String(crop?.datePlanted), "DateHarvested": String(crop?.datesHarvested), "Notes": String(crop?.notes), "Variety": String(crop?.variety), "FinalHarvest": String(crop?.finalHarvest)]
        let postRef = ref.childByAppendingPath("Crop")
        let post1Ref = postRef.childByAutoId()
        post1Ref.setValue(cropForDatabase)
    }
    
    func updateNotesForCrop(sectNum: Int, bedNum: Int, notes: String){
        let ref = Firebase(url: "https://glowing-torch-4644.firebaseio.com")
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value.objectForKey("Crop"))
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        
        var cropForDatabase = ["SectNum": sectNum, "BedNum": bedNum, "Notes": notes]
        let postRef = ref.childByAppendingPath("Crop")
        let post1Ref = postRef.childByAutoId()
        var cropID = post1Ref.key
        post1Ref.setValue(cropForDatabase)
    }
    
    func getSects(){
        let ref = Firebase(url: "https://glowing-torch-4644.firebaseio.com")
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value.objectForKey("Sections"))
            var Sects = snapshot.value.objectForKey("Sections")
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        //var cropForDatabase = ["SectNum": sectNum, "BedNum": bedNum, "Notes": notes]
        let postRef = ref.childByAppendingPath("Sections")
        let post1Ref = postRef.childByAutoId()
        var cropID = post1Ref.key
        //post1Ref.setValue(cropForDatabase)
    }
    func createSects(sections: [Section]) {
        let ref = Firebase(url: "https://glowing-torch-4644.firebaseio.com")
        let postRef = ref.childByAppendingPath("Sections")
        var i : Int
        for i in 0...(sections.count-1){
            postRef.childByAutoId().setValue(String(sections[i].id))
        }
    }
    
    func saveToDatabase () {
        //let ref = Firebase(url: "https://glowing-torch-4644.firebaseio.com")
      /*
        var beds = LibraryAPI.sharedInstance.getBed(1, bedNum: 1)
        var sects = LibraryAPI.sharedInstance.getSects()
        var section1 = LibraryAPI.sharedInstance.getSection(1)
        
        var bedsForDatabase = String(beds.id)
        var sectsForDatabase = ["SectID": sects.count, "Beds": bedsForDatabase]

        var crop = LibraryAPI.sharedInstance.getCurrentCropForBed(3, bedNum:3)
        var cropForDatabase = ["DatePlanted": String(crop?.notes)]
        print(cropForDatabase)
         "CurrentCrop": beds.cropHistory.crops.
        
        print(sectsForDatabase)
        ref.setValue(bedsForDatabase)
       
        let postRef = ref.childByAppendingPath("Sections")
        
        let post1Ref = postRef.childByAutoId()
        let post2Ref = postRef.childByAutoId()
       
       

        
        // Get a reference to our posts
        let ref = Firebase(url:"https://dazzling-inferno-9759.firebaseio.com")
        // Attach a closure to read the data at our posts reference
        ref.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value.objectForKey("Harvest"))
            }, withCancelBlock: { error in
                print(error.description)
        }) */
    }
    
    

}
