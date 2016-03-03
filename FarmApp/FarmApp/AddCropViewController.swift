//
//  AddCropViewController.swift
//  FarmApp
//
//  Created by Patrick Little on 22/02/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit

class AddCropViewController: UIViewController {
    
    //UI Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cropInputField: UITextField!
    @IBOutlet weak var varietyInputField: UITextField!
    @IBOutlet weak var dayInputField: UITextField!
    @IBOutlet weak var monthInputField: UITextField!
    @IBOutlet weak var yearInputField: UITextField!
    @IBOutlet weak var notesField: UITextView!
    
    //Controller Instance Variables
    var sectNum : Int = 0
    var bedNum : Int = 0
    var cropOptions : [Plant]!
    var currentPlant : Plant?
    var currentVariety : Variety?
    var requiredFields : [UITextField] = []
    
    //Static Variables
    let defaultVariety : String = "No variety selected"
    
    
    //Picker Views
    let cropPickerView = UIPickerView()
    let varietyPickerView = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup title
        titleLabel.text = "Add crop to section \(sectNum), bed \(bedNum)"
        //Default notes are blank
        notesField.text = ""
        //Get options of crops to add
        cropOptions = LibraryAPI.sharedInstance.getAllPossiblePlants()
        //Declare which fields are required
        requiredFields = [cropInputField,varietyInputField,dayInputField,monthInputField,yearInputField]
        //Setup plants and pickers
        currentPlant = nil
        currentVariety = nil
        setupPickers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Create picker views and set as inputViews for
    // text fields
    func setupPickers(){
        cropPickerView.delegate = self
        cropInputField.inputView = cropPickerView
        varietyPickerView.delegate = self
        varietyInputField.inputView = varietyPickerView
    }
    
    //Set info for controller
    func setInfo(sectNum: Int, bedNum : Int){
        self.sectNum = sectNum
        self.bedNum = bedNum
    }
    
    //When cancel button is hit, dismiss page
    @IBAction func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Dismisses keyboard/pickers -- fires from tap event
    @IBAction func dismissResponders(){
        cropInputField.resignFirstResponder()
        varietyInputField.resignFirstResponder()
        dayInputField.resignFirstResponder()
        monthInputField.resignFirstResponder()
        yearInputField.resignFirstResponder()
        notesField.resignFirstResponder()
    }
    
    //Checks to see if a given field is empty,
    //used when adding a crop
    func checkField(field : String?) -> Bool{
        if (field == nil || field == "" || field == defaultVariety){
            //Alert the user of the empty field
            let alertController = UIAlertController(title: "Missing Information!", message: "Please make sure that you have filled in all required (*) fields!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return false
        }else{
            return true
        }
    }
    
    //Check to see if all required fields
    //have been populated
    func checkFieldsFull() -> Bool{
        for field in requiredFields {
            if (!checkField(field.text)){
                return false
            }
        }
        return true
    }
    
    //Called when the "add" button is hit
    @IBAction func addCrop() {
        if checkFieldsFull(){
            //Get date from fields
            let addDate = Date(year: Int(yearInputField.text!)!, month: Int(monthInputField.text!)!, day: Int(dayInputField.text!)!)
            //Get crop from fields
            let newCrop = Crop(datePlanted: addDate, datesHarvested: [], notes: notesField.text, variety: currentVariety!, finalHarvest: nil)
            //Add crop to API
            LibraryAPI.sharedInstance.addCrop(newCrop,bedNum: bedNum,sectNum: sectNum)
            //Notify BedController of a modification crop, and dismiss view
            NSNotificationCenter.defaultCenter().postNotificationName("CropModifiedNotification", object: self)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
}

//Extensions for picker view
extension AddCropViewController: UIPickerViewDataSource{
    //Only one component (the main list to pick from)
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    //The number of rows to pick from is the number of crop options
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //If crop picker is being used, return number of crops
        if(pickerView.isEqual(cropPickerView)){
            return cropOptions.count
        }else if(pickerView.isEqual(varietyPickerView)){
            //if variety picker is being used
            if((currentPlant) != nil){
                //if a plant is selected, return number of varieties
                return currentPlant!.varieties.count
            }else{
                //If no plant is selected, just sho "no crop selected"
                return 1
            }
        }
        return 0
    }
}

extension AddCropViewController: UIPickerViewDelegate{
    //The title of each picker row
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //If crop picker is being used, return crop name
        if(pickerView.isEqual(cropPickerView)){
            return cropOptions[row].name
        }else if(pickerView.isEqual(varietyPickerView)){
            //if variety picker is being used
            if((currentPlant) != nil){
                //if a plant is selected, return variety name
                return currentPlant!.varieties[row].name
            }else{
                //If no plant is selected, just sho "no crop selected"
                return "No crop selected"
            }
        }
        return "Error."
    }
    //When a row is selected,
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //If crop picker is being used, select crop and update variety picker
        if(pickerView.isEqual(cropPickerView)){
            cropInputField.text = cropOptions[row].name
            currentPlant = cropOptions[row]
            varietyPickerView.reloadAllComponents()
            varietyInputField.text = defaultVariety
            return
        }else if(pickerView.isEqual(varietyPickerView)){
            //if variety picker is being used
            if((currentPlant) != nil){
                //if a plant is selected, set selected variety
                varietyInputField.text = currentPlant!.varieties[row].name
                currentVariety = currentPlant!.varieties[row]
                return
            }else{
                //If no plant is selected, do nothing
                return
            }
        }
    }
}
