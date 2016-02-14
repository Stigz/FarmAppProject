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

    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.testLabel.text = "Section \(sectNum)"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //NOTE: On first sect click, cannot set label text,
    //as label has not yet been initialized -- will
    //this hold for clicking on another section? If so,
    //just set info in didLoad() -- if not, set info
    //here on subsequent clicks
    func setInfo(sect : Section){
        
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
