//
//  ViewController.swift
//  Amoureux
//
//  Created by Rean on 2/5/15.
//  Copyright (c) 2015 NYU. All rights reserved.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var signinBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    var kbHeight: CGFloat!
    var keyboardcount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTxt.delegate = self
        passwordTxt.delegate = self
        
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
                        self.performSegueWithIdentifier("indirect1", sender: self)
                    }
                    else {
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
                
                println("logInSucceed")
//                self.performSegueWithIdentifier("gotoMainVCFromSigninVC", sender: self)
                
                var queryExist = PFQuery(className: "follow")
                queryExist.whereKey("user", equalTo: PFUser.currentUser().username)
                queryExist.countObjectsInBackgroundWithBlock {
                    (count:Int32, error:NSError!) -> Void in
                    
                    if error == nil {
                        if count == 0 {
                            var queryFollow = PFQuery(className: "follow")
                            queryFollow.whereKey("userToFollow", equalTo: PFUser.currentUser().username)
                            queryFollow.countObjectsInBackgroundWithBlock {
                                (count:Int32, error:NSError!) -> Void in
    
                                if error == nil {
                                    if count == 0 {
                                        //add an invitation
                                        self.performSegueWithIdentifier("addInvitationSegue", sender: self)
                                    } else {
                                        //agree an invitation
                                        self.performSegueWithIdentifier("agreeInvitationSegue", sender: self)
                                    }
                                }
                            }
                            
                        } else {
                            self.performSegueWithIdentifier("indirect1", sender: self)
                        }
                    }
                }
            } else {
                println("error while logging in")
            }
            
        }
        
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    
    
    func animateTextField(up: Bool) {
        var movement = (up ? -kbHeight : kbHeight)
        
        UIView.animateWithDuration(0.3, animations: {
            self.view.frame = CGRectOffset(self.view.frame, 0, movement)
        })
    }
    
    override func viewWillAppear(animated:Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
                if (keyboardcount == 0){
                    kbHeight = keyboardSize.height
                    self.animateTextField(true)
                    keyboardcount++
                }
            }
            
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if (keyboardcount == 1){
            self.animateTextField(false)
            keyboardcount--
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
}

