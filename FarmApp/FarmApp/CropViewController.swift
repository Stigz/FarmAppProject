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
    
    //Initially hidden labels
    @IBOutlet weak var enterDateLabel: UILabel!
    @IBOutlet weak var dayInput: UITextField!
    @IBOutlet weak var monthInput: UITextField!
    @IBOutlet weak var yearInput: UITextField!
    @IBOutlet weak var harvestButton: UIButton!
    
    
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
            harvestedButton.setTitle("Harvested: \(crop.dateHarvested.printSlash())", forState: .Normal)
            //to disallow clicking on the date
            harvestedButton.userInteractionEnabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //For setting info passed from Bed controller
    func setInfo(crop : Crop, bedNum : Int, sectNum : Int, isPlanted: Bool){
        self.crop = crop
        self.bedNum = bedNum
        self.sectNum = sectNum
        self.isPlanted = isPlanted
    }
    
    //Close the current screen -- back button clicked
    @IBAction func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //When user wants to harvest the crop
    @IBAction func harvest() {
        harvestedButton.hidden = true
        enterDateLabel.hidden = false
        dayInput.hidden = false
        monthInput.hidden = false
        yearInput.hidden = false
        harvestButton.hidden = false
    }
    
    //TO enter the harvest date
    @IBAction func addHarvestDate() {
        if let day : Int? = Int(dayInput.text!){
            if let month : Int? = Int(monthInput.text!){
                if let year : Int? = Int(yearInput.text!){
                    //Add new harvest date
                    let newHarvest = Date(year: year!, month: month!, day: day!)
                    crop.dateHarvested = newHarvest
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
        //Notify bed of harvest
        NSNotificationCenter.defaultCenter().postNotificationName("CropHarvestedNotification", object: self, userInfo: ["crop":crop])
        //Segue to adding new crop
        performSegueWithIdentifier("addCropFromCrop", sender: self)
        //Update current screen to reflect harvest
        updateViewForHarvest()

    }
    
    //Updates the vuiew when a crop is harvested
    func updateViewForHarvest(){
        harvestedButton.hidden = false
        enterDateLabel.hidden = true
        dayInput.hidden = true
        monthInput.hidden = true
        yearInput.hidden = true
        harvestButton.hidden = true
        harvestedButton.setTitle("Harvested: \(crop.dateHarvested.printSlash())", forState: .Normal)
        harvestedButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        harvestedButton.userInteractionEnabled = false
    }
    
    //If the user harvests, but does not add a new crop
    //notify bed of harvest, and then show the reflected change
    func cropHarvested(action: UIAlertAction){
        NSNotificationCenter.defaultCenter().postNotificationName("CropHarvestedNotification", object: self, userInfo: ["crop":crop])
        updateViewForHarvest()
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
