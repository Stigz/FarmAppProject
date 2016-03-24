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


class PlantViewController: UIViewController {
    
    //UI Outlets
    @IBOutlet weak var hiddenField: UITextField!
    @IBOutlet weak var seasonsLabel: UILabel!
    @IBOutlet weak var varietyTable: UITableView!
    @IBOutlet weak var notesField: UITextView!

    //Controller instance variables
    var numVarieties = 0
    var varieties : [Variety] = []
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

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    func setInfo(plant: Plant){
        self.plant = plant
        varieties = plant.varieties
        numVarieties = varieties.count
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        //IF the user segues to a bed list, pass section info
        if (segue.identifier == "varietyClicked"){
            let vvc = segue.destinationViewController as! VarietyViewController
            vvc.setInfo(currentVariety)
        }
        
        
    }
    
    //Dismisses notes keyboard, and saves the new notes
    @IBAction func dismissKeyboard() {
        notesField.resignFirstResponder()
        LibraryAPI.sharedInstance.updateNotesForPlant(plant.name, notes: notesField.text)
    }
    //Called when add season button is pressed
    //Show the picke
    @IBAction func addSeasons() {
        seasonsPicker.showPicker()
    }
}
//Table View Extensions -- for section table
extension PlantViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return varieties.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.varietyTable.dequeueReusableCellWithIdentifier("plantCell")! as UITableViewCell
        if(varieties[indexPath.row].varietyWeight != nil){
            cell.textLabel?.text = "\(varieties[indexPath.row].name):    \(varieties[indexPath.row].varietyWeight)Lbs "
        }
        else{
            cell.textLabel?.text = "\(varieties[indexPath.row].name)"
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





