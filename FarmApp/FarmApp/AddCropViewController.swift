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
    func setInfo(sectNum: Int, bedNum : Int){
        self.sectNum = sectNum
        self.bedNum = bedNum
    }
    
    //When cancel button is hit
    @IBAction func cancel() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
