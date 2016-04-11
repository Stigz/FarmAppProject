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
    
    private var sectionArray = [Section]()
    
    private var allPossiblePlants = [Plant]()
    
    var sectionFor: [Section] = [Section]()
    
    override init() {
        super.init()
        
        //getSects()
        //mergeFlatDataSectBeds()
        getUsingQuery()
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
            //var cropArray = 
            print(snapshot.value.objectForKey("Crop"))
            }, withCancelBlock: { error in
                print(error.description)
        })
        
       // let crop1 = Crop(datePlanted: Date(year: 2016,month: 1,day: 1),datesHarvested: [],notes: "test",variety: variety1, finalHarvest: Date(year: 2016,month: 1,day: 1))
        
        var cropForDatabase = ["SectNum": sectNum, "BedNum": bedNum, "Notes": notes]
        let postRef = ref.childByAppendingPath("Crop")
        let post1Ref = postRef.childByAutoId()
        var cropID = post1Ref.key
        post1Ref.setValue(cropForDatabase)
        //var cropForDatabase = ["SectNum": sectNum, "BedNum": bedNum, "Notes": notes]
       // let postRef = ref.childByAppendingPath("Sections")
        //let post1Ref = postRef.childByAutoId()
        //var cropID = post1Ref.key
        //post1Ref.setValue(cropForDatabase)
    }
    
    func getSects(){
        var sectionsRef: Firebase!
        sectionsRef = Firebase(url: "https://glowing-torch-4644.firebaseio.com/Sections")
        
        
        //Make temp plants
        let plant1 = Plant(name: "Wheat",bestSeasons: [],notes: [],varieties: [])
        let plant2 = Plant(name: "Corn",bestSeasons: [],notes: [],varieties: [])
        let plant3 = Plant(name: "Barley",bestSeasons: [],notes: [],varieties: [])
        let plant4 = Plant(name: "Garlic",bestSeasons: [],notes: [],varieties: [])
        
        plant1.plant_weight = 50
        plant3.plant_weight = 60
        
        let variety1 = Variety(name: "Golden", bestSeasons: [], notes: [], bedHistory: BedHistory(), plant: plant1)
        let variety2 = Variety(name: "Red", bestSeasons: [], notes: [], bedHistory: BedHistory(), plant: plant2)
        let variety3 = Variety(name: "Extra Spicy", bestSeasons: [], notes: [], bedHistory: BedHistory(), plant: plant3)
        let variety4 = Variety(name: "Vampire Repellant", bestSeasons: [], notes: [], bedHistory: BedHistory(), plant: plant4)
        
        variety1.varietyWeight = 50
        variety1.varietyWeight = 40
        //Setup plant varieties
        
        plant1.varieties.append(variety1)
        plant2.varieties.append(variety2)
        plant3.varieties.append(variety3)
        plant4.varieties.append(variety4)
        allPossiblePlants = [plant1,plant2,plant3,plant4]
        //Make temp crops
        let crop1 = Crop(datePlanted: Date(year: 2016,month: 1,day: 1),datesHarvested: [],notes: "test",variety: variety1, finalHarvest: Date(year: 2016,month: 1,day: 1))
        let crop2 = Crop(datePlanted: Date(year: 2016,month: 1,day: 1),datesHarvested: [],notes: "test2",variety: variety2, finalHarvest: Date(year: 2016,month: 1,day: 1))
        let crop3 = Crop(datePlanted: Date(year: 2016,month: 1,day: 1),datesHarvested: [],notes: "Hello World",variety: variety3, finalHarvest: Date(year: 2016,month: 1,day: 1))
        let bed2 = Bed(id: 2, currentCrop: crop1, cropHistory: CropHistory(numCrops: 2,crops: [crop3,crop2]))
        
        
        var section: [Int]
        var sections: AnyObject
        
        sectionFor = []
        
        
        sectionsRef.observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
            print("Snaphots:\(snapshot.value)")
            //var beds = snapshot.value["Beds"] as! NSDictionary
            var id = snapshot.value["id"] as? String
            var numBeds = snapshot.value["numBeds"] as! String
            
            sectionsRef.childByAppendingPath("Beds")
            var idAsInt =  NSNumberFormatter().numberFromString(id!)?.integerValue
            var numBedsInt =  NSNumberFormatter().numberFromString(numBeds)?.integerValue
            self.sectionFor = [Section(id: idAsInt!, beds: [bed2], numBeds: numBedsInt!)]
            //sections.append(sectionTest)
            
            //LibraryAPI.sharedInstance.setSections(sectionFor)
            
            
            print("Section for : \(self.sectionFor)")
            
            // let section = Section(id: id,beds,numBeds)
            
            //self.sectionArray.append(section)
        })
        
        print("setion for : \(sectionFor)")
        
        //sectionFor = [Section(id: , beds: [bed2], numBeds: 1)]
        /*
        // *** STEP 2: SETUP FIREBASE
        sectionsRef = Firebase(url: "https://glowing-torch-4644.firebaseio.com/Sections")
        
        sectionsRef.observeEventType(.Value, withBlock: { (snapshot) in
            
            var sectionTest = snapshot.value
            
            //sections.append(sectionTest)
            
            
            
            
            // let section = Section(id: id,beds,numBeds)
            
            //self.sectionArray.append(section)
        })
        
        //print(sections)
        // *** STEP 4: RECEIVE MESSAGES FROM FIREBASE (limited to latest 25 messages)
        sectionsRef.observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
            
            
            var sectionArray: [Section]
            var beds = snapshot.value["Beds"] as! NSDictionary
            var id = snapshot.value["id"] as? String
            var numBeds = snapshot.value["numBeds"] as! String
            print("Beds: "+String(beds)+"  SectionID: "+String(id)+"  Numbeds"+numBeds+"  SectionKey"+snapshot.key)
            var idAsInt =  NSNumberFormatter().numberFromString(id!)?.integerValue
            var numBedsInt =  NSNumberFormatter().numberFromString(numBeds)?.integerValue
            section.append(idAsInt!)
            section.append(numBedsInt!)

            
            
           // let section = Section(id: id,beds,numBeds)
            
            //self.sectionArray.append(section)
        })
            //let ID = Int(section[0].value)
            //let numBedz = Int(section[1].value)
            //let bedTest = [sectionArray[2].beds[1]]
            sectionFor = Section(id: ID, beds: bedTest, numBeds: numBedz)
         //var sects = snapshot.value.objectForKey("Sections")
*/
    }
    
    func getUsingQuery() {
        var ref: Firebase!
        ref = Firebase(url: "https://glowing-torch-4644.firebaseio.com/Sections")
        
        //Make temp plants
        let plant1 = Plant(name: "Wheat",bestSeasons: [],notes: [],varieties: [])
        let plant2 = Plant(name: "Corn",bestSeasons: [],notes: [],varieties: [])
        let plant3 = Plant(name: "Barley",bestSeasons: [],notes: [],varieties: [])
        let plant4 = Plant(name: "Garlic",bestSeasons: [],notes: [],varieties: [])
        
        plant1.plant_weight = 50
        plant3.plant_weight = 60
        
        let variety1 = Variety(name: "Golden", bestSeasons: [], notes: [], bedHistory: BedHistory(), plant: plant1)
        let variety2 = Variety(name: "Red", bestSeasons: [], notes: [], bedHistory: BedHistory(), plant: plant2)
        let variety3 = Variety(name: "Extra Spicy", bestSeasons: [], notes: [], bedHistory: BedHistory(), plant: plant3)
        let variety4 = Variety(name: "Vampire Repellant", bestSeasons: [], notes: [], bedHistory: BedHistory(), plant: plant4)
        
        variety1.varietyWeight = 50
        variety1.varietyWeight = 40
        //Setup plant varieties
        
        plant1.varieties.append(variety1)
        plant2.varieties.append(variety2)
        plant3.varieties.append(variety3)
        plant4.varieties.append(variety4)
        allPossiblePlants = [plant1,plant2,plant3,plant4]
        //Make temp crops
        let crop1 = Crop(datePlanted: Date(year: 2016,month: 1,day: 1),datesHarvested: [],notes: "test",variety: variety1, finalHarvest: Date(year: 2016,month: 1,day: 1))
        let crop2 = Crop(datePlanted: Date(year: 2016,month: 1,day: 1),datesHarvested: [],notes: "test2",variety: variety2, finalHarvest: Date(year: 2016,month: 1,day: 1))
        let crop3 = Crop(datePlanted: Date(year: 2016,month: 1,day: 1),datesHarvested: [],notes: "Hello World",variety: variety3, finalHarvest: Date(year: 2016,month: 1,day: 1))
        let bed2 = Bed(id: 2, currentCrop: crop1, cropHistory: CropHistory(numCrops: 2,crops: [crop3,crop2]))
        
        
        ref.queryOrderedByKey().observeEventType(.Value, withBlock: { snapshot in
                var sect = snapshot.value
                //print("\(snapshot.key) was \(sect) meters tall")
                var id = snapshot.value["id"] as? Int
                var numBeds = snapshot.value["numBeds"] as? Int
                //var idAsInt =  NSNumberFormatter().numberFromString(id!)?.integerValue
                //print(idAsInt)
                //var numBedsInt =  NSNumberFormatter().numberFromString(numBeds!)?.integerValue
                self.sectionFor = [Section(id: 1, beds: [bed2], numBeds: 2)]
                self.getSectFromFunction(self.sectionFor)
                //print("inside:\(self.sectionFor)")
        
            
        
            
        })
        print("outside:\(self.sectionFor)")
    }
    
    func getSectFromFunction(section: [Section]){
        print("OMG\(section)")
        LibraryAPI.sharedInstance.setSections(section)
    }
    
    func createSects(sections: [Section]) {
        let ref = Firebase(url: "https://glowing-torch-4644.firebaseio.com")
        let postRef = ref.childByAppendingPath("Sections")
        var i : Int
        for i in 0...(sections.count-1){
            var beds = [NSDictionary]()
           // let sectionRef = postRef.childByAppendingPath("\(sections[i])")
            //sectionRef.setValue(
            for j in (0...sections[i].beds.count-1){
                beds.append(["id": String(sections[i].beds[j].id), "bedWeight": String(sections[i].beds[j].bedWeight)])
             //   postRefX = postRef+ "\(j)"
            //    postRefX.childByAutoId().setValue(beds)
            }
            var sect = ["id":String(sections[i].id), "numBeds" : String(sections[i].numBeds), "sectionWeight" : String(sections[i].sectionWeight), "beds": beds]
            postRef.childByAutoId().setValue(sect)
        }
    }

    func createSectWithBeds(sections: [Section]) {
        let ref = Firebase(url: "https://glowing-torch-4644.firebaseio.com")
        let sectionRef = ref.childByAppendingPath("Sections")
        var i : Int
        for i in 2...(sections.count-1){
            let sectionKey = sectionRef.childByAutoId()
            var sect = ["id":String(sections[i].id), "numBeds" : String(sections[i].numBeds)]
            sectionKey.setValue(sect)
            let bedRef = sectionKey.childByAppendingPath("Beds")
            for j in (0...sections[i].beds.count-1){
                let bedKey = bedRef.childByAutoId()
                bedKey.setValue(["id": String(sections[i].beds[j].id)])
            }
            
            
        }
    }
    
    func createBedsWithCrops(sections: [Section]) {
        let ref = Firebase(url: "https://glowing-torch-4644.firebaseio.com")
        let bedsRef = ref.childByAppendingPath("Beds")
        var i : Int
        for i in 0...(sections.count-1){
            let bedKey = bedsRef.childByAutoId()
            var bed = ["id":String(sections[i].id), "numBeds" : String(sections[i].numBeds)]
            bedKey.setValue(bed)
            let bedRef = bedKey.childByAppendingPath("Beds")
            for j in (0...sections[i].beds.count-1){
                let bedKey = bedRef.childByAutoId()
                bedKey.setValue(["id": String(sections[i].beds[j].id)])
            }
            
            
        }
    }
    
    func createBed(sections: [Section]/*,sectionKey: Section.self*/) {
        var bed = sections[2].beds[1]
        var bedID = bed.id
        let ref = Firebase(url: "https://glowing-torch-4644.firebaseio.com")
        let bedRef = ref.childByAppendingPath("Beds")
        var bedForDb = ["Id": String(bedID)]
        bedRef.childByAutoId().setValue(bedForDb)
    }
    func createCrop(sections: [Section]) {
        var crop = sections[2].beds[1].currentCrop
        var variety = crop?.variety.name
        var date = crop?.datePlanted
        let cropRef = Firebase(url: "https://glowing-torch-4644.firebaseio.com/Crops")
        var cropForDb = ["Variety": String(variety), "DatePlanted": (String(date?.day)+String(date?.month)+String(date?.year))]
        cropRef.childByAutoId().setValue(cropForDb)
    }
    
    /*
    func createCrop(newCrop, bedKey: bedKey,sectKey: sectNum) {
        var newCrop = newCrop
        let ref = Firebase(url: "https://glowing-torch-4644.firebaseio.com/")
        let cropRef = Firebase(url: "https://glowing-torch-4644.firebaseio.com/Crops")
        var cropForDb = ["Crop": newCrop, "bedKey": bedKey, "secNum": sectKey]
        var cropKey = cropRef.childByAutoId()
        cropKey.setValue(cropForDb)
        let bedRef = ref.childByAppendingPath("Beds")
        bedRef.queryOrderedByChild(bedKey.key)
        bedkey.key.cropKey
    }
    */
    
    func makeSimpleSect(sections: [Section]) {
        let ref = Firebase(url: "https://glowing-torch-4644.firebaseio.com")
        for i in 1...(sections.count){
            let sectRef = ref.childByAppendingPath("Section\(i)")
            sectRef
            for j in 1...(sections[i].numBeds){
                var cropForDb = ["Variety": "wheat", "DatePlanted":"today", "sectId": "\(i)", "bedId": "\(j)"]
                let bedRef = sectRef.childByAppendingPath("Bed\(j)")
                bedRef.setValue(["id": "\(j)", "sectNum": "\(i)"])
                let crops = bedRef.childByAppendingPath("Crops")
                let cropKey = crops.childByAutoId()
                cropKey.setValue("true")
                let cropRef = ref.childByAppendingPath("Crops")
                cropRef.childByAppendingPath(cropKey.key).setValue(cropForDb)
            }
        }
    }
    
    func mergeFlatDataSectBeds () {
        let ref = Firebase(url: "https://glowing-torch-4644.firebaseio.com")
        
        // fetch a list of Mary's groups
        ref.childByAppendingPath("Section2").observeEventType(.ChildAdded, withBlock: {snapshot in
            // for each group, fetch the name and print it
            let group = snapshot.childSnapshotForPath("Crops").value
            var anyKey = group.allKeys as! NSObject
            var stringKey = String(anyKey)
            var groupKey = stringKey.stringByReplacingOccurrencesOfString("(", withString: "")
            groupKey = groupKey.stringByReplacingOccurrencesOfString(")", withString: "")
            groupKey = groupKey.stringByReplacingOccurrencesOfString("\"", withString: "")
            groupKey = groupKey.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()
            )
            let stringGroupKey = "Crops/\(groupKey)"
            print(stringGroupKey)
            ref.childByAppendingPath(stringGroupKey).observeSingleEventOfType(.Value, withBlock: {snapshot in
                print(snapshot.value)
                print("This crop is in Section \(snapshot.value["sectId"]) and Bed \(snapshot.value["bedId"])")
            })
        })
    }
    
    func saveToDatabase () {
        /*let ref = Firebase(url: "https://glowing-torch-4644.firebaseio.com")
      
        var beds = LibraryAPI.sharedInstance.getBed(1, bedNum: 1)
        var sects = LibraryAPI.sharedInstance.getSects()
        var section1 = LibraryAPI.sharedInstance.getSection(1)
        
        var bedsForDatabase = String(beds.id)
        var sectsForDatabase = ["SectID": sects.count, "Beds": bedsForDatabase]

        var crop = LibraryAPI.sharedInstance.getCurrentCropForBed(3, bedNum:3)
        var cropForDatabase = ["DatePlanted": String(crop?.notes)]
        print(cropForDatabase)
        
        
        print(sectsForDatabase)
        
       
        let postRef = ref.childByAppendingPath("Sections")
        
        
        let post1Ref = postRef.childByAutoId()
        let post2Ref = postRef.childByAutoId()
        post1Ref.setValue(bedsForDatabase)
       

        
        // Get a reference to our posts
        let ref = Firebase(url:"https://dazzling-inferno-9759.firebaseio.com")
        // Attach a closure to read the data at our posts reference
        ref.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value.objectForKey("Harvest"))
            }, withCancelBlock: { error in
                print(error.description)
        }) */
        let ref = Firebase(url: "https://glowing-torch-4644.firebaseio.com")
        
        ref.observeEventType(.Value, withBlock: { snapshot in
            //var cropArray =
            print(snapshot.value.objectForKey("Crop"))
            }, withCancelBlock: { error in
                print(error.description)
        })
        
    }

    

}
