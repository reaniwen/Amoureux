//
//  IndirectPage.swift
//  Amoureux
//
//  Created by Xiao Zhang on 5/2/15.
//  Copyright (c) 2015 Firebase. All rights reserved.
//

import UIKit

class IndirectPage: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let background = UIImage(named: "nav-bg-2.png")
        self.view.backgroundColor = UIColor(patternImage: background!)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.performSegueWithIdentifier("indirect2", sender: self)
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
