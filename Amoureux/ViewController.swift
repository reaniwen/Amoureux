//
//  ViewController.swift
//  Amoureux
//
//  Created by Rean on 2/5/15.
//  Copyright (c) 2015 NYU. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UserViewControllerDelegate{
    
    @IBOutlet weak var usernameLabel: UILabel!
    var flag : Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func logout(flag: Int) {
        self.flag = flag
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let isLoggedIn:Int = prefs.integerForKey("ISLOGGEDIN") as Int
        if (isLoggedIn != 1  || self.flag == -1) {
            self.performSegueWithIdentifier("gotoLogin", sender: self)
        } else {
            
        }
    }
}

