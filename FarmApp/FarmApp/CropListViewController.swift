//
//  CropListViewController.swift
//  FarmApp
//
//  Created by Molly Driscoll on 2/20/16.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit


class CropListViewController: UIViewController {
    
    //UI Outlets
    @IBOutlet weak var plantTable: UITableView!
    @IBOutlet weak var currentlyPlantedButton: UIButton!
  
    //Instance variables
    var numPlants = 0
    var plants : [Plant] = []
    var currentPlant : Plant! // for segue
    var showingCurrent : Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Grab plants
        plants = LibraryAPI.sharedInstance.getAllPossiblePlants()
        numPlants = plants.count
        
        //Setup text views
        updateCurrentlyPlantedText()
        
        //Register table for cell class
        self.plantTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "plantCell")
        
        // This will remove extra separators from tableview
       self.plantTable.tableFooterView = UIView(frame: CGRectZero)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        //IF the user segues to a bed list, pass section info
        if (segue.identifier == "plantClicked"){
            let pvc = segue.destinationViewController as! PlantViewController
            pvc.setInfo(currentPlant)
        }
       
        
    }

    //Fires when "currently planted button" is pressed
    //toggles showing all crops vs only planted crops
    @IBAction func currentlyPlantedButtonPressed() {
        //If showing only current, grab all possible
        if showingCurrent{
            plants = LibraryAPI.sharedInstance.getAllPossiblePlants()
        }else{//If showing all possible, grab only current
            plants = LibraryAPI.sharedInstance.getCurrentPlants()
        }
        //Update views and boolean
        showingCurrent = !showingCurrent
        updateCurrentlyPlantedText()
        plantTable.reloadData()
    }
    
    //Update all text relating to whether all crops are shown
    //or just planted ones
    func updateCurrentlyPlantedText(){
        if !showingCurrent {
            self.navigationItem.title = "All crops"
            currentlyPlantedButton.setTitle("Only show currently planted crops", forState: .Normal)
        }else{
            self.navigationItem.title = "Current Crops"
            currentlyPlantedButton.setTitle("Show all crops", forState: .Normal)
        }
    }
    
}
//Table View Extensions -- for section table
extension CropListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return plants.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.plantTable.dequeueReusableCellWithIdentifier("plantCell")! as UITableViewCell
        if(plants[indexPath.row].plant_weight != nil){
        cell.textLabel?.text = "\(plants[indexPath.row].name):    \(plants[indexPath.row].plant_weight)Lbs "
        }
        else{
            cell.textLabel?.text = "\(plants[indexPath.row].name)"
        }
        
        //Set arrow accessory
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
}

//Upon section click, show the bed list
extension CropListViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //To prepare for segue, set up current section
        currentPlant = plants[indexPath.row]
        performSegueWithIdentifier("plantClicked", sender: self)
        //Unhighlight the selected section, in case user goes back
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}




