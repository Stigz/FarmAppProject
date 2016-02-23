//
//  BedViewController.swift
//  FarmApp
//
//  Created by Patrick Little on 15/02/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit

class BedViewController: UIViewController {

    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var currentCropLabel: UIButton!
    @IBOutlet weak var cropHistoryTable: UITableView!
    
    var plantedCrop : Crop?
    var bedNum : Int = 0
    var sectNum : Int = 0
    var bed : Bed!
    var cropHistory : CropHistory!
    var numCropsInHistory : Int = 0
    var cropList : [Crop]!
    var clickedCrop : Crop!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up title label
        topTitleLabel.text = "Section \(sectNum), Bed \(bedNum)"
        //Set up current crop label
        if((plantedCrop) != nil){
            currentCropLabel.setTitle("Current Crop: \(plantedCrop!.variety.plant.name)", forState: .Normal)
        }else{
            currentCropLabel.setTitle("No Crop Planted", forState: .Normal)
        }
        
        //Register table for cell class
        self.cropHistoryTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cropCell")
        
        // This will remove extra separators from tableview
        self.cropHistoryTable.tableFooterView = UIView(frame: CGRectZero)
        
        //Setup notification observer for crop harvest 
        NSNotificationCenter.defaultCenter().addObserver(self, selector:"harvestCrop:", name: "CropHarvestedNotification", object: nil)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        NSNotificationCenter.defaultCenter().removeObserver(self)
        // Dispose of any resources that can be recreated.
    }
    
    //Set info passed from bed list
    func setInfo(sectNum : Int, bed : Bed){
        self.sectNum = sectNum
        self.bed = bed
        calculateInfo(bed)
    }
    
    //Used to calculate information, based on bed
    func calculateInfo(bed: Bed){
        self.plantedCrop = bed.currentCrop
        self.bedNum = bed.id
        self.cropHistory = bed.cropHistory
        self.numCropsInHistory = bed.cropHistory.numCrops
        self.cropList = bed.cropHistory.crops
    }
    
    //Close the current screen -- back button clicked
    @IBAction func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Handle when the current crop is clicked
    //and transition to crop screen
    @IBAction func currentCropClicked() {
        if((plantedCrop) != nil){
            performSegueWithIdentifier("currentCropClicked", sender: self)
        }else{
            performSegueWithIdentifier("addCropFromBedList", sender: self)
        }
    }
    
    
    //For different segues away from this screen
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        //If a crop is clicked, segue to crop screen
        if (segue.identifier == "cropClicked"){
            let cvc = segue.destinationViewController as! CropViewController
            cvc.setInfo(clickedCrop,bedNum: bedNum, sectNum: sectNum, isPlanted: false)
        }else if (segue.identifier == "currentCropClicked"){ //If current crop clicked, segue to crop screen
            let cvc = segue.destinationViewController as! CropViewController
            cvc.setInfo(plantedCrop!,bedNum: bedNum, sectNum: sectNum, isPlanted: true)
        }else if (segue.identifier == "addCropFromBedlist"){ //If no current crop, add a new crop
            let acvc = segue.destinationViewController as! AddCropViewController
            acvc.setInfo(sectNum,bedNum: bedNum)
        }
    }
    
    
    //Reloads bed info, called when
    //a crop is harvested
    func reloadInfoForHarvest(crop: Crop){
        self.bed.cropHistory.crops.insert(crop, atIndex: 0)
        self.bed.cropHistory.numCrops!++
        self.bed.currentCrop = nil
        self.calculateInfo(self.bed)
        //Set up current crop label
        currentCropLabel.setTitle("No Crop Planted", forState: .Normal)
    }
    
    //Called when a notification for a crop harvest
    //is receicived. Reload info for the harvest,
    //and reload table data
    func harvestCrop(notification: NSNotification){
        let userInfo = notification.userInfo as! [String : AnyObject]
        let harvestedCrop = userInfo["crop"] as! Crop
        reloadInfoForHarvest(harvestedCrop)
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
        cell.detailTextLabel!.text = "\(crop.datePlanted.printSlash()) to \(crop.dateHarvested.printSlash())"
        
        return cell
    }
}

//Upon section click, show the bed list
extension BedViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //To prepare for segue, set up current section
        clickedCrop = cropList[indexPath.row]
        performSegueWithIdentifier("cropClicked", sender: self)
        //Unhighlight the selected section, in case user goes back
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}
