//
//  SignUpViewController.swift
//  Amoureux
//
//  Created by Rean on 2/8/15.
//  Copyright (c) 2015 NYU. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    @IBOutlet weak var newUserName: UITextField!
    @IBOutlet weak var newPassWord: UITextField!
    @IBOutlet weak var conPassword: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signupButton(sender: UIButton) {
    }
    @IBAction func backtoLoginButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
