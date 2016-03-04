//
//  CropViewController.swift
//  FarmApp
//
//  Created by Patrick Little on 16/02/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit

class CropViewController: UIViewController {


    @IBOutlet weak var cropBedLabel: UILabel!
    @IBOutlet weak var cropNameLabel: UILabel!
    @IBOutlet weak var varietyLabel: UILabel!
    @IBOutlet weak var plantedLabel: UILabel!
    @IBOutlet weak var harvestedButton: UIButton!
    @IBOutlet weak var notesField: UITextView!
    @IBOutlet weak var cropHistoryTable: UITableView!
    
    //Initially hidden labels
    @IBOutlet weak var enterDateLabel: UILabel!
    @IBOutlet weak var dayInput: UITextField!
    @IBOutlet weak var monthInput: UITextField!
    @IBOutlet weak var yearInput: UITextField!
    @IBOutlet weak var harvestButton: UIButton!
    @IBOutlet weak var finalHarvestButton: UIButton!
    
    
    var crop : Crop!
    var bedNum : Int = 0
    var sectNum : Int = 0
    var isPlanted : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set up labels
        cropNameLabel.text = crop.variety.plant.name
        cropBedLabel.text = "Planted in section \(sectNum), bed \(bedNum)."
        plantedLabel.text = "Planted: \(crop.datePlanted.printSlash())"
        varietyLabel.text = "Variety: \(crop.variety.name)"
        //Setup notes
        
        notesField.text = crop.notes
        //If planted, add harvest button
        if (isPlanted){
            harvestedButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
            harvestedButton.setTitle("Harvest now!", forState: .Normal)
        }else{ // If not planted, show harvest date
            harvestedButton.setTitle("Harvested: \(crop.finalHarvest!.printSlash())", forState: .Normal)
            //to disallow clicking on the date
            harvestedButton.userInteractionEnabled = false
        }
        
        //Register table for cell class
        self.cropHistoryTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "harvestCell")
        
        // This will remove extra separators from tableview
        self.cropHistoryTable.tableFooterView = UIView(frame: CGRectZero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //For setting info passed from Bed controller
    func setInfo(bedNum : Int, sectNum : Int, isPlanted: Bool, index : Int){
        self.bedNum = bedNum
        self.sectNum = sectNum
        self.isPlanted = isPlanted
        if(isPlanted){
            self.crop = LibraryAPI.sharedInstance.getCurrentCropForBed(sectNum, bedNum: bedNum)
        }else{
            self.crop = LibraryAPI.sharedInstance.getCropFromHistory(sectNum, bedNum: bedNum, index: index)
        }
    }
    
    //Close the current screen -- back button clicked
    @IBAction func close() {
        NSNotificationCenter.defaultCenter().postNotificationName("CropModifiedNotification", object: self)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //When user wants to harvest the crop
    @IBAction func harvest() {
        updateViewForHarvest(false)
    }
    
    //TO enter the harvest date
    @IBAction func addHarvestDate() {
        if let day : Int? = Int(dayInput.text!){
            if let month : Int? = Int(monthInput.text!){
                if let year : Int? = Int(yearInput.text!){
                    //Add new harvest date
                    let newHarvest = Date(year: year!, month: month!, day: day!)
                    //Harvest crop
                    LibraryAPI.sharedInstance.harvestCropForBed(sectNum, bedNum: bedNum, dateHarvested: newHarvest)
                    self.crop = LibraryAPI.sharedInstance.getCurrentCropForBed(sectNum, bedNum: bedNum)
                    //update view
                    updateViewForHarvest(true)
                }
            }
        }
        
    }
    
    @IBAction func finalHarvest(){
        if let day : Int? = Int(dayInput.text!){
            if let month : Int? = Int(monthInput.text!){
                if let year : Int? = Int(yearInput.text!){
                    //Add new harvest date
                    let newHarvest = Date(year: year!, month: month!, day: day!)
                    //Harvest crop
                    LibraryAPI.sharedInstance.finalHarvestForBed(sectNum, bedNum: bedNum, dateHarvested: newHarvest)
                    self.crop = LibraryAPI.sharedInstance.getCropFromHistory(sectNum, bedNum: bedNum, index: 0)
                    //Ask user if they would like to add a new crop
                    let alertController = UIAlertController(title: "Crop harvested!", message: "Would you like to add another crop to this bed now?", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: addNewCrop))
                    alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: cropHarvested))
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    
    //If the user harvests, and wants to add a new crop,
    //Transition to new crop screen. Also, notify bed view
    //that a crop was harvested, and update the crop view
    //to reflect the change (in case the user cancels adding
    //a new crop)
    func addNewCrop(action: UIAlertAction){
        //Segue to adding new crop
        performSegueWithIdentifier("addCropFromCrop", sender: self)
        cropHarvested(action)

    }
    
    //Updates the vuiew when a crop is harvested
    func updateViewForHarvest(initialView : Bool){
        if (isPlanted){
            harvestedButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
            harvestedButton.setTitle("Harvest now!", forState: .Normal)
        }else{ // If not planted, show harvest date
            harvestedButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            harvestedButton.setTitle("Harvested: \(crop.finalHarvest!.printSlash())", forState: .Normal)
            //to disallow clicking on the date
            harvestedButton.userInteractionEnabled = false
        }
        if (initialView){
            dayInput.text = ""
            monthInput.text = ""
            yearInput.text = ""
            cropHistoryTable.reloadData()
        }
        harvestedButton.hidden = !initialView
        enterDateLabel.hidden = initialView
        dayInput.hidden = initialView
        monthInput.hidden = initialView
        yearInput.hidden = initialView
        harvestButton.hidden = initialView
        finalHarvestButton.hidden = initialView
    }
    
    //If the user harvests, but does not add a new crop
    //notify bed of harvest, and then show the reflected change
    func cropHarvested(action: UIAlertAction){
        isPlanted = false
        updateViewForHarvest(true)
    }
    
    //For different segues away from this screen
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        //IF the user segues back to bed list, pass it new crop info
        if (segue.identifier == "addCropFromCrop"){ //If user wants to add new crop
            let acvc = segue.destinationViewController as! AddCropViewController
            acvc.setInfo(sectNum, bedNum: bedNum)
        }
    }
    
    
    //So that tapping on the view dismisses the keyboard
    @IBAction func dismissKeyboard(){
        notesField.resignFirstResponder()
    }

}

//Table View Extensions -- for harvest history table
extension CropViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let harvestList = crop.datesHarvested
        return harvestList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let harvestList = crop.datesHarvested
        let cell:UITableViewCell = self.cropHistoryTable.dequeueReusableCellWithIdentifier("harvestCell")! as UITableViewCell
        cell.textLabel?.text = harvestList[harvestList.count-1-indexPath.row].printSlash()
        
        return cell
    }
}

//Upon section click, show the bed list
extension CropViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}
