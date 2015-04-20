//
//  ViewController.swift
//  Amoureux
//
//  Created by Rean on 2/5/15.
//  Copyright (c) 2015 NYU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        emailTxt.frame = CGRectMake(40, 200, theWidth-80, 30)
        passwordTxt.frame = CGRectMake(40, 240, theWidth-80, 30)
        signinBtn.center = CGPointMake(theWidth/2, 330)
        signupBtn.center = CGPointMake(theWidth/2, theHeight-40)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func signInBtn(sender: AnyObject) {
        
        PFUser.logInWithUsernameInBackground(emailTxt.text, password: passwordTxt.text) {
            (user:PFUser!, error:NSError!) -> Void in
            
            if error == nil {
                
                println("logIn")
                self.performSegueWithIdentifier("gotoMainVCFromSigninVC", sender: self)
                
            } else {
                
                println("error")
            }
            
        }
        
    }
    
    
}

