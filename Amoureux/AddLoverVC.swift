//
//  AddLoverVC.swift
//  Amoureux
//
//  Created by Rean on 5/1/15.
//  Copyright (c) 2015 Firebase. All rights reserved.
//

import UIKit

class AddLoverVC: UIViewController {
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var inviteBtn: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func inviteAct(sender: AnyObject) {
        
        var selfFollow = PFObject(className: "follow")
        selfFollow["user"] = PFUser.currentUser().username
        selfFollow["userToFollow"] = PFUser.currentUser().username
        selfFollow.saveInBackgroundWithBlock {
            (success: Bool, error: NSError!) -> Void in
            if success {
                println("Add self to the follow table")
            }
        }
        
        var Follow = PFObject(className: "follow")
        Follow["user"] = PFUser.currentUser().username
        Follow["userToFollow"] = emailText.text
        Follow.saveInBackgroundWithBlock {
            (success: Bool, error: NSError!) -> Void in
            if success {
                println("Add invitation to the follow table")
            }
        }
        
        self.performSegueWithIdentifier("confirmAddSegue", sender: self)
        
    }


}
