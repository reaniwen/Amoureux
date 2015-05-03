//
//  mainVC.swift
//  twitterApp
//
//  Created by Valsamis Elmaliotis on 3/1/15.
//  Copyright (c) 2015 Valsamis Elmaliotis. All rights reserved.
//

import UIKit

class mainVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var resultsTable: UITableView!
    
    var followArray = [String]()
    
    var resultsNameArray = [String]()
    var resulltsImageFiles = [PFFile]()
    var resultsTweetArray = [String]()
    var resultsHasImageArray = [String]()
    var resultsTweetImageFiles = [PFFile?]()
    
    var refresher:UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        resultsTable.frame = CGRectMake(0, 0, theWidth, theHeight)
        
        let tweetBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Compose, target: self, action: Selector("tweetBtn_click"))
        
//        let searchBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: Selector("searchBtn_click"))
        
        var buttonArray = NSArray(objects: tweetBtn)//, searchBtn)
        self.navigationItem.rightBarButtonItems = buttonArray
        
        refresher = UIRefreshControl()
        refresher.tintColor = UIColor.blackColor()
        refresher.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        self.resultsTable.addSubview(refresher)
        
    }
    
    func refresh() {
        
        println("refresh table")
        
        refreshResults()
        
    }
    
    func refreshResults() {
        
        followArray.removeAll(keepCapacity: false)
        resultsNameArray.removeAll(keepCapacity: false)
        resulltsImageFiles.removeAll(keepCapacity: false)
        resultsTweetArray.removeAll(keepCapacity: false)
        resultsHasImageArray.removeAll(keepCapacity: false)
        resultsTweetImageFiles.removeAll(keepCapacity: false)
        
        var followQuery = PFQuery(className: "follow")
        followQuery.whereKey("user", equalTo: PFUser.currentUser().username)
        followQuery.addDescendingOrder("createdAt")
        
        var objects = followQuery.findObjects()
        
        for object in objects {
            
            self.followArray.append(object.objectForKey("userToFollow") as String)
            
        }
        
        var query = PFQuery(className: "tweets")
        query.whereKey("userName", containedIn: followArray)
        query.addDescendingOrder("createdAt")
        
        query.findObjectsInBackgroundWithBlock {
            (objects:[AnyObject]!, error:NSError!) -> Void in
            
            if error == nil {
                
                for object in objects {
                    
                    self.resultsNameArray.append(object.objectForKey("profileName") as String)
                    self.resulltsImageFiles.append(object.objectForKey("photo") as PFFile)
                    self.resultsTweetArray.append(object.objectForKey("tweet") as String)
                    self.resultsHasImageArray.append(object.objectForKey("hasImage") as String)
                    self.resultsTweetImageFiles.append(object.objectForKey("tweetImage") as? PFFile)
                    
                    self.resultsTable.reloadData()
                    
                }
                
                self.refresher.endRefreshing()
                
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        
        self.navigationItem.hidesBackButton = true
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        refreshResults()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return resultsNameArray.count
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if resultsHasImageArray[indexPath.row] == "yes" {
            
            return self.view.frame.size.width - 10
            
            
        } else {
        
        
            return 90
            
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:mainCell = tableView.dequeueReusableCellWithIdentifier("Cell") as mainCell
        
        cell.tweetImg.hidden = true
        
        cell.profileLbl.text = self.resultsNameArray[indexPath.row]
        cell.messageTxt.text = self.resultsTweetArray[indexPath.row]
        
        resulltsImageFiles[indexPath.row].getDataInBackgroundWithBlock {
            (imageData:NSData!, error:NSError!) -> Void in
            
            
            if error == nil {
                
                let image = UIImage(data: imageData)
                cell.imgView.image = image
                
            }
            
        }
        
        if resultsHasImageArray[indexPath.row] == "yes" {
            
            let theWidth = view.frame.size.width
            
            cell.tweetImg.frame = CGRectMake(70, 70, theWidth-85, theWidth-85)
            cell.tweetImg.hidden = false
            
            resultsTweetImageFiles[indexPath.row]?.getDataInBackgroundWithBlock({
                (imageData:NSData!, error:NSError!) -> Void in
                
                if error == nil {
                    
                    let image = UIImage(data: imageData)
                    cell.tweetImg.image = image
                    
                }
                
            })
            
        }
        
        return cell
        
    }
    
    func tweetBtn_click() {
         
        println("tweet pressed")
        
        self.performSegueWithIdentifier("gotoTweetVCFromMainVC", sender: self)
        
    }
    
//    func searchBtn_click() {
//        
//        println("search pressed")
//        self.performSegueWithIdentifier("gotoUsersVCFromMainVC", sender: self)
//        
//    }
    
    @IBAction func logoutBtn(sender: AnyObject) {
        
        dismissViewControllerAnimated(true, completion: nil)
//        PFUser.logOut()
//        
//        self.navigationController?.popToRootViewControllerAnimated(true)
        
    }
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    

}
