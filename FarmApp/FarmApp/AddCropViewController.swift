//
//  AddCropViewController.swift
//  FarmApp
//
//  Created by Patrick Little on 22/02/2016.
//  Copyright © 2016 Patrick Little. All rights reserved.
//

import UIKit

class AddCropViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    var sectNum : Int = 0
    var bedNum : Int = 0
    //We will need to unwind through the crop view
    //if we transitioned from the crop view, when
    //we cancel (rather than going straight back
    //to bed view)
    var needsUnwind : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = "Add crop to section \(sectNum), bed \(bedNum)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Set info for controller
    func setInfo(sectNum: Int, bedNum : Int, unwind: Bool){
        self.sectNum = sectNum
        self.bedNum = bedNum
        self.needsUnwind = unwind
    }
    
    //When cancel button is hit
    @IBAction func cancel() {
        if(needsUnwind){
            //If we came from crop view, unwind through there to keep data
            //updated
            performSegueWithIdentifier("unwindAddCropToCrop", sender: self)
        }else{
            //Else, go back to bed view
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}
