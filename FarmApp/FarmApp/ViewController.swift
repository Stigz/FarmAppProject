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
    //Number of sections in garden
    var numSects = 5
    //Section list
    var sections : [Section] = []
    //NOTE: Only for the prepare for segue
    var currentSect : Section!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set default bed number
        sections = LibraryAPI.sharedInstance.getSects()
        numSects = sections.count
        
        //Register table for cell class
        self.sectionTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Used to set info for the bed screen
    //NOTE: right  now it does nothing -- info for
    //beds controller is set in init. Will this
    //work if you go back and click another sect?
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "sectClicked"){
            let bvc = segue.destinationViewController as! BedsViewController
            bvc.setInfo(currentSect)
        }
    }


}

//Table View Extensions -- for bed table
extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numSects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.sectionTable.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = "Section \(sections[indexPath.row].id)"
        
        return cell
    }
}

//Upon section click, show the bed list
extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //NOTE: Only for the prepare for segue
        currentSect = sections[indexPath.row]
        performSegueWithIdentifier("sectClicked", sender: self)
    }
}

