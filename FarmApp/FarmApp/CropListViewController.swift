//
//  CropListViewController.swift
//  FarmApp
//
//  Created by Molly Driscoll on 2/20/16.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit


class CropListViewController: UIViewController {
    
    //Table of sections
    @IBOutlet weak var plantTable: UITableView!
  
    //Number of sections in garden
    var numPlants = 0
    //Section list
    var plants : [Plant] = []
    //NOTE: Only for the prepare for segue
    var currentPlant : Plant!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        plants = LibraryAPI.sharedInstance.getAllPossiblePlants()
        numPlants = plants.count
        self.navigationItem.title = "Crop List" 
        
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




