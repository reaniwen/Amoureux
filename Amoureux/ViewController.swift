//
//  ViewController.swift
//  Amoureux
//
//  Created by Rean on 2/5/15.
//  Copyright (c) 2015 NYU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        self.performSegueWithIdentifier("gotoLogin", sender: self)
    }

    @IBAction func logoutButton(sender: UIButton) {
        self.performSegueWithIdentifier("gotoLogin", sender: self)
    }
}

