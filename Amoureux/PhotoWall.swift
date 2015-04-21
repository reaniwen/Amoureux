//
//  Photowall.swift
//
//  Created by Xiao Zhang To on 2014-07-29.
//  Copyright (c) 2014 Meng To. All rights reserved.
//

import UIKit
import MobileCoreServices

class Home: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundMaskView: UIView!
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var favoritesLabel: UILabel!
    @IBOutlet weak var maskButton: UIButton!
    @IBOutlet weak var emailButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var shareLabelsView: UIView!
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var back: UIButton!
    
    var followArray = [String]()
    var oldnumber = -1
    var newMedia: Bool?
    var resulltsImageFiles = [PFFile]()
    var resultsHasImageArray = [String]()
    var resultsTweetImageFiles = [PFFile?]()
    
    
    @IBAction func maskButtonDidPress(sender: AnyObject) {
        spring(0.5) {
            self.maskButton.alpha = 0
        }
        hideShareView()
    }
    func showMask() {
        self.maskButton.hidden = false
        self.maskButton.alpha = 0
        spring(0.5) {
            self.maskButton.alpha = 1
        }
    }
    @IBAction func likeButtonDidPress(sender: AnyObject) {
        likeButton.hidden = true
        shareButton.hidden = true
        save.hidden = false
        back.hidden = false
    }


    @IBAction func BackPress(sender: AnyObject) {
        likeButton.hidden = false
        shareButton.hidden = false
        save.hidden = true
        back.hidden = true
    }

    
    
    @IBAction func SavePress(sender: AnyObject) {
    }
    @IBAction func shareButtonDidPress(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.SavedPhotosAlbum) {
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as NSString]
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true,
                    completion: nil)
                newMedia = false
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as NSString
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        if mediaType.isEqualToString(kUTTypeImage as NSString) {
            let image = info[UIImagePickerControllerOriginalImage]
                as UIImage
            
            
            imageButton.setImage(image, forState: UIControlState.Normal)
            backgroundImageView.image = image
            
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self,
                    "image:didFinishSavingWithError:contextInfo:", nil)
            } else if mediaType.isEqualToString(kUTTypeMovie as NSString) {
                // Code to support video here
            }
            
        }
    }
    
    func hideShareView() {
        spring(0.5) {
            self.shareView.transform = CGAffineTransformMakeTranslation(0, 0)
            self.dialogView.transform = CGAffineTransformMakeScale(1, 1)
            self.shareView.hidden = true
        }
    }
    
    @IBAction func userButtonDidPress(sender: AnyObject) {
        

    }
    
    @IBAction func imageButtonDidPress(sender: AnyObject) {
        

    }
    
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    var data = getData()
    var number = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        insertBlurView(backgroundMaskView, UIBlurEffectStyle.Dark)
        insertBlurView(headerView, UIBlurEffectStyle.Dark)
        
        animator = UIDynamicAnimator(referenceView: view)
        
        dialogView.alpha = 0
        save.hidden = true
        back.hidden = true
        println("hello")
    }
    
    override func viewWillAppear(animated: Bool) {
        refresh()
    }
    
    func refresh() {
        followArray.removeAll(keepCapacity: false)
        //        resultsNameArray.removeAll(keepCapacity: false)
        //        resulltsImageFiles.removeAll(keepCapacity: false)
        //        resultsTweetArray.removeAll(keepCapacity: false)
        resultsHasImageArray.removeAll(keepCapacity: false)
        resultsTweetImageFiles.removeAll(keepCapacity: false)
        
        var followQuery = PFQuery(className: "follow")
        followQuery.whereKey("user", equalTo: PFUser.currentUser().username)
        println(PFUser.currentUser().username)
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
                    
                    //                    self.resultsNameArray.append(object.objectForKey("profileName") as String)
                    //                    self.resulltsImageFiles.append(object.objectForKey("photo") as PFFile)
                    //                    self.resultsTweetArray.append(object.objectForKey("tweet") as String)
                    self.resultsHasImageArray.append(object.objectForKey("hasImage") as String)
                    if object.objectForKey("hasImage") as String == "yes" {
                        self.resulltsImageFiles.append(object.objectForKey("photo") as PFFile)
                        self.resultsTweetImageFiles.append(object.objectForKey("tweetImage") as? PFFile)
                    }
                    
                    
                }
                
                
            }
        }

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(Bool())
        
        if (number != oldnumber){
            let scale = CGAffineTransformMakeScale(0.5, 0.5)
            let translate = CGAffineTransformMakeTranslation(0, -200)
            dialogView.transform = CGAffineTransformConcat(scale, translate)
            spring(0.5) {
                let scale = CGAffineTransformMakeScale(1, 1)
                let translate = CGAffineTransformMakeTranslation(0, 0)
                self.dialogView.transform = CGAffineTransformConcat(scale, translate)
            }
            
            var image = UIImage()
            
            resulltsImageFiles[number].getDataInBackgroundWithBlock {
                (imageData:NSData!, error:NSError!) -> Void in
                
                
                if error == nil {
                    
                    self.avatarImageView.image = UIImage(data: imageData)
                    //cell.imgView.image = image
                    
                }
                
            }
            //avatarImageView.image = UIImage(named: data[number]["avatar"]!)
                
                resultsTweetImageFiles[number]?.getDataInBackgroundWithBlock({
                    (imageData:NSData!, error:NSError!) -> Void in
                    
                    if error == nil {
                        
                        image = UIImage(data: imageData)!
                        self.imageButton.setImage(image, forState: UIControlState.Normal)
                        //cell.tweetImg.image = image
                        
                    }
                    
                })
            
            //backgroundImageView.image = UIImage(named: data[number]["image"]!)
            //authorLabel.text = data[number]["author"]
            //titleLabel.text = data[number]["title"]
            dialogView.alpha = 1
            oldnumber = number
        }
        
        dialogView.alpha = 1
    }
    
    var animator : UIDynamicAnimator!
    var attachmentBehavior : UIAttachmentBehavior!
    var gravityBehaviour : UIGravityBehavior!
    var snapBehavior : UISnapBehavior!
    
    
    @IBAction func BackMenu(sender: UIButton) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBOutlet var panRecognizer: UIPanGestureRecognizer!
    
    @IBAction func handleGesture(sender: AnyObject) {
        let myView = dialogView
        let location = sender.locationInView(view)
        let boxLocation = sender.locationInView(dialogView)
        
        if sender.state == UIGestureRecognizerState.Began {
            animator.removeBehavior(snapBehavior)
            
            let centerOffset = UIOffsetMake(boxLocation.x - CGRectGetMidX(myView.bounds), boxLocation.y - CGRectGetMidY(myView.bounds));
            attachmentBehavior = UIAttachmentBehavior(item: myView, offsetFromCenter: centerOffset, attachedToAnchor: location)
            attachmentBehavior.frequency = 0
            
            animator.addBehavior(attachmentBehavior)
        }
        else if sender.state == UIGestureRecognizerState.Changed {
            attachmentBehavior.anchorPoint = location
        }
        else if sender.state == UIGestureRecognizerState.Ended {
            animator.removeBehavior(attachmentBehavior)
            
            snapBehavior = UISnapBehavior(item: myView, snapToPoint: view.center)
            animator.addBehavior(snapBehavior)
            
            let translation = sender.translationInView(view)
            if translation.y > 100 {
                animator.removeAllBehaviors()
                
                var gravity = UIGravityBehavior(items: [dialogView])
                gravity.gravityDirection = CGVectorMake(0, 10)
                animator.addBehavior(gravity)
            
                delay(0.3) {
                    self.refreshView()
                }
            }
        }
    }
    
    func refreshView() {
        number++
        if number >= self.resultsTweetImageFiles.count {
            println(self.resultsTweetImageFiles.count)
            number = 0
        }
        println(self.resultsTweetImageFiles.count)
        animator.removeAllBehaviors()
        
        snapBehavior = UISnapBehavior(item: dialogView, snapToPoint: view.center)
        attachmentBehavior.anchorPoint = view.center
        
        dialogView.center = view.center
        viewDidAppear(true)
        
    }
    
}
