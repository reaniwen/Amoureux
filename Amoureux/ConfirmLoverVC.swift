//
//  confirmLoverVC.swift
//  Amoureux
//
//  Created by Rean on 5/1/15.
//  Copyright (c) 2015 Firebase. All rights reserved.
//

import UIKit

class ConfirmLoverVC: UIViewController {

    @IBOutlet weak var invitationLabel: UILabel!
    @IBOutlet weak var agreeBtn: UIButton!
    
    var applicant: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var query = PFQuery(className: "follow")
        query.whereKey("userToFollow", equalTo: PFUser.currentUser().username)

        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                var applicants = objects as [PFObject]
                self.applicant = applicants[0]["user"] as NSString
                self.invitationLabel.text = "\(self.applicant) ask you to join Amoureux"
            }else {
                println("Error: \(error) \(error.userInfo!)")
            }
        }


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func agreeAct(sender: AnyObject) {
        
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
        Follow["userToFollow"] = self.applicant
        Follow.saveInBackgroundWithBlock {
            (success: Bool, error: NSError!) -> Void in
            if success {
                println("corfirm invitation")
            }
        }
        
        self.performSegueWithIdentifier("confirmInvitationSegue", sender: self)
    }


}
