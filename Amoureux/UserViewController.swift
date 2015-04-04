//
//  ViewController.swift
//  CustomStuff
//
//  Created by Evan Dekhayser on 7/9/14.
//  Copyright (c) 2014 Evan Dekhayser. All rights reserved.
//

import UIKit

protocol UserViewControllerDelegate{
    func logout(flag : Int)
}

class UserViewController: UIViewController {
	var delegate:UserViewControllerDelegate?
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
    @IBAction func onBurger(sender: UIButton) {
        (tabBarController as TabBarController).sidebar.showInViewController(self, animated: true)
    }
    
    @IBAction func logoutButton(sender: UIButton) {
        delegate?.logout(-1)
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        prefs.setInteger(-1, forKey: "ISLOGGEDIN")
        self.performSegueWithIdentifier("gotoLogin", sender: self)
    }
    


}

