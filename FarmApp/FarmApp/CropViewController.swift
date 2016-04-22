//
//  CropViewController.swift
//  FarmApp
//
//  Created by Patrick Little on 16/02/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit

class CropViewController: UIViewController {
    
 /* ----------------------------
  * Saved variables
  * ----------------------------
  */

    //UI Outlets
    @IBOutlet weak var harvestButtonView: HarvestButtonsView!
    @IBOutlet weak var varietyLabel: UILabel!
    @IBOutlet weak var plantedLabel: UILabel!
    @IBOutlet weak var harvestedButton: UIButton!
    @IBOutlet weak var notesField: UITextView!
    @IBOutlet weak var cropHistoryTable: UITableView!
    @IBOutlet weak var weightLabel :UILabel!
    
    
    //Controller Instance Variables
    var crop : Crop!
    var bedNum : Int = 0
    var sectNum : Int = 0
    var isPlanted : Bool = false
    var historyIndex : Int = 0
    
 /* ---------------------------------------------
  * Initialization and de-initialization
  * ---------------------------------------------
  */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Set up labels
        self.navigationItem.title = crop.variety.plant.name
        plantedLabel.text = "Planted: \(crop.datePlanted.printSlash())"
        varietyLabel.text = "Variety: \(crop.variety.name)"
        weightLabel.text = "\(crop.totalWeight) LBS"
        
        //Setup notes
        notesField.text = crop.notes
        
        //update harvest button
        harvestButtonView.delegate = self
        updateHarvestButtonText()
        
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
        print(self.crop.variety.name)
    }
    
 /* ---------------------------------------------
  * Harvesting functions
  * ---------------------------------------------
  */
    
    //Shows the input fields, when user wants to harvest
    @IBAction func harvestNowButtonClicked() {
        updateViewForHarvest(false)
    }
    
    //Gathers and checks the dates from the input fields
    //Called when a crop is harvested (and dates are input)
    func gatherDatesFromFields() -> Date?{
        if let day = Int(harvestButtonView.getDayInput()!){
            if let month = Int(harvestButtonView.getMonthInput()!){
                if let year = Int(harvestButtonView.getYearInput()!){
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
    
    //Gathers the weight from the input fields
    //Called when crop is harvested
    func gatherWeightFromFields() -> Float?{
        if let weight = Float(harvestButtonView.getWeightInput()!){
            return weight
        }else{
            //If unsuccessful in gathering weight, inform user
            let alertController = UIAlertController(title: "Error!", message: "You have entered an invalid weight! Please make sure you have entered a number.", preferredStyle: UIAlertControllerStyle.Alert)
            //Allow dismissing the alert
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return nil
        }
    }
    
    //If the user wants to add a new crop, transition to 
    //add crop screen, and harvest crop on this screen
    func addNewCrop(action: UIAlertAction){
        //Segue to adding new crop
        performSegueWithIdentifier("addCropFromCrop", sender: self)
        cropHarvested(action)

    }
    
    //If the user harvests, then show the reflected change
    func cropHarvested(action: UIAlertAction){
        isPlanted = false
        updateViewForHarvest(true)
        
        
    }
    
    //Updates the vuiew when a crop is harvested
    func updateViewForHarvest(initialView : Bool){
        updateHarvestButtonText()
        if (initialView){
            //Reload table, in case crop has been harvested
            cropHistoryTable.reloadData()
        }
        //Harvest button is initially not hidden
        //Buttons view is initially hidden
        harvestedButton.hidden = !initialView
        harvestButtonView.hidden = initialView
    }
    
    func updateVarietyBedHistory(date: Date){
        LibraryAPI.sharedInstance.updateVarietyBedHistory(crop.variety, bedNum: bedNum, sectNum: sectNum, date: date)
    }
    
    
    //Updates text of the harvest button
    func updateHarvestButtonText(){
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
    
    func commonHarvestButtonClicked(final : Bool){
        if harvestButtonView.fieldsFilled(){
            if let harvestWeight = gatherWeightFromFields(){
                //Grab harvest date from fields
                if let newHarvest = gatherDatesFromFields() {
                    harvestButtonView.clearInputs()
                    if (final){
                        //Harvest crop (final harvest)
                        LibraryAPI.sharedInstance.finalHarvestForBed(sectNum, bedNum: bedNum, dateHarvested: newHarvest, harvestWeight: harvestWeight)
                        //Update crop for harvest
                        self.crop = LibraryAPI.sharedInstance.getCropFromHistory(sectNum, bedNum: bedNum, index: 0)
                        //Ask user if they would like to add a new crop
                        let alertController = UIAlertController(title: "Crop harvested!", message: "Would you like to add another crop to this bed now?", preferredStyle: UIAlertControllerStyle.Alert)
                        //If so, go to new add crop screen
                        alertController.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: addNewCrop))
                        //otherwise, update view
                        alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: cropHarvested))
                        self.presentViewController(alertController, animated: true, completion: nil)
                        updateVarietyBedHistory(newHarvest)
                    }else{
                        //Harvest crop
                        LibraryAPI.sharedInstance.harvestCropForBed(sectNum, bedNum: bedNum, dateHarvested: newHarvest, harvestWeight: harvestWeight)
                        //Update current crop for new harvest date
                        self.crop = LibraryAPI.sharedInstance.getCurrentCropForBed(sectNum, bedNum: bedNum)
                        //update view to show "harvest now" button
                        updateViewForHarvest(true)
                    }
                }
            }
        }else{
            //ALert user that they are missing information
            let alertController = UIAlertController(title: "Missing Information", message: "Please fill out all information before harvesting a crop.", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
 /* ---------------------------------------------
  * Miscellaneous Functions
  * ---------------------------------------------
  */
    
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
 /* ---------------------------------------------
  * Table View Extensions -- for harvest history table
  * ---------------------------------------------
  */
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
        cell.textLabel?.text = ("\(harvestList[harvestList.count-1-indexPath.row].printSlash())")
        
        return cell
    }
}

//Do nothing when a harvest date is clicked
extension CropViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}

 /*------------------------------------------------------------
  * Harvest Buttons View Extension -- for harvest input view
  *------------------------------------------------------------
  */

extension CropViewController: HarvestViewDelegate{
    func harvestButtonClicked(view : HarvestButtonsView){
        commonHarvestButtonClicked(false)
    }
    
    func finalHarvestButtonClicked(view : HarvestButtonsView){
        commonHarvestButtonClicked(true)
    }
}
