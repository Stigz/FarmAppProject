//
//  BedsViewController.swift
//  FarmApp
//
//  Created by Patrick Little on 10/02/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit

class BedsViewController: UIViewController {
    
    var sectNum : Int = 0
    var beds : [String] = []
    var numBeds : Int = 3

    @IBOutlet weak var bedTable: UITableView!
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set section label
        self.testLabel.text = "Section \(sectNum)"
        
        //Register table for cell class
        self.bedTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "bedCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //Go back to section list
    @IBAction func backButtonClicked() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//TO-DO: Set up table extensions
//Table View Extensions -- for bed table
extension BedsViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numBeds
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.bedTable.dequeueReusableCellWithIdentifier("bedCell")! as UITableViewCell
        cell.textLabel?.text = "TEST"
        
        return cell
    }
}

//Upon section click, show the bed list
extension BedsViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //TO-DO: Hanfle Bed Click
    }
}
