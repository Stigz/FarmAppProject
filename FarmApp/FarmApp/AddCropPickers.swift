//
//  AddCropPickers.swift
//  FarmApp
//
//  Created by Patrick Little on 2/03/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit

class AddCropPickers: UIView, UIPickerViewDataSource, UIPickerViewDelegate{
    
    //InputFields passed from controller
    @IBOutlet weak var cropInputField: UITextField!
    @IBOutlet weak var varietyInputField: UITextField!
    
    //View Instance Variables
    var cropOptions : [Plant]!
    var currentPlant : Plant?
    var currentVariety : Variety?
    
    //Picker Views
    let cropPickerView = UIPickerView()
    let varietyPickerView = UIPickerView()
    
    //Static Variables
    let defaultVariety : String = "No variety selected"

    //REquired coder init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    //Init to set input fields
    init(frame: CGRect, cropInputField : UITextField, varietyInputView : UITextField) {
        super.init(frame : frame)
        self.cropInputField = cropInputField
        self.varietyInputField = varietyInputView
        commonInit()
    }
    
    //Common init method, setup plants and pickers
    func commonInit(){
        //Get options of crops to add
        cropOptions = LibraryAPI.sharedInstance.getAllPossiblePlants()
        //Setup plants and pickers
        currentPlant = nil
        currentVariety = nil
        setupPickers()
    }
    
    //Create picker views and set as inputViews for
    // text fields
    func setupPickers(){
        cropPickerView.delegate = self
        cropInputField.inputView = cropPickerView
        varietyPickerView.delegate = self
        varietyInputField.inputView = varietyPickerView
    }
    
    //Return currently selected variety back to controller
    func getCurrentVariety() -> Variety?{
        return currentVariety
    }
    
    /* ----------------------------------
     *  PICKERVIEW DATASOURCE METHODS
     * ---------------------------------
    */
    
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
    
    /* ----------------------------------
     *  PICKER VIEW DELEGATE METHODS
     * ---------------------------------
    */

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
