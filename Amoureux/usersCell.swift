//
//  usersCell.swift
//  twitterApp
//
//  Created by Valsamis Elmaliotis on 3/2/15.
//  Copyright (c) 2015 Valsamis Elmaliotis. All rights reserved.
//

import UIKit

class usersCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var profileLbl: UILabel!
    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var followBtn: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let theWidth = UIScreen.mainScreen().bounds.width
        
        contentView.frame = CGRectMake(0, 0, theWidth, 64)
        
        imgView.center = CGPointMake(32, 32)
        imgView.layer.cornerRadius = imgView.frame.size.width / 2
        imgView.clipsToBounds = true
        profileLbl.frame = CGRectMake(70, 10, theWidth-75, 18)
        followBtn.center = CGPointMake(theWidth-50, 42)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func followBtn_click(sender: AnyObject) {
        
        let title = followBtn.titleForState(.Normal)
        
        if title == "Follow" {
            
            var followObj = PFObject(className: "follow")
            
            followObj["user"] = PFUser.currentUser().username
            followObj["userToFollow"] = usernameLbl.text
            
            followObj.save()
            
            followBtn.setTitle("Following", forState: UIControlState.Normal)
            
            
        } else {
            
            var query = PFQuery(className: "follow")
            
            query.whereKey("user", equalTo: PFUser.currentUser().username)
            query.whereKey("userToFollow", equalTo: usernameLbl.text)
            
            var objects = query.findObjects()
            
            for object in objects {
                
                object.delete()
                
            }
            
            followBtn.setTitle("Follow", forState: UIControlState.Normal)
            
        }
        
        
    }

}
