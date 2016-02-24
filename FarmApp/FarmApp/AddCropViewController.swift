//
//  AddCropViewController.swift
//  FarmApp
//
//  Created by Patrick Little on 22/02/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit

class AddCropViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cropInputField: UITextField!
    @IBOutlet weak var varietyInputField: UITextField!
    
    var sectNum : Int = 0
    var bedNum : Int = 0
    var cropOptions : [Plant]!
    var currentPlant : Plant?
    var currentVariety : Variety?
    
    let cropPickerView = UIPickerView()
    let varietyPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup title
        titleLabel.text = "Add crop to section \(sectNum), bed \(bedNum)"
        //Get options of crops to add
        cropOptions = LibraryAPI.sharedInstance.getAllPossiblePlants()
        currentPlant = nil
        currentVariety = nil
        setupPickers()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Create a picker view, and set it as input view for
    //text field
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
    
    //When cancel button is hit
    @IBAction func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Dismisses the pickers -- fires from tap event
    @IBAction func dismissPickers(){
        cropInputField.resignFirstResponder()
        varietyInputField.resignFirstResponder()
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
            varietyInputField.text = "No Variety Selected"
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
