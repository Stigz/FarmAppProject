//
//  BedViewController.swift
//  FarmApp
//
//  Created by Patrick Little on 15/02/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit

class BedViewController: UIViewController {

    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var currentCropLabel: UILabel!
    @IBOutlet weak var cropHistoryTable: UITableView!
    
    var currentCrop : String = ""
    var bedNum : Int = 0
    var sectNum : Int = 0
    var bed : Bed!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up title label
        topTitleLabel.text = "Section \(sectNum), Bed \(bedNum)"
        //Set up current crop label
        currentCropLabel.text = "Current Crop: \(currentCrop)"
        
        //Register table for cell class
        self.cropHistoryTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cropCell")
        
        // This will remove extra separators from tableview
        self.cropHistoryTable.tableFooterView = UIView(frame: CGRectZero)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setInfo(sectNum : Int, bed : Bed){
        self.sectNum = sectNum
        self.bed = bed
        self.currentCrop = bed.currentCrop
        self.bedNum = bed.id
    }
    
    @IBAction func close() {
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

//Table View Extensions -- for bed table
extension BedViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.cropHistoryTable.dequeueReusableCellWithIdentifier("cropCell")! as UITableViewCell
        cell.textLabel?.text = "Bed"
        
        return cell
    }
}

//Upon section click, show the bed list
extension BedViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //To prepare for segue, set up current section
        //SET CROP HERE
        //THEN DO SEGUE
        //Unhighlight the selected section, in case user goes back
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
    }
}
