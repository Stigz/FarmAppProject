//
//  BedViewController.swift
//  FarmApp
//
//  Created by Patrick Little on 15/02/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit

class BedViewController: UIViewController {

    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var currentCropLabel: UIButton!
    @IBOutlet weak var cropHistoryTable: UITableView!
    
    var plantedCrop : Crop!
    var bedNum : Int = 0
    var sectNum : Int = 0
    var bed : Bed!
    var cropHistory : CropHistory!
    var numCropsInHistory : Int = 0
    var cropList : [Crop]!
    var clickedCrop : Crop!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up title label
        topTitleLabel.text = "Section \(sectNum), Bed \(bedNum)"
        //Set up current crop label
        currentCropLabel.setTitle("Current Crop: \(plantedCrop.variety.name)", forState: .Normal)
        
        //Register table for cell class
        self.cropHistoryTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cropCell")
        
        // This will remove extra separators from tableview
        self.cropHistoryTable.tableFooterView = UIView(frame: CGRectZero)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Set info passed from bed list
    func setInfo(sectNum : Int, bed : Bed){
        self.sectNum = sectNum
        self.bed = bed
        self.plantedCrop = bed.currentCrop
        self.bedNum = bed.id
        self.cropHistory = bed.cropHistory
        self.numCropsInHistory = bed.cropHistory.numCrops
        self.cropList = bed.cropHistory.crops
    }
    
    //Close the current screen -- back button clicked
    @IBAction func close() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Handle when the current crop is clicked
    //and transition to crop screen
    @IBAction func currentCropClicked() {
        clickedCrop = plantedCrop
        performSegueWithIdentifier("cropClicked", sender: self)
    }
    
    
    //For different segues away from this screen
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        //IF the user segues to a bed list, pass section info
        if (segue.identifier == "cropClicked"){
            let cvc = segue.destinationViewController as! CropViewController
            cvc.setInfo()
        }
    }

}

//Table View Extensions -- for bed table
extension BedViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numCropsInHistory
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.cropHistoryTable.dequeueReusableCellWithIdentifier("cropCell")! as UITableViewCell
        //Allow for subtitles to cell
        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle,
            reuseIdentifier: "cropCell")
        //Save current crop
        let crop = cropList[indexPath.row]
        cell.textLabel!.text = "\(crop.variety.name)"
        //Set subtitle
        cell.detailTextLabel!.font = cell.detailTextLabel!.font.fontWithSize(10)
        cell.detailTextLabel!.text = "\(crop.datePlanted.printSlash()) to \(crop.dateHarvested.printSlash())"
        
        return cell
    }
}

//Upon section click, show the bed list
extension BedViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //To prepare for segue, set up current section
        clickedCrop = cropList[indexPath.row]
        performSegueWithIdentifier("cropClicked", sender: self)
        //Unhighlight the selected section, in case user goes back
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}
