//
//  HarvestButtonsView.swift
//  FarmApp
//
//  Created by Patrick Little on 7/03/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit

@objc protocol HarvestViewDelegate {
    
    func harvestButtonClicked(view : HarvestButtonsView)
    
    func finalHarvestButtonClicked(view : HarvestButtonsView)
    
}

@IBDesignable class HarvestButtonsView: UIView {
    
    @IBOutlet weak var weightInputField: UITextField!
    @IBOutlet weak var dayInputField: UITextField!
    @IBOutlet weak var monthInputField: UITextField!
    @IBOutlet weak var yearInputField: UITextField!
    // Our custom view from the XIB file
    var view: UIView!
    
    weak var delegate: HarvestViewDelegate?

    //REquired coder init
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    //Init to set input fields
    override init(frame: CGRect) {
        super.init(frame : frame)
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        //Clear inputs
        clearInputs()
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "HarvestView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    func getDayInput() -> String?{
        return dayInputField.text
    }
    
    func getMonthInput() -> String?{
        return monthInputField.text
    }
    
    func getYearInput() -> String?{
        return yearInputField.text
    }
    
    func getWeightInput() -> String?{
        return weightInputField.text
    }
    
    func clearInputs(){
        dayInputField.text = ""
        monthInputField.text = ""
        yearInputField.text = ""
        weightInputField.text = ""
    }
    
    @IBAction func harvestButtonClicked() {
        if let delegate = delegate{
            delegate.harvestButtonClicked(self)
        }
        clearInputs()
    }
    @IBAction func finalHarvestButtonClicked() {
        if let delegate = delegate{
            delegate.finalHarvestButtonClicked(self)
        }
        clearInputs()
    }

}
