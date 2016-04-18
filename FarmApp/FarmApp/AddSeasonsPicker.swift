//
//  AddSeasonsPicker.swift
//  FarmApp
//
//  Created by Patrick Little on 22/03/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit

class AddSeasonsPicker: UIView, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var seasonsLabel : UILabel!
    @IBOutlet weak var hiddenField : UITextField!
    
    var seasonsChosen : [String]!
    var seasonsToChoose : [String] = ["Fall", "Spring"]
    let seasonPickerView = UIPickerView()
    
    //REquired coder init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    //Init to set input fields
    init(frame: CGRect, seasonsLabel : UILabel, seasonsChosen : [String], hiddenField : UITextField) {
        super.init(frame : frame)
        self.seasonsLabel = seasonsLabel
        self.seasonsChosen = seasonsChosen
        self.hiddenField = hiddenField
        commonInit()
    }
    
    //Common init method, setup plants and pickers
    func commonInit(){
        //Setup hidden field input view
        seasonPickerView.delegate = self
        hiddenField.inputView = seasonPickerView
        
        //Initialize toolbar for "done" button
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor.blueColor()
        toolBar.sizeToFit()
        
        //INitialize button
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "donePicker")
        
        //Setup toolbar
        toolBar.setItems([doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        //Add toolbar as to picker view
        hiddenField.inputAccessoryView = toolBar
    }
    
    //Called when "done" button is hit -- calculates season
    //text and resigns responder to hide picker
    func donePicker(){
        calculateSeasonsText()
        hiddenField.resignFirstResponder()
    }
    
    //Become the responder (which shows the picker since its the input view)
    func showPicker(){
        hiddenField.becomeFirstResponder()
    }
    
    //Based on the chosen seasons, will set the text of the seasons label
    func calculateSeasonsText(){
        if seasonsChosen.isEmpty {
            seasonsLabel.text = "No seasons entered"
        }else{
            seasonsLabel.text = ""
            for season in seasonsChosen {
                seasonsLabel.text = "\(seasonsLabel.text!)\(season), "
            }
            seasonsLabel.text = seasonsLabel.text!.substringToIndex(seasonsLabel.text!.endIndex.advancedBy(-2))
        }
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
        return 2
    }
    
    /* ----------------------------------
    *  PICKER VIEW DELEGATE METHODS
    * ---------------------------------
    */
    
    //The title of each picker row
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView{
        //Initialize row text
        let pickerLabel = UILabel()
        pickerLabel.text = seasonsToChoose[row]
        //Bold and bigger if chosen as a season
        if (seasonsChosen.contains(seasonsToChoose[row])){
            pickerLabel.textColor = UIColor.blackColor()
            pickerLabel.font = UIFont.boldSystemFontOfSize(20)
        }else{ //Smaller and gray if not yet chosen
            pickerLabel.textColor = UIColor.grayColor()
        }
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }
    
    //When a row is selected,
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //If this row is already selected, deselect it
        if(seasonsChosen.contains(seasonsToChoose[row])){
            seasonsChosen.removeAtIndex(seasonsChosen.indexOf(seasonsToChoose[row])!)
        }else{ //otherwise, select this row
            seasonsChosen.append(seasonsToChoose[row])
        }
        seasonPickerView.reloadAllComponents()
    }

}
