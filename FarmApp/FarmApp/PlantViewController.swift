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
        cell.textLabel?.text = "\(varieties[indexPath.row].name)"
        
        
        return cell
    }
}




