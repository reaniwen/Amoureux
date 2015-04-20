//
//  usersVC.swift
//  twitterApp
//
//  Created by Valsamis Elmaliotis on 3/2/15.
//  Copyright (c) 2015 Valsamis Elmaliotis. All rights reserved.
//

import UIKit

class usersVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //@IBOutlet weak var resultsTable: UITableView!
    
    @IBOutlet weak var resultsTable: UITableView!
    var resultsNameArray = [String]()
    var resultsUserNameArray = [String]()
    var resultsImageFiles = [PFFile]()

    override func viewDidLoad() {
        super.viewDidLoad()

       let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        resultsTable.frame = CGRectMake(0, 0, theWidth, theHeight)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        resultsNameArray.removeAll(keepCapacity: false)
        resultsUserNameArray.removeAll(keepCapacity: false)
        resultsImageFiles.removeAll(keepCapacity: false)
        
        var query = PFUser.query()
        
        query.whereKey("username", notEqualTo: PFUser.currentUser().username)
        
        query.findObjectsInBackgroundWithBlock {
            (objects:[AnyObject]!, error:NSError!) -> Void in
            
            if error == nil {
                
                for object in objects {
                    
                    self.resultsNameArray.append(object.objectForKey("profileName") as String)
                    self.resultsImageFiles.append(object.objectForKey("photo") as PFFile)
                    self.resultsUserNameArray.append(object.objectForKey("username") as String)
                    
                    self.resultsTable.reloadData()
                    
                    
                }
                
            }
            
        }
        
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultsNameArray.count
        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 64
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:usersCell = tableView.dequeueReusableCellWithIdentifier("Cell") as usersCell
        
        cell.profileLbl.text = self.resultsNameArray[indexPath.row]
        cell.usernameLbl.text = self.resultsUserNameArray[indexPath.row]
        
        var query = PFQuery(className: "follow")
        
        query.whereKey("user", equalTo: PFUser.currentUser().username)
        query.whereKey("userToFollow", equalTo: cell.usernameLbl.text)
        
        query.countObjectsInBackgroundWithBlock {
            (count:Int32, error:NSError!) -> Void in
            
            if error == nil {
                
                if count == 0 {
                    
                    cell.followBtn.setTitle("Follow", forState: UIControlState.Normal)
                    
                } else {
                    
                    cell.followBtn.setTitle("Following", forState: UIControlState.Normal)
                }
                
            }
            
        }
        
        
        self.resultsImageFiles[indexPath.row].getDataInBackgroundWithBlock {
            (imageData:NSData!, error:NSError!) -> Void in
            
            if error == nil {
                
                let image = UIImage(data: imageData)
                cell.imgView.image = image
                
            }
            
        }
        
        return cell
        
    }
    
}
