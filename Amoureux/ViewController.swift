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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let item1 = RMParallaxItem(image: UIImage(named: "item1")!, text: "SHARE LIGHTBOXES WITH YOUR TEAM")
        let item2 = RMParallaxItem(image: UIImage(named: "item2")!, text: "FOLLOW WORLD CLASS PHOTOGRAPHERS")
        let item3 = RMParallaxItem(image: UIImage(named: "item3")!, text: "EXPLORE OUR COLLECTION BY CATEGORY")
        
        let rmParallaxViewController = RMParallax(items: [item1, item2, item3], motion: false)
        rmParallaxViewController.completionHandler = {
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                rmParallaxViewController.view.alpha = 0.0
            })
        }
        
        // Adding parallax view controller.
        self.addChildViewController(rmParallaxViewController)
        self.view.addSubview(rmParallaxViewController.view)
        rmParallaxViewController.didMoveToParentViewController(self)
        
        // Do any additional setup after loading the view, typically from a nib.
        
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        emailTxt.frame = CGRectMake(40, 200, theWidth-80, 30)
        passwordTxt.frame = CGRectMake(40, 240, theWidth-80, 30)
        signinBtn.center = CGPointMake(theWidth/2, 330)
        signupBtn.center = CGPointMake(theWidth/2, theHeight-40)
        
    }
    
    override func viewDidAppear(animated: Bool){
        let context = LAContext()
        var error: NSError?
        // check if Touch ID is available
        if context.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate with Touch ID"
            context.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reason, reply:
                {(succes: Bool, error: NSError!) in
                    if succes {
                        self.showAlertController("Touch ID Authentication Succeeded")
                        self.performSegueWithIdentifier("gotoMainVCFromSigninVC", sender: self)
                    }
                    else {
                        self.showAlertController("Touch ID Authentication Failed")
                    }
            })
        }
            
        else {
            self.showAlertController("Touch ID not available")
            println("hahahah")
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
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    
}

