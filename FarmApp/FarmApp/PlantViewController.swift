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

import UIKit


class PlantViewController: UIViewController {
    
    //Table of sections
    @IBOutlet weak var varietyTable: UITableView!
    //Title label
    @IBOutlet weak var titleLabel: UILabel!
    //seasons label
    @IBOutlet weak var seasonsLabel: UILabel!

    //Number of varieties in garden
    var numVarieties = 0
    //variety list
    var varieties : [Variety] = []
    //NOTE: Only for the prepare for segue
    var plant : Plant!
    var currentVariety: Variety!
    
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Register table for cell class
       self.varietyTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "plantCell")
        
        // This will remove extra separators from tableview
       self.varietyTable.tableFooterView = UIView(frame: CGRectZero)
        // Do any additional setup after loading the view.
        titleLabel.text = "\(plant.name)"
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
    
    //Close the current screen -- back button clicked
    @IBAction func close() {
        dismissViewControllerAnimated(true, completion: nil)
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





