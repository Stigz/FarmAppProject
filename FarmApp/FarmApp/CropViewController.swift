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
                    let newHarvest = Date(year: year!, month: month!, day: day!)
                    crop.dateHarvested = newHarvest
                    //TO-DO: Set up a way for this to alert the bed that it no longer has this
                    //crop planted
                    showHarvestDate()
                }
            }
        }
        
    }
    
    //To show new harvest date
    func showHarvestDate(){
        harvestedButton.hidden = false
        harvestedButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        harvestedButton.setTitle("Harvested: \(crop.dateHarvested.printSlash())", forState: .Normal)
        harvestedButton.userInteractionEnabled = false
        enterDateLabel.hidden = true
        dayInput.hidden = true
        monthInput.hidden = true
        yearInput.hidden = true
        harvestButton.hidden = true
    }
    
    //So that tapping on the view dismisses the keyboard
    @IBAction func dismissKeyboard(){
        notesField.resignFirstResponder()
    }

}
