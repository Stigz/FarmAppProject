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
    @IBOutlet weak var currentCropLabel: UILabel!
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
        currentCropLabel.text = "Current Crop: \(plantedCrop.variety)"
        
        //Register table for cell class
        self.cropHistoryTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cropCell")
        
        // This will remove extra separators from tableview
        self.cropHistoryTable.tableFooterView = UIView(frame: CGRectZero)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setInfo(sectNum : Int, bed : Bed){
        self.sectNum = sectNum
        self.bed = bed
        self.plantedCrop = bed.currentCrop
        self.bedNum = bed.id
        self.cropHistory = bed.cropHistory
        self.numCropsInHistory = bed.cropHistory.numCrops
        self.cropList = bed.cropHistory.crops
    }
    
    @IBAction func close() {
        dismissViewControllerAnimated(true, completion: nil)
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
        cell.textLabel!.text = "\(crop.variety)"
        //Allow for multikle lines of text
        cell.detailTextLabel!.numberOfLines = 0
        //Set subtitle
        cell.detailTextLabel!.font = cell.detailTextLabel!.font.fontWithSize(8)
        cell.detailTextLabel!.text = "Planted: \(crop.datePlanted) \nHarvested: \(crop.dateHarvested)"
        
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
