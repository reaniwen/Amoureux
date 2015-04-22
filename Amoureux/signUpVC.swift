//
//  signUpVC.swift
//  twitterApp
//
//  Created by Valsamis Elmaliotis on 2/24/15.
//  Copyright (c) 2015 Valsamis Elmaliotis. All rights reserved.
//

import UIKit

class signUpVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var profileTxt: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var signupBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

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
                
                var followObj = PFObject(className: "follow")
                
                followObj["user"] = PFUser.currentUser().username
                followObj["userToFollow"] = PFUser.currentUser().username
                
                followObj.save()
                
                
                self.performSegueWithIdentifier("gotoMainVCFromSignupVC", sender: self)
                
            }
            
        }
        
        
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    

}
