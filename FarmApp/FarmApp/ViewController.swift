//
//  ViewController.swift
//  FarmApp
//
//  Created by Patrick Little on 8/02/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Table of sections
    @IBOutlet weak var sectionTable: UITableView!
 
    //Section list
    var sections : [Section] = []
    //NOTE: Only for the prepare for segue
    var currentSect : Section!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set default bed number
        sections = LibraryAPI.sharedInstance.getSects()

        
        //Register table for cell class
        self.sectionTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        // This will remove extra separators from tableview
        self.sectionTable.tableFooterView = UIView(frame: CGRectZero)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func toCropList(){
        performSegueWithIdentifier("toCropList", sender: self)
        
    }
    
    @IBAction func addSection(){
        LibraryAPI.sharedInstance.addSection()
        sections = LibraryAPI.sharedInstance.getSects()
        sectionTable.reloadData()
    }
    
    
    
    /* ----------------------------------
    *  Deleting a Section methods
    * ---------------------------------
    */
    
    //the handler for the delete alert
    func deleteSection(alert: UIAlertAction){
        let removeIndex = sections.indexOf(currentSect)
        LibraryAPI.sharedInstance.deleteSection(removeIndex!)
        sections = LibraryAPI.sharedInstance.getSects()
        sectionTable.reloadData()
    }
    

    
    
    //For different segues away from this screen
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        //IF the user segues to a bed list, pass section info
        if (segue.identifier == "sectClicked"){
            let bvc = segue.destinationViewController as! BedsViewController
            bvc.setInfo(currentSect.id)
        }

    }



}

//Table View Extensions -- for section table
extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        
        let cell:UITableViewCell = self.sectionTable.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        cell.textLabel?.text = "Section \(sections[indexPath.row].id)"
        //Set arrow accessory
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
      
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        //maybe have it only ask twice if you want to delete plants
        if editingStyle == .Delete {
            let alertController = UIAlertController(title: "Are you sure you want to delete this section and all of its beds", message: "This cannot be undone", preferredStyle: .Alert)
            let delete = UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: deleteSection)
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(delete)
            currentSect = sections[indexPath.row]
            alertController.addAction(cancel)
            presentViewController(alertController, animated: true, completion: nil)
            
            //sort through plants until I find the one with the right name, delete it, refilter, redisplay
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
    // Override to support conditional editing of the table view.
    //This can return true or false based on whether its the farm manager using the app
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    
    
}



//Upon section click, show the bed list
extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //To prepare for segue, set up current section
        currentSect = sections[indexPath.row]
        performSegueWithIdentifier("sectClicked", sender: self)
        //Unhighlight the selected section, in case user goes back
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}

