//
//  CropListViewController.swift
//  FarmApp
//
//  Created by Molly Driscoll on 2/20/16.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit


class CropListViewController: UIViewController,  UISearchResultsUpdating {
    
    //UI Outlets
    @IBOutlet weak var plantTable: UITableView!
    @IBOutlet weak var currentlyPlantedButton: UIButton!
  
    //Instance variables
    var numPlants = 0
    var plants : [Plant] = []

    //NOTE: Only for the prepare for segue
    var currentPlant : Plant!
    let searchController = UISearchController(searchResultsController: nil)

    var showingCurrent : Bool = false

    
    var filteredPlants = [Plant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Grab plants
        plants = LibraryAPI.sharedInstance.getAllPossiblePlants()
        numPlants = plants.count
        self.navigationItem.title = "Crop List" 
        
        //Setup text views
        updateCurrentlyPlantedText()
        
        //Register table for cell class
        self.plantTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "plantCell")
        
        // This will remove extra separators from tableview
       self.plantTable.tableFooterView = UIView(frame: CGRectZero)
        // Do any additional setup after loading the view.
        
        //lets class know when things are typed
       configureSearchController()

        
    }
    
    func configureSearchController(){
        //notify the class when someone types
        searchController.searchResultsUpdater = self
        
        //get rid of annoying backgroud when searching
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
       
        //adds search controller to the top of the table
        plantTable.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false

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

    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
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


func filterContentForSearchText(searchText: String, scope: String = "All") {
    filteredPlants = plants.filter { plant in
        return plant.name.lowercaseString.containsString(searchText.lowercaseString)
    }

    plantTable.reloadData()
}

}


//Table View Extensions -- for section table
extension CropListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.active && searchController.searchBar.text != "" {
            return filteredPlants.count
        }
        return plants.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.plantTable.dequeueReusableCellWithIdentifier("plantCell")! as UITableViewCell
        if(searchController.active && searchController.searchBar.text != "" ){
            if(filteredPlants[indexPath.row].plant_weight != nil){
            cell.textLabel?.text = "\(filteredPlants[indexPath.row].name):    \(filteredPlants[indexPath.row].plant_weight)Lbs "
            }else{
                cell.textLabel?.text = "\(filteredPlants[indexPath.row].name)"
            }
            
        }
        else{
            if(plants[indexPath.row].plant_weight != nil){
                cell.textLabel?.text = "\(plants[indexPath.row].name):    \(plants[indexPath.row].plant_weight)Lbs "
            }else{
            cell.textLabel?.text = "\(plants[indexPath.row].name)"
            }
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
        if searchController.active && searchController.searchBar.text != "" {
           currentPlant = filteredPlants[indexPath.row]
        }
        else{
            currentPlant = plants[indexPath.row]
        }
        performSegueWithIdentifier("plantClicked", sender: self)
        //Unhighlight the selected section, in case user goes back
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}




