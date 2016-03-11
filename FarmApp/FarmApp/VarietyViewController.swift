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
    

    @IBOutlet weak var seasonsLabel: UILabel!
    @IBOutlet weak var plantLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
     @IBOutlet weak var weightLabel: UILabel!
    //Table for the bed history
    @IBOutlet weak var varietyTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Variety: \(variety.name)"
        
        //seasonsLabel.text = "The best time to plant \(variety.name) is \(variety.bestSeasons[0])"
        //notesLabel.text = variety.notes
        //Register table for cell class
        self.varietyTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "bedCell")
        
        // This will remove extra separators from tableview
        self.varietyTable.tableFooterView = UIView(frame: CGRectZero)
        // Do any additional setup after loading the view.
        
        if(variety.varietyWeight != nil){
            weightLabel.text = "You have harvested \(variety.varietyWeight)Lbs of this"
        }
        else{
            weightLabel.text = "You haven't harvested any of \(variety.name) \(variety.plant.name)"
        }

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
    
  
}
//Table View Extensions -- for bedhistory table

extension VarietyViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return variety.bedHistory.beds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.varietyTable.dequeueReusableCellWithIdentifier("bedCell")! as UITableViewCell
        cell.textLabel?.text = "Planted in Bed: \(variety.bedHistory.beds[indexPath.row].id) in \(variety.bedHistory.dates[indexPath.row])"
        
        
        return cell
    }
}

