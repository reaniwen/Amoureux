//
//  OtherNavController.swift
//  Amoureux
//
//  Created by 鸿烨 弓 on 15/4/17.
//  Copyright (c) 2015年 Firebase. All rights reserved.
//


import Foundation
import UIKit

class OtherNavController : UIViewController {
    
    @IBOutlet var label : UILabel!
    
    @IBAction func dismissNav(sender: AnyObject?){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "This is another ViewController. Tap the button above to dismiss it and show the navigation."
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
}
