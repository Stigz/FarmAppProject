//
//  CropViewController.swift
//  FarmApp
//
//  Created by Patrick Little on 16/02/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit

class CropViewController: UIViewController {

    //UI Outlets
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
    
    
    //Controller Instance Variables
    var crop : Crop!
    var bedNum : Int = 0
    var sectNum : Int = 0
    var isPlanted : Bool = false
    var historyIndex : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set up labels
        cropNameLabel.text = crop.variety.plant.name
        cropBedLabel.text = "Planted in section \(sectNum), bed \(bedNum)."
        plantedLabel.text = "Planted: \(crop.datePlanted.printSlash())"
        varietyLabel.text = "Variety: \(crop.variety.name)"
        
        //Setup notes
        notesField.text = crop.notes
        
        //update harvest button
        updateHarvestButtonView()
        
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
        self.historyIndex = index
        //Grab crop from API
        if(isPlanted){
            self.crop = LibraryAPI.sharedInstance.getCurrentCropForBed(sectNum, bedNum: bedNum)
        }else{
            self.crop = LibraryAPI.sharedInstance.getCropFromHistory(sectNum, bedNum: bedNum, index: index)
        }
    }
    
    //Close the current screen -- back button clicked
    @IBAction func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Update view if user wants to "harvest now!"
    @IBAction func harvest() {
        updateViewForHarvest(false)
    }
    
    //Gathers and checks the dates from the input fields
    //Called when a crop is harvested (and dates are input)
    func gatherDatesFromFields() -> Date?{
        if let day = Int(dayInput.text!){
            if let month = Int(monthInput.text!){
                if let year = Int(yearInput.text!){
                    let theDate = Date(year: year, month: month, day: day)
                    if theDate.isValid(){
                        return theDate
                    }
                }
            }
        }
        //If unsuccessful in gathering date, inform user
        let alertController = UIAlertController(title: "Error!", message: "You have entered an invalid date! Please enter it in the form DD-MM-YYYY.", preferredStyle: UIAlertControllerStyle.Alert)
        //Allow dismissing the alert
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        return nil
    }
    
    //TO enter the harvest date -- called when "harvest once" is clicked
    @IBAction func addHarvestDate() {
        //Grab harvest date from fields
        if let newHarvest = gatherDatesFromFields() {
            //Harvest crop
            LibraryAPI.sharedInstance.harvestCropForBed(sectNum, bedNum: bedNum, dateHarvested: newHarvest)
            //Update current crop for new harvest date
            self.crop = LibraryAPI.sharedInstance.getCurrentCropForBed(sectNum, bedNum: bedNum)
            //update view to show "harvest now" button
            updateViewForHarvest(true)
        }
    }
    
    //Called when final harvest button is clicked
    @IBAction func finalHarvest(){
        //Grab harvest date from fields
        if let newHarvest = gatherDatesFromFields() {
            //Harvest crop (final harvest)
            LibraryAPI.sharedInstance.finalHarvestForBed(sectNum, bedNum: bedNum, dateHarvested: newHarvest)
            //Update crop for harvest
            self.crop = LibraryAPI.sharedInstance.getCropFromHistory(sectNum, bedNum: bedNum, index: 0)
            //Ask user if they would like to add a new crop
            let alertController = UIAlertController(title: "Crop harvested!", message: "Would you like to add another crop to this bed now?", preferredStyle: UIAlertControllerStyle.Alert)
            //If so, go to new add crop screen
            alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: addNewCrop))
            //otherwise, update view
            alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: cropHarvested))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    //If the user wants to add a new crop, transition to 
    //add crop screen, and harvest crop on this screen
    func addNewCrop(action: UIAlertAction){
        //Segue to adding new crop
        performSegueWithIdentifier("addCropFromCrop", sender: self)
        cropHarvested(action)

    }
    
    //Updates the view for the harvest button
    func updateHarvestButtonView(){
        //If planted, allow for user to harvest
        if (isPlanted){
            harvestedButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
            harvestedButton.setTitle("Harvest now!", forState: .Normal)
        }else{ // If not planted, show harvest date
            harvestedButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            harvestedButton.setTitle("Harvested: \(crop.finalHarvest!.printSlash())", forState: .Normal)
            //to disallow clicking on the date
            harvestedButton.userInteractionEnabled = false
        }
    }
    
    //Updates the vuiew when a crop is harvested
    func updateViewForHarvest(initialView : Bool){
        updateHarvestButtonView()
        //Initially, clear all input fields
        if (initialView){
            dayInput.text = ""
            monthInput.text = ""
            yearInput.text = ""
            //Reload table, in case crop has been harvested
            cropHistoryTable.reloadData()
        }
        //Harvest button is initially noy hidden
        //Everything else is
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
    //And updates notes
    @IBAction func dismissKeyboard(){
        notesField.resignFirstResponder()
        if isPlanted{
            LibraryAPI.sharedInstance.updateNotesForCurrentCrop(sectNum, bedNum: bedNum, notes: notesField.text)
        }else{
            LibraryAPI.sharedInstance.updateNotesForCropInHistory(sectNum, bedNum: bedNum, index: historyIndex, notes: notesField.text)
        }
    }

}

//Table View Extensions -- for harvest history table
extension CropViewController: UITableViewDataSource {
    //Number of harvest dates
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let harvestList = crop.datesHarvested
        return harvestList.count
    }
    
    //What to display for harvest dates
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let harvestList = crop.datesHarvested
        let cell:UITableViewCell = self.cropHistoryTable.dequeueReusableCellWithIdentifier("harvestCell")! as UITableViewCell
        //The list ordering makes it go in reverse order (recent first)
        cell.textLabel?.text = harvestList[harvestList.count-1-indexPath.row].printSlash()
        
        return cell
    }
}

//Do nothing when a harvest date is clicked
extension CropViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}
