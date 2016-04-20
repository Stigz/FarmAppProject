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
    
    //Table of sections
    @IBOutlet weak var sectionTable: UITableView!
 
    //Section list
    var sections : [Section] = []
    var plants : [Plant] = []
    //NOTE: Only for the prepare for segue
    var currentSect : Section!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set default bed number
        sections = LibraryAPI.sharedInstance.getSects()

        
        //Register table for cell class
        self.sectionTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // This will remove extra separators from tableview
        self.sectionTable.tableFooterView = UIView(frame: CGRectZero)
        
       readSectionsFromDatabase()
        readPlantsFromDataBase()
    }
    
    func readSectionsFromDatabase(){
        var sectionsRef: Firebase!
        sectionsRef = Firebase(url: "https://glowing-torch-4644.firebaseio.com/SectionsTest")
        sectionsRef.observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
            
            let beds = snapshot.value["Beds"] as! NSDictionary
            let Sect_Weight = snapshot.value["Sect_Weight"] as! Int
            let Sect_ID =  snapshot.value["Sect_ID"] as! Int
            
            var bedsToAdd = [Bed]()
            
            let plant1 = Plant(name: "Wheat",bestSeasons: ["Winter"],notes: "",varieties: [], weight: 50)
            let variety1 = Variety(name: "Golden", bestSeasons: ["Winter"], notes: "", bedHistory: [], plant: plant1, varietyWeight: 50)
            
            
            
            for bed in beds{
                let bed_ID = bed.value["Bed_Id"] as! Int
                let cropH = bed.value["Crop_History"] as! NSDictionary
                let crops = cropH.valueForKey("Crops") as! NSDictionary
                var cropsForHistory = [Crop]()
                for crop in crops{
                    let datePlanted = crop.value["Date_Planted"] as! NSDictionary
                    let year = datePlanted.valueForKey("year") as! Int
                    let month = datePlanted.valueForKey("month") as! Int
                    let day = datePlanted.valueForKey("day") as! Int
                    let pDate = Date(year: year, month: month, day: day)
                    let harvestDate = crop.value["Final_Harvest"] as! NSDictionary
                    let hYear = harvestDate.valueForKey("year") as! Int
                    let hMonth = harvestDate.valueForKey("month") as! Int
                    let hDay = harvestDate.valueForKey("day") as! Int
                    let hDate = Date(year: hYear, month: hMonth, day: hDay)
                    let notes = crop.value["Notes"] as! String
                    let totalWeight = crop.value["Total_Weight"] as! Int
                    let varietyKey = crop.value["Variety_Key"] as! String
                    let datesHarvestedVals = crop.value["Dates_Harvested"]
                    let weightsHarvestedVals = crop.value["Weights_Harvested"]
                    let weightsHarvestedToAdd = self.readWeights(weightsHarvestedVals)
                    let datesHarvestedToAdd = self.readHarvestDates(datesHarvestedVals)
                    
                   
                    
                    let newCrop = Crop(datePlanted: pDate, datesHarvested: datesHarvestedToAdd, notes: notes, variety: variety1, finalHarvest: hDate, harvestWeights: weightsHarvestedToAdd, totalWeight: totalWeight)
                    cropsForHistory.append(newCrop)
                }
                let cropHistory = CropHistory(numCrops: cropsForHistory.count, crops: cropsForHistory)
                
                //dealing with the current crop
                let currentCropVal = bed.value["Current_Crop"]
                var currentCropToAdd : Crop?
                if let currentCropDict = currentCropVal as? NSDictionary{
                    let notes = currentCropDict.valueForKey("Notes") as! String
                    let totalWeight = currentCropDict.valueForKey("Total_Weight") as! Int
                    let datePlanted = currentCropDict.valueForKey("Date_Planted") as! NSDictionary
                    let pday = datePlanted.valueForKey("day") as! Int
                    let pmonth = datePlanted.valueForKey("month") as! Int
                    let pyear = datePlanted.valueForKey("year") as! Int
                    let pDate = Date(year: pyear, month: pmonth, day: pday)
                    let datesHarvestedVals = currentCropDict.valueForKey("Dates_Harvested")
                    let weightsHarvestedVals = currentCropDict.valueForKey("Weights_Harvested")
                    let weightsHarvestedToAdd = self.readWeights(weightsHarvestedVals)
                    let datesHarvestedToAdd = self.readHarvestDates(datesHarvestedVals)
                    

                    //current crop has final harvest?
                    
                    currentCropToAdd = Crop(datePlanted: pDate, datesHarvested: datesHarvestedToAdd, notes: notes, variety: variety1, finalHarvest: nil, harvestWeights: weightsHarvestedToAdd, totalWeight: totalWeight)
                }
                
                
                let newBed = Bed(id: bed_ID, currentCrop: currentCropToAdd, cropHistory:  cropHistory, sectID: Sect_ID, bedKey : "Key")
                bedsToAdd.append(newBed)
            }
            bedsToAdd.sortInPlace({ $0.id < ($1.id)})
            self.sections.append(Section(id: Sect_ID, beds: bedsToAdd, numBeds: bedsToAdd.count, sectionWeight: Sect_Weight))
            
           //runs 4x
            LibraryAPI.sharedInstance.setSections(self.sections)
            self.sectionTable.reloadData()
            
        })
        

    }
    
    func readPlantsFromDataBase(){
        var plantsRef: Firebase!
        plantsRef = Firebase(url: "https://glowing-torch-4644.firebaseio.com/Plants_Test")
        plantsRef.observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
        let seasons = snapshot.value["Best_Seasons"]
        let seasonsToAdd = self.readBestSeasons(seasons)
        let totalWeight = snapshot.value["Total_Weight"] as! Int
        let name = snapshot.value["Plant_Name"] as! String
        let notes = snapshot.value["Variety_Notes"] as! String
        let varietiesVal = snapshot.value["Varieties"]
        var varietiesToAdd = [Variety]()
            if let varietiesDict = varietiesVal as? NSDictionary {
                for variety in varietiesDict{
                    let seasons = variety.value["Best_Seasons"]
                    let seasonsToAdd = self.readBestSeasons(seasons)
                    let totalWeight = variety.value["Total_Weight"] as! Int
                    //let plantName = variety.value["Plant_Name"] as! String
                    let varietyName = variety.value["Variety_Name"] as! String
                    let varietyNotes = variety.value["Variety_Notes"] as! String
                    let newVariety = Variety(name: varietyName, bestSeasons: seasonsToAdd, notes: varietyNotes, bedHistory: [], plant: nil, varietyWeight: totalWeight)
                    varietiesToAdd.append(newVariety)
                }
            }
        let newPlant = Plant(name: name, bestSeasons: seasonsToAdd, notes: notes, varieties: varietiesToAdd, weight: totalWeight)
            for variety in newPlant.varieties{
                variety.plant = newPlant
            }
        
       
        
            
     self.plants.append(newPlant)
        LibraryAPI.sharedInstance.setPlants(self.plants)


        })
    }
    
    func readBestSeasons(seasons: AnyObject?!) -> [String]{
        var seasonsToAdd = [String]()
        if let seasonsDict = seasons as? NSDictionary{
            for season in seasonsDict {
                seasonsToAdd.append(season.value as! String)
            }
        }
        return seasonsToAdd

    }
    
    func readHarvestDates(datesHarvestedVals: AnyObject?!) -> [Date]{
        var datesHarvestedToAdd = [Date]()

            if let datesHarvestedDict = datesHarvestedVals as? NSDictionary{
    
                for date in datesHarvestedDict {
                    let info = date.value
                    let year = info.valueForKey("year") as! Int
                    let month = info.valueForKey("month") as! Int
                    let day = info.valueForKey("day") as! Int
                    let newDate = Date(year: year, month: month, day: day)
                    datesHarvestedToAdd.append(newDate)
    
                    }
            }
        return datesHarvestedToAdd
    }
    
    func readWeights(weightsHarvestedVals : AnyObject?!) -> [Int]{
        var weightsHarvestedToAdd = [Int]()
        if let weightsHarvestedDict = weightsHarvestedVals as? NSDictionary{
            for weight in weightsHarvestedDict {
                let newWeight = weight.value as! Int
                weightsHarvestedToAdd.append(newWeight)
            }
        }
        return weightsHarvestedToAdd
    }





    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func toCropList(){
        performSegueWithIdentifier("toCropList", sender: self)
        
    }
    
    @IBAction func addSection(){
        LibraryAPI.sharedInstance.addSection()
        sections = LibraryAPI.sharedInstance.getSects()
        sectionTable.reloadData()
    }
    
    
    
    /* ----------------------------------
    *  Deleting a Section methods
    * ---------------------------------
    */
    
    //the handler for the delete alert
    func deleteSection(alert: UIAlertAction){
        let removeIndex = sections.indexOf(currentSect)
        LibraryAPI.sharedInstance.deleteSection(removeIndex!)
        sections = LibraryAPI.sharedInstance.getSects()
        sectionTable.reloadData()
    }
    

    
    
    //For different segues away from this screen
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        //IF the user segues to a bed list, pass section info
        if (segue.identifier == "sectClicked"){
            let bvc = segue.destinationViewController as! BedsViewController
            bvc.setInfo(currentSect.id)
        }

    }



}

//Table View Extensions -- for section table
extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell:UITableViewCell = self.sectionTable.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = "Section \(sections[indexPath.row].id)"
        //Set arrow accessory
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
      
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //maybe have it only ask twice if you want to delete plants
        if editingStyle == .Delete {
            let alertController = UIAlertController(title: "Are you sure you want to delete this section and all of its beds", message: "This cannot be undone", preferredStyle: .Alert)
            let delete = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: deleteSection)
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(delete)
            currentSect = sections[indexPath.row]
            alertController.addAction(cancel)
            presentViewController(alertController, animated: true, completion: nil)
            
            //sort through plants until I find the one with the right name, delete it, refilter, redisplay
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    // Override to support conditional editing of the table view.
    //This can return true or false based on whether its the farm manager using the app
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
}



//Upon section click, show the bed list
extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //To prepare for segue, set up current section
        currentSect = sections[indexPath.row]
        performSegueWithIdentifier("sectClicked", sender: self)
        //Unhighlight the selected section, in case user goes back
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}

