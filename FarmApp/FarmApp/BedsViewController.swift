//
//  BedsViewController.swift
//  FarmApp
//
//  Created by Patrick Little on 10/02/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit

class BedsViewController: UIViewController {
    
    var sectNum : Int = 0
    var beds : [Bed] = []
    var numBeds : Int = 0
    
    var currentBed : Bed!

    @IBOutlet weak var bedTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set section label
        self.navigationItem.title = "Section \(sectNum)"
        
        //Get bed list from API
        self.beds = LibraryAPI.sharedInstance.getBedsForSect(sectNum)
        self.numBeds = self.beds.count
        
        //Register table for cell class
        self.bedTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "bedCell")
        
        // This will remove extra separators from tableview
        self.bedTable.tableFooterView = UIView(frame: CGRectZero)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Sets up the info passed from section controller
    func setInfo(sectNum: Int){
        self.sectNum = sectNum
    }

    
    //For different segues away from this screen
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        //IF the user segues to a bed list, pass section info
        if (segue.identifier == "bedClicked"){
            let bvc = segue.destinationViewController as! BedViewController
            bvc.setInfo(sectNum, bedNum: currentBed.id)
        }
    
    }
    
  
    
    @IBAction func addBed(){
        LibraryAPI.sharedInstance.addBed((numBeds + 1) , sectID: (sectNum - 1))
        let sections = LibraryAPI.sharedInstance.getSects()
        print("pre \(beds)")
        beds = sections[sectNum - 1].beds
        print("after \(beds)")
        numBeds = beds.count
        bedTable.reloadData()
        
    
    }

}


//Table View Extensions -- for bed table
extension BedsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numBeds
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.bedTable.dequeueReusableCellWithIdentifier("bedCell")! as UITableViewCell
        cell.textLabel?.text = "Bed \(beds[indexPath.row].id)"
        //Set arrow accessory
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
}

//Upon section click, show the bed list
extension BedsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //To prepare for segue, set up current section
        currentBed = beds[indexPath.row]
        performSegueWithIdentifier("bedClicked", sender: self)
        //Unhighlight the selected section, in case user goes back
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}
