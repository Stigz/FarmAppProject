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
    
    var sectNum : Int = 0
    var bedNum : Int = 0
    var cropOptions : [Plant]!
    
    let cropPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setup title
        titleLabel.text = "Add crop to section \(sectNum), bed \(bedNum)"
        //Get options of crops to add
        cropOptions = LibraryAPI.sharedInstance.getAllPossiblePlants()
        setupCropPicker()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Create a picker view, and set it as input view for
    //text field
    func setupCropPicker(){
        cropPickerView.delegate = self
        cropInputField.inputView = cropPickerView
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
        return cropOptions.count
    }
}

extension AddCropViewController: UIPickerViewDelegate{
    //The title of each picker row is a crop name
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return cropOptions[row].name
    }
    //When a row is selected,
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        cropInputField.text = cropOptions[row].name
    }
}
