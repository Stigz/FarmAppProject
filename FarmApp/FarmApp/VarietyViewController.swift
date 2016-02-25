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
    
    //Title label
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var seasonsLabel: UILabel!
    @IBOutlet weak var plantLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
    //Table for the bed history
    @IBOutlet weak var varietyTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Variety: \(variety.name)"
        plantLabel.text = "This is a variety of \(variety.plant.name)"
        //seasonsLabel.text = "The best time to plant \(variety.name) is \(variety.bestSeasons[0])"
        //notesLabel.text = variety.notes
        //Register table for cell class
        self.varietyTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "bedCell")
        
        // This will remove extra separators from tableview
        self.varietyTable.tableFooterView = UIView(frame: CGRectZero)
        // Do any additional setup after loading the view.

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
    
    //Close the current screen -- back button clicked
    @IBAction func close() {
        dismissViewControllerAnimated(true, completion: nil)
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

