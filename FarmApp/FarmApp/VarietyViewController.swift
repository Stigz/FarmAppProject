//
//  VarietyViewController.swift
//  FarmApp
//
//  Created by Molly Driscoll on 2/24/16.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

//
//  CropListViewController.swift
//  FarmApp
//
//  Created by Molly Driscoll on 2/20/16.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit


class VarietyViewController: UIViewController {
    

    //UI Outlets
    @IBOutlet weak var hiddenField: UITextField!
    @IBOutlet weak var notesField: UITextView!

    @IBOutlet weak var seasonsLabel: UILabel!
    @IBOutlet weak var plantLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    @IBOutlet weak var varietyTable: UITableView!
    
    //for adding a new variety
    var textField = UITextField!()
    
  
    
    //Controller instance variables
    var variety: Variety!
    var seasonsPicker : AddSeasonsPicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       

        //Register table for cell class
        self.varietyTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "bedCell")
        // This will remove extra separators from tableview
        self.varietyTable.tableFooterView = UIView(frame: CGRectZero)

        //Initialize labels
        weightLabel.text = "(Total harvested: \(variety.varietyWeight)lbs)"
        plantLabel.text = "Variety of \(variety.plant.name)"
        notesField.text = variety.notes
        


        
        //Initialize seasons picker
        seasonsPicker = AddSeasonsPicker(frame: CGRect(x: 50, y: 50, width: 200, height: 200), seasonsLabel: seasonsLabel, seasonsChosen: variety.bestSeasons, hiddenField: hiddenField)
        seasonsPicker.calculateSeasonsText()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Sets info passed from plant controller
    func setInfo(variety: Variety){
        self.variety = variety
        //Initialize title
        self.navigationItem.title = "\(variety.name)"
    }
    
 

    

    //Dismisses notes keyboard, and saves the new notes
    @IBAction func dismissKeyboard() {
        notesField.resignFirstResponder()
        LibraryAPI.sharedInstance.updateNotesForVariety(variety.plant.name, variety: variety.name, notes: notesField.text)
    }
    
    //Called when add season button is pressed
    //Show the picker
    @IBAction func addSeason() {
        seasonsPicker.showPicker()
    }
    
    @IBAction func editNameAlert(){
        let alertController = UIAlertController(title: "Edit the name \(variety.name)", message: "", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Edit", style: UIAlertActionStyle.Default, handler: editName)
        let add = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
        alertController.addAction(cancel)
        alertController.addAction(add)
        alertController.addTextFieldWithConfigurationHandler(addTextField)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func editName(alert : UIAlertAction!){
        let newName = textField.text!
        LibraryAPI.sharedInstance.editVarietyName(variety, newName: newName)
        //Initialize title
        //NOTE: plant view controller doesn't update variety name for a sec
        self.navigationItem.title = "\(variety.name)"
    }
    
    func addTextField(textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = ""
        self.textField = textField
    }
    
   
    
}
//Table View Extensions -- for bedhistory table

extension VarietyViewController: UITableViewDataSource {
    
    //Return number of beds in history
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return variety.bedHistory.count
    }
    
    //Format cell to show bed date and number
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.varietyTable.dequeueReusableCellWithIdentifier("bedCell")! as UITableViewCell

        cell.textLabel?.text = "Bed \(variety.bedHistory[indexPath.row].data.2), Section \(variety.bedHistory[indexPath.row].data.1) on \(variety.bedHistory[indexPath.row].data.0.printSlash())"
        
        
        return cell
    }
}

extension VarietyViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Unhighlight the selected section, in case user goes back
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}

