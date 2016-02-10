//
//  ViewController.swift
//  FarmApp
//
//  Created by Patrick Little on 8/02/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //Table of beds
    @IBOutlet weak var bedTable: UITableView!
    //Number of beds in garden
    var numBeds = 5

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set default bed number
        numBeds = LibraryAPI.sharedInstance.getBeds().count
        
        //Register table for cell class
        self.bedTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

//Table View Extensions -- for bed table
extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numBeds
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.bedTable.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = LibraryAPI.sharedInstance.getBeds()[indexPath.row]
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //TODO: In order to keep MVC structure, just have this call the view's method
    }
}

