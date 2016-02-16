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
    
    var currentCrop : String = ""
    var bedNum : Int = 0
    var sectNum : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up title label
        topTitleLabel.text = "Section \(sectNum), Bed \(bedNum)"
        //Set up current crop label
        currentCropLabel.text = "Current Crop: \(currentCrop)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setInfo(sectNum : Int, currentCrop : String, bedNum : Int){
        self.sectNum = sectNum
        self.currentCrop = currentCrop
        self.bedNum = bedNum
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
