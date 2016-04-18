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
    var filteredPlants = [Plant]()
    var showingCurrent : Bool = false
    var plantNameField = UITextField!()

    //NOTE: Only for the prepare for segue
    var currentPlant : Plant!
    
    //creating the search controller
    var searchController: UISearchController!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Grab plants
        plants = LibraryAPI.sharedInstance.getAllPossiblePlants()
        numPlants = plants.count
                //Setup text views
        updateCurrentlyPlantedText()
        self.navigationItem.title = "Crop List"
        
        //Register table for cell class
        self.plantTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "plantCell")
        // This will remove extra separators from tableview
       self.plantTable.tableFooterView = UIView(frame: CGRectZero)
        
        
        //lets class know when things are typed in the search bar
       searchController = UISearchController(searchResultsController: nil)
       configureSearchController()
        
                

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
    
    
    /* ----------------------------------
    *  Search controller methods
    * ---------------------------------
    */
    
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

    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredPlants = plants.filter { plant in
            return plant.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        plantTable.reloadData()
    }
    
    //to solve search controller deallocation problems
    deinit {
        self.searchController.loadViewIfNeeded()    // iOS 9
        
    }
    
    
    /* ----------------------------------
    *  Currently planted button methods
    * ---------------------------------
    */

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
    
    
    /* ----------------------------------
    *  Add a new plant methods
    * ---------------------------------
    */
    @IBAction func addPlant(){
        let alertController = UIAlertController(title: "Add a new plant", message: "", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
        let add = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: newPlant)
        alertController.addAction(cancel)
        alertController.addAction(add)
        alertController.addTextFieldWithConfigurationHandler(addTextField)
        presentViewController(alertController, animated: true, completion: nil)
        }
    
    func addTextField(textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = "Plant Name"
        plantNameField = textField
    }
    
    func newPlant(alert: UIAlertAction!){
        LibraryAPI.sharedInstance.addPlant(plantNameField.text!)
        plants = LibraryAPI.sharedInstance.getAllPossiblePlants()
        //print(plants)
        plantTable.reloadData()
        //also refilter the plants?
 
    
    }

}

/* ----------------------------------
*  Table methods
* ---------------------------------
*/

//Table View Extensions -- for section table
extension CropListViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController != nil && searchController.active && searchController.searchBar.text != "" {
            return filteredPlants.count
        }
        return plants.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.plantTable.dequeueReusableCellWithIdentifier("plantCell")! as UITableViewCell
        if(searchController != nil && searchController.active && searchController.searchBar.text != "" ){
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
    
    // Override to support conditional editing of the table view.
    //This can return true or false based on whether its the farm manager using the app
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        //maybe have it only ask twice if you want to delete plants
//        if editingStyle == .Delete {
//            let alertController = UIAlertController(title: "Are you sure you want to delete this plant and all of its varieties", message: "This cannot be undone", preferredStyle: .Alert)
//            let delete = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: deletePlant)
//            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
//            alertController.addAction(delete)
//            //is it safe to reuse currentPlant here
//            if searchController.active && searchController.searchBar.text != "" {
//                currentPlant = filteredPlants[indexPath.row]
//            }
//            else{
//                currentPlant = plants[indexPath.row]
//            }
//            alertController.addAction(cancel)
//            presentViewController(alertController, animated: true, completion: nil)
//            
//            //sort through plants until I find the one with the right name, delete it, refilter, redisplay
//        } else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }
//    }
//    
//    
//    
//    
//}

    

    
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







