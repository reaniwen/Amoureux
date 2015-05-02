//
//  signUpVC.swift
//  twitterApp
//
//  Created by Valsamis Elmaliotis on 2/24/15.
//  Copyright (c) 2015 Valsamis Elmaliotis. All rights reserved.
//

import UIKit

class signUpVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var profileTxt: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!
    var kbHeight: CGFloat!
    var keyboardcount = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emailTxt.delegate = self
        passwordTxt.delegate = self
        profileTxt.delegate = self
        
        // Do any additional setup after loading the view.
        
        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        emailTxt.frame = CGRectMake(100, 180, theWidth-110, 30)
        passwordTxt.frame = CGRectMake(100, 220, theWidth-110, 30)
        addBtn.center = CGPointMake(50, 150)
        imgView.frame = CGRectMake(10, 170, 80, 80)
        profileTxt.frame = CGRectMake(10, 270, theWidth-20, 30)
        signupBtn.center = CGPointMake(theWidth/2, profileTxt.frame.origin.y + 70)
        
        imgView.layer.cornerRadius = imgView.frame.size.width / 2
        imgView.clipsToBounds = true
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let theInfo:NSDictionary = info as NSDictionary
        
        let image = theInfo.objectForKey(UIImagePickerControllerEditedImage) as UIImage
        
        imgView.image = image
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    @IBAction func addPhotoBtn(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    
    
    @IBAction func signUpBtn(sender: AnyObject) {
        
        var user = PFUser()
        
        user.username = emailTxt.text
        user.password = passwordTxt.text
        user["profileName"] = profileTxt.text
        
        let imageData = UIImagePNGRepresentation(self.imgView.image)
        let imageFile = PFFile(name: "profilePhoto.png", data: imageData)
        
        user["photo"] = imageFile
        
        user.signUpInBackgroundWithBlock {
            (succeeded:Bool!, error:NSError!) -> Void in
            
            if error == nil {
                
                println("User Created!")
                
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
                                            self.performSegueWithIdentifier("addInvitationFromSignUp", sender: self)
                                    } else {
                                            //agree an invitation
                                            self.performSegueWithIdentifier("agreeInvitationFromSignUp", sender: self)
                                        }
                                }
                            }
                            
                        } else {
                            self.performSegueWithIdentifier("gotoMainVCFromSigninVC", sender: self)
                            }
                    }
                }
                
                
                
//                var followObj = PFObject(className: "follow")
//                
//                followObj["user"] = PFUser.currentUser().username
//                followObj["userToFollow"] = PFUser.currentUser().username
//                
//                followObj.save()
                
//                PFUser.logInWithUsernameInBackground(emailTxt.text, password: passwordTxt.text) {
//            (user:PFUser!, error:NSError!) -> Void in
//            
//            if error == nil {
//                
//                println("logInSucceed")
//                self.performSegueWithIdentifier("gotoMainVCFromSigninVC", sender: self)
//                
//                var queryExist = PFQuery(className: "follow")
//                queryExist.whereKey("user", equalTo: PFUser.currentUser().username)
//                queryExist.countObjectsInBackgroundWithBlock {
//                    (count:Int32, error:NSError!) -> Void in
//                    
//                    if error == nil {
//                        if count == 0 {
//                            var queryFollow = PFQuery(className: "follow")
//                            queryFollow.whereKey("userToFollow", equalTo: PFUser.currentUser().username)
//                            queryFollow.countObjectsInBackgroundWithBlock {
//                                (count:Int32, error:NSError!) -> Void in
//    
//                                if error == nil {
//                                    if count == 0 {
//                                        //add an invitation
//                                        self.performSegueWithIdentifier("gotoMainVCFromSigninVC", sender: self)
//                                    } else {
//                                        //agree an invitation
//                                        self.performSegueWithIdentifier("gotoMainVCFromSigninVC", sender: self)
//                                    }
//                                }
//                            }
//                            
//                        } else {
//                            self.performSegueWithIdentifier("gotoMainVCFromSigninVC", sender: self)
//                        }
//                    }
//                }
//            } else {
//                println("error while logging in")
//            }
//            
//        }

                self.performSegueWithIdentifier("gotoMainVCFromSignupVC", sender: self)
                
            }
            
        }
        
        
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
        self.navigationController?.navigationBarHidden = false
        
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
