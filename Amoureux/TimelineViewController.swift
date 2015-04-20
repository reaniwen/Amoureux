//
//  TimelineViewController.swift
//  Amoureux
//
//  Created by 鸿烨 弓 on 15/4/17.
//  Copyright (c) 2015年 Firebase. All rights reserved.
//

import Foundation
import UIKit

protocol UserViewControllerDelegate{
    func logout(flag : Int)
}

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet var tableView : UITableView!
    @IBOutlet var menuItem : UIBarButtonItem!
    @IBOutlet var toolbar : UIToolbar!
    var delegate:UserViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100.0;
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        menuItem.image = UIImage(named: "menu")
        toolbar.tintColor = UIColor.blackColor()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.row % 2 == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCell") as TimelineCell
            
            cell.typeImageView.image = UIImage(named: "timeline-chat")
            cell.profileImageView.image = UIImage(named: "profile-pic-1")
            cell.nameLabel.text = "John Hoylett"
            cell.postLabel?.text = "Checking out of the hotel today. It was really fun to see everyone and catch up. We should have more conferences like this so we can share ideas."
            cell.dateLabel.text = "2 mins ago"
            return cell
            
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("TimelineCellPhoto") as TimelineCell
            
            cell.typeImageView.image = UIImage(named: "timeline-photo")
            cell.profileImageView.image = UIImage(named: "profile-pic-2")
            cell.nameLabel.text = "Linda Hoylett"
            cell.photoImageView?.image = UIImage(named: "dish")
            cell.dateLabel.text = "2 mins ago"
            return cell
        }
    }
    
    @IBAction func logoutBtn(sender: UIBarButtonItem) {
        PFUser.logOut()
        //
        //        self.navigationController?.popToRootViewControllerAnimated(true)
        delegate?.logout(-1)
        var prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        prefs.setInteger(-1, forKey: "ISLOGGEDIN")
        self.performSegueWithIdentifier("gotoLogin", sender: self)
        
    }
    @IBAction func dismissNav(sender: AnyObject?){
        dismissViewControllerAnimated(true, completion: nil)
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
