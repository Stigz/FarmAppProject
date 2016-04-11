//
//  ViewController.swift
//  FarmApp
//
//  Created by Patrick Little on 8/02/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    private var allPossiblePlants = [Plant]()
    //Table of sections
    @IBOutlet weak var sectionTable: UITableView!
    //Number of sections in garden
    var numSects = 5
    //Section list
    //var sections : [Section] = []
    //NOTE: Only for the prepare for segue
    var currentSect : Section!
    //var databaseManager = DatabaseManager()
    
    var sectionFor: [Section] = [Section]()
    
    /*func getSectsFromDatabase(section: [Section]){
        sections = section
        print("These Sections \(sections)")
    }   
    */
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
            var sectionsRef: Firebase!
        
            
            sectionFor = []
            
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
        
            
            sectionsRef.observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
                print("Snaphots:\(snapshot.value)")
                var tempSect = [Section]()
                //var beds = snapshot.value["Beds"] as! NSDictionary
                var id = snapshot.value["id"] as? String
                var numBeds = snapshot.value["numBeds"] as! String
                
                sectionsRef.childByAppendingPath("Beds")
                var idAsInt =  NSNumberFormatter().numberFromString(id!)?.integerValue
                var numBedsInt =  NSNumberFormatter().numberFromString(numBeds)?.integerValue
                self.sectionFor.append(Section(id: idAsInt!, beds: [bed2], numBeds: numBedsInt!))
                //sections.append(sectionTest)
                
                //LibraryAPI.sharedInstance.setSections(sectionFor)
                
                
                print("Section for : \(self.sectionFor)")
                self.sectionTable.reloadData()
            })
            
            
            print("Setion for : \(sectionFor)")
            
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
        
        
        
        
        
        
        
        
        //getSects()
        //LibraryAPI.sharedInstance.getSects()
        
        //Set default bed number
        //databaseManager.makeSimpleSect()
        //databaseManager.mergeFlatDataSectBeds()
        
        //Register table for cell class
        self.sectionTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // This will remove extra separators from tableview
        self.sectionTable.tableFooterView = UIView(frame: CGRectZero)
        
        //LibraryAPI.sharedInstance.commitToDatabase()
        
        //databaseManager.createCrop(sections)
        //databaseManager.createSectWithBeds(sections)
        //databaseManager.createBed(sections
        
        //sections = LibraryAPI.sharedInstance.getSects()
        
        //numSects = sections.count
        print("this comes first")
        print("View Sections \(sectionFor)")
        sectionTable.reloadData()
        
        
    }
    
   
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func toCropList(){
        performSegueWithIdentifier("toCropList", sender: self)
        
    }
    
   
    
    //For different segues away from this screen
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        //IF the user segues to a bed list, pass section info
        if (segue.identifier == "sectClicked"){
            let bvc = segue.destinationViewController as! BedsViewController
            bvc.setInfo(currentSect.id)
        }
        if(segue.identifier == "toCropList"){
            segue.destinationViewController as! CropListViewController
            
        }

    }



}

//Table View Extensions -- for section table
extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return numSects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.sectionTable.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = "Section \(sectionFor[indexPath.row].id)"
        //Set arrow accessory
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
      
        return cell
    }
}

//Upon section click, show the bed list
extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //To prepare for segue, set up current section
        currentSect = sectionFor[indexPath.row]
        performSegueWithIdentifier("sectClicked", sender: self)
        //Unhighlight the selected section, in case user goes back
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}

