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
    var requiredFields : [UITextField] = []
    var PickerViews : AddCropPickers!
    var plantNameField = UITextField!()
    var varietyNameField = UITextField!()
    
    //Static Variables
    let defaultVariety : String = "No variety selected"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup title
        self.navigationItem.title = "Add Crop"
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Save, target: self, action: Selector("addCrop")), animated: false)
        titleLabel.text = "Add crop to section \(sectNum), bed \(bedNum)"
        //Default notes are blank
        notesField.text = ""
        //Declare which fields are required
        requiredFields = [cropInputField,varietyInputField,dayInputField,monthInputField,yearInputField]
        //Setup pickers
        PickerViews = AddCropPickers(frame: CGRect(x: 0, y: 0, width: 0, height: 0), cropInputField: cropInputField, varietyInputView: varietyInputField)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Set info for controller
    func setInfo(sectNum: Int, bedNum : Int){
        self.sectNum = sectNum
        self.bedNum = bedNum
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
    
    //Gathers and checks the dates from the input fields
    //Called when a crop is added (and dates are input)
    func gatherDatesFromFields() -> Date?{
        if let day = Int(dayInputField.text!){
            if let month = Int(monthInputField.text!){
                if let year = Int(yearInputField.text!){
                    let theDate = Date(year: year, month: month, day: day)
                    if theDate.isValid(){
                        return theDate
                    }
                }
            }
        }
        //If unsuccessful in gathering date, inform user
        let alertController = UIAlertController(title: "Error!", message: "You have entered an invalid date! Please enter it in the form DD-MM-YYYY, and make sure that you have entered a valid date.", preferredStyle: UIAlertControllerStyle.Alert)
        //Allow dismissing the alert
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
        return nil
    }
    
    //Called when the "add" button is hit
    @IBAction func addCrop() {
        if checkFieldsFull(){
            //Get date from fields
            if let addDate = gatherDatesFromFields(){
                //Get crop from fields
                let newCrop = Crop(datePlanted: addDate, datesHarvested: [], notes: notesField.text, variety: PickerViews.getCurrentVariety()!, finalHarvest: nil, harvestWeights: [], totalWeight: 0, varietyName: PickerViews.getCurrentVariety()!.name)
                //Add crop to API
                LibraryAPI.sharedInstance.addCrop(newCrop,bedNum: bedNum,sectNum: sectNum)
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    /* ----------------------------------
    *  Add a new plant methods
    * ---------------------------------
    */
    @IBAction func addPlant(){
        let alertController = UIAlertController(title: "Add a new plant", message: "", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
        let add = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: newPlant)
        alertController.addAction(cancel)
        alertController.addAction(add)
        alertController.addTextFieldWithConfigurationHandler(addTextField)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func addTextField(textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = "Plant Name"
        plantNameField = textField
    }
    
    func newPlant(alert: UIAlertAction!){
        
        LibraryAPI.sharedInstance.addPlant(plantNameField.text!)
        PickerViews.addPlant(plantNameField.text!)
        
    }
    
    @IBAction func addVariety(){
        let alertController = UIAlertController(title: "Add a new variety", message: "", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
        let add = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: newVariety)
        alertController.addAction(cancel)
        alertController.addAction(add)
        alertController.addTextFieldWithConfigurationHandler(addTextFieldV)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func addTextFieldV(textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = "Variety Name"
        varietyNameField = textField
    }
    
    func newVariety(alert: UIAlertAction!){
        PickerViews.addVariety(varietyNameField.text!)
    }
}
