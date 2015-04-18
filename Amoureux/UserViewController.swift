//
//  ViewController.swift
//  Amoureux
//
//  Created by Rean on 2/5/15.
//  Copyright (c) 2015 NYU. All rights reserved.
//

import UIKit


class UserViewController: UIViewController {
	//var delegate:UserViewControllerDelegate?
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
    @IBAction func onBurger(sender: UIButton) {
        (tabBarController as TabBarController).sidebar.showInViewController(self, animated: true)
    }
    
    @IBAction func logoutButton(sender: UIButton) {
        //delegate?.logout(-1)
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        prefs.setInteger(-1, forKey: "ISLOGGEDIN")
        self.performSegueWithIdentifier("gotoLogin", sender: self)
    }
    


}

