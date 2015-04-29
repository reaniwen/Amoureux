//
//  ViewController.swift
//  Amoureux
//
//  Created by Rean on 2/5/15.
//  Copyright (c) 2015 NYU. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    
    let context = LAContext()
    var error: NSError?
    
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
    override func viewDidAppear(animated: Bool){
        // check if Touch ID is available
        if context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate with Touch ID"
            context.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply:
                {(succes: Bool, error: NSError!) in
                    if succes {
                        self.showAlertController("Touch ID Authentication Succeeded")
                    }
                    else {
                        self.showAlertController("Touch ID Authentication Failed")
                    }
            })
        }
            
        else {
            showAlertController("Touch ID not available")
        }
    }
    func showAlertController(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alertController, animated: true, completion: nil)
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
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    
}

