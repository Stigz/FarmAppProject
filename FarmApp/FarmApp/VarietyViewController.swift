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
    var variety: Variety!
    
    @IBOutlet weak var notesField: UITextView!
    //Title label
    @IBOutlet weak var seasonsLabel: UILabel!
    @IBOutlet weak var plantLabel: UILabel!
     @IBOutlet weak var weightLabel: UILabel!
    //Table for the bed history
    @IBOutlet weak var varietyTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "\(variety.name)"
        plantLabel.text = "Variety of \(variety.plant.name)"
        //Register table for cell class
        self.varietyTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "bedCell")
        
        // This will remove extra separators from tableview
        self.varietyTable.tableFooterView = UIView(frame: CGRectZero)
        // Do any additional setup after loading the view.
        
        if(variety.varietyWeight != nil){
            weightLabel.text = "You have harvested \(variety.varietyWeight)lbs total"
        }
        else{
            weightLabel.text = "You haven't harvested any \(variety.name) \(variety.plant.name)"
        }
        
        notesField.text = variety.notes
        
        //Setup seasons label
        if variety.bestSeasons.isEmpty {
            seasonsLabel.text = "No seasons entered"
        }else{
            seasonsLabel.text = ""
            for season in variety.bestSeasons {
                seasonsLabel.text = "\(seasonsLabel.text!)\(season), "
            }
        }
        seasonsLabel.text = seasonsLabel.text!.substringToIndex(seasonsLabel.text!.endIndex.advancedBy(-2))

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
          }
    
    func setInfo(variety: Variety){
        self.variety = variety
    }
    
    @IBAction func dismissKeyboard() {
        notesField.resignFirstResponder()
        LibraryAPI.sharedInstance.updateNotesForVariety(variety.plant.name, variety: variety.name, notes: notesField.text)
    }
    
}
//Table View Extensions -- for bedhistory table

extension VarietyViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return variety.bedHistory.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.varietyTable.dequeueReusableCellWithIdentifier("bedCell")! as UITableViewCell
        cell.textLabel?.text = "Planted in Bed \(variety.bedHistory[indexPath.row].data.1.id) on \(variety.bedHistory[indexPath.row].data.0.printSlash())"
        
        
        return cell
    }
}

