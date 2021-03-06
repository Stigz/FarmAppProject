//
//  PlantViewController.swift
//  FarmApp
//
//  Created by Molly Driscoll on 2/20/16.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit

//
//  CropListViewController.swift
//  FarmApp
//
//  Created by Molly Driscoll on 2/20/16.
//  Copyright © 2016 Patrick Little. All rights reserved.
//


class PlantViewController: UIViewController, UISearchResultsUpdating {
    

    
    //UI Outlets
    @IBOutlet weak var hiddenField: UITextField!

    @IBOutlet weak var seasonsLabel: UILabel!

    
    //creating the search controller
    var searchController : UISearchController!

    @IBOutlet weak var varietyTable: UITableView!
    @IBOutlet weak var notesField: UITextView!
    
    //for adding a new variety
    var textField = UITextField!()

    //Controller instance variables
    var numVarieties = 0
    var varieties : [Variety] = []
    var filteredVarieties = [Variety]()
    //NOTE: Only for the prepare for segue

    var plant : Plant!
    var currentVariety: Variety!
    var seasonsPicker : AddSeasonsPicker!
    
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(plant.name)"
        
        notesField.text = plant.notes
        
        //Initialize seasons picker
        seasonsPicker = AddSeasonsPicker(frame: CGRect(x: 50, y: 50, width: 200, height: 200), seasonsLabel: seasonsLabel, seasonsChosen: plant.bestSeasons, hiddenField: hiddenField)
        seasonsPicker.calculateSeasonsText()
        

        
        //Register table for cell class
       self.varietyTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "plantCell")
        
        // This will remove extra separators from tableview
       self.varietyTable.tableFooterView = UIView(frame: CGRectZero)

        // Do any additional setup after loading the view.
        searchController = UISearchController(searchResultsController: nil)
        configureSearchController()
    }
    
    //to solve search controller deallocation problems
    deinit {
        self.searchController.loadViewIfNeeded()    // iOS 9
       
    }
    
    func configureSearchController(){
        //notify the class when someone types
        searchController.searchResultsUpdater = self
        
        //get rid of annoying backgroud when searching
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        //adds search controller to the top of the table
        varietyTable.tableHeaderView = searchController.searchBar
        
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    
    func filterContentForSearchText(searchText: String, scope: String = "All") {
        filteredVarieties = varieties.filter { plant in
            return plant.name.lowercaseString.containsString(searchText.lowercaseString)
        }
        
        varietyTable.reloadData()
    }

    
 
    func setInfo(plant: Plant){
        self.plant = plant
        varieties = plant.varieties
        numVarieties = varieties.count
        
    }
    
    func resetInfo(){
        let plants = LibraryAPI.sharedInstance.getAllPossiblePlants()
        //not quite sure how this works, since the plant in plants and plants aren't equal
        //this is reseting the plant
        let newPlant = plants[plants.indexOf(plant)!]
        print(newPlant.name)
        plant = newPlant
        varieties = plant.varieties
        numVarieties = varieties.count
        varietyTable.reloadData()
        self.navigationItem.title = "\(plant.name)"
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        //IF the user segues to a bed list, pass section info
        if (segue.identifier == "varietyClicked"){
            let vvc = segue.destinationViewController as! VarietyViewController
            vvc.setInfo(currentVariety)

        }
        
        
    }
    
    @IBAction func editNameAlert(){
        let alertController = UIAlertController(title: "Edit the name \(plant.name)", message: "", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Edit", style: UIAlertActionStyle.Default, handler: editName)
        let add = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(cancel)
        alertController.addAction(add)
        alertController.addTextFieldWithConfigurationHandler(addTextField)
        presentViewController(alertController, animated: true, completion: nil)
        }
    
    func editName(alert : UIAlertAction!){
        let newName = textField.text!
        LibraryAPI.sharedInstance.editPlantName(plant, newName: newName)
        resetInfo()
    }

    
    @IBAction func addVariety(){
        let alertController = UIAlertController(title: "Add a new variety", message: "", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
        let add = UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: newVariety)
        alertController.addAction(cancel)
        alertController.addAction(add)
        alertController.addTextFieldWithConfigurationHandler(addTextField)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func addTextField(textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = ""
        self.textField = textField
    }
    
    func newVariety(alert: UIAlertAction!){
        LibraryAPI.sharedInstance.addVariety(textField.text!, plant: plant)
        resetInfo()
    }
    
    //Dismisses notes keyboard, and saves the new notes
    @IBAction func dismissKeyboard() {
        notesField.resignFirstResponder()
        LibraryAPI.sharedInstance.updateNotesForPlant(plant.name, notes: notesField.text)
    }
    //Called when add season button is pressed
    //Show the picker
    @IBAction func addSeasons() {
        seasonsPicker.showPicker()
    }
}
//Table View Extensions -- for section table
extension PlantViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchController != nil && searchController.active && searchController.searchBar.text != "" ){
            return filteredVarieties.count
        }else{
        return varieties.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.varietyTable.dequeueReusableCellWithIdentifier("plantCell")! as UITableViewCell
        if(searchController != nil && searchController.active && searchController.searchBar.text != "" ){
            if(filteredVarieties[indexPath.row].varietyWeight != nil){
            cell.textLabel?.text = "\(filteredVarieties[indexPath.row].name):    \(filteredVarieties[indexPath.row].varietyWeight)Lbs "
           
            }
            else{
                cell.textLabel?.text = "\(filteredVarieties[indexPath.row].name)"
            }
        }else{
            if(varieties[indexPath.row].varietyWeight != nil){
                cell.textLabel?.text = "\(varieties[indexPath.row].name):    \(varieties[indexPath.row].varietyWeight)Lbs "
            }
            else{
                cell.textLabel?.text = "\(varieties[indexPath.row].name)"
            }
        }
        //Set arrow accessory
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
}

extension PlantViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //To prepare for segue, set up current section
        currentVariety = varieties[indexPath.row]
        performSegueWithIdentifier("varietyClicked", sender: self)
        //Unhighlight the selected section, in case user goes back
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}





