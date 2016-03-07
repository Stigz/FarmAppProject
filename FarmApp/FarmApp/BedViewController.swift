//
//  BedViewController.swift
//  FarmApp
//
//  Created by Patrick Little on 15/02/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit

class BedViewController: UIViewController {
    
    //UI Outlets
    @IBOutlet weak var newCropButton: UIButton!
    @IBOutlet weak var currentCropLabel: UIButton!
    @IBOutlet weak var cropHistoryTable: UITableView!
    
    //Controller Instance Variables
    var plantedCrop : Crop?
    var bedNum : Int = 0
    var sectNum : Int = 0
    var bed : Bed!
    var cropHistory : CropHistory!
    var numCropsInHistory : Int = 0
    var cropList : [Crop]!
    var clickedCropIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Set up labels
        self.navigationItem.title = "Bed \(bedNum)"
        updateCropLabel()
        
        //Register table for cell class
        self.cropHistoryTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cropCell")
        
        // This will remove extra separators from tableview
        self.cropHistoryTable.tableFooterView = UIView(frame: CGRectZero)

    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationItem.title = "Bed \(bedNum)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Set info passed from bed list
    func setInfo(sectNum : Int, bedNum : Int){
        self.sectNum = sectNum
        self.bedNum = bedNum
        calculateInfo()
    }
    
    //Used to calculate information, based on bed
    func calculateInfo(){
        //First, get bed from API
        self.bed = LibraryAPI.sharedInstance.getBed(sectNum, bedNum: bedNum)
        //Then calculate info based on bed
        self.plantedCrop = bed.currentCrop
        self.bedNum = bed.id
        self.cropHistory = bed.cropHistory
        self.numCropsInHistory = bed.cropHistory.numCrops
        self.cropList = bed.cropHistory.crops
    }
    
    //Handle when the current crop is clicked
    //and transition to crop screen
    @IBAction func currentCropClicked() {
        performSegueWithIdentifier("currentCropClicked", sender: self)
    }
    
    //Handle when + button is clicked, transition to new crop screen
    @IBAction func addNewCrop(){
        performSegueWithIdentifier("addCropFromBedList", sender: self)
    }
    
    
    //For different segues away from this screen
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        //Set navigation title, so next screen has more informative back button
        self.navigationItem.title = "Section \(sectNum), Bed \(bedNum)"
        //If a crop is clicked, segue to crop screen
        if (segue.identifier == "cropClicked"){
            let cvc = segue.destinationViewController as! CropViewController
            cvc.setInfo(bedNum, sectNum: sectNum, isPlanted: false, index: clickedCropIndex)
        }else if (segue.identifier == "currentCropClicked"){ //If current crop clicked, segue to crop screen
            let cvc = segue.destinationViewController as! CropViewController
            cvc.setInfo(bedNum, sectNum: sectNum, isPlanted: true, index: 0)
        }else if (segue.identifier == "addCropFromBedList"){ //If no current crop, add a new crop
            let acvc = segue.destinationViewController as! AddCropViewController
            acvc.setInfo(sectNum,bedNum: bedNum)
        }
    }
    
    //Update crop label, based on current crop
    func updateCropLabel(){
        if((plantedCrop) != nil){
            currentCropLabel.setTitle("Current Crop: \(plantedCrop!.variety.plant.name)", forState: .Normal)
            newCropButton.hidden = true
        }else{
            currentCropLabel.setTitle("No Crop Planted", forState: .Normal)
            newCropButton.hidden = false
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.calculateInfo()
        updateCropLabel()
        self.cropHistoryTable.reloadData()
    }

}

//Table View Extensions -- for bed table
extension BedViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numCropsInHistory
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.cropHistoryTable.dequeueReusableCellWithIdentifier("cropCell")! as UITableViewCell
        //Allow for subtitles to cell
        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,
            reuseIdentifier: "cropCell")
        //Save current crop
        let crop = cropList[indexPath.row]
        cell.textLabel!.text = "\(crop.variety.plant.name)"
        //Set subtitle
        cell.detailTextLabel!.font = cell.detailTextLabel!.font.fontWithSize(10)
        cell.detailTextLabel!.text = "\(crop.datePlanted.printSlash()) to \(crop.finalHarvest!.printSlash())"
        //Set arrow accessory
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
}

//Upon section click, show the bed list
extension BedViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //To prepare for segue, set up current section
        clickedCropIndex = indexPath.row
        performSegueWithIdentifier("cropClicked", sender: self)
        //Unhighlight the selected section, in case user goes back
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}
