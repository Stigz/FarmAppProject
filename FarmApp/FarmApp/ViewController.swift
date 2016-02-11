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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set default bed number
        numSects = LibraryAPI.sharedInstance.getSects().count
        
        //Register table for cell class
        self.sectionTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

//Table View Extensions -- for bed table
extension ViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numSects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.sectionTable.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        cell.textLabel?.text = "Section \(LibraryAPI.sharedInstance.getSects()[indexPath.row].id)"
        
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //TODO: In order to keep MVC structure, just have this call the view's method
    }
}

