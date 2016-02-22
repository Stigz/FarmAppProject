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
    @IBOutlet weak var plantedLabel: UILabel!
    @IBOutlet weak var harvestedButton: UIButton!
    
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

}
