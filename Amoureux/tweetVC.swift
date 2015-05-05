//
//  tweetVC.swift
//  twitterApp
//
//  Created by Valsamis Elmaliotis on 3/10/15.
//  Copyright (c) 2015 Valsamis Elmaliotis. All rights reserved.
//

import UIKit
import MobileCoreServices


extension UIImage {
    public func resize(size:CGSize, completionHandler:(resizedImage:UIImage, data:NSData)->()) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), { () -> Void in
            var newSize:CGSize = size
            let rect = CGRectMake(0, 0, newSize.width, newSize.height)
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            self.drawInRect(rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let imageData = UIImageJPEGRepresentation(newImage, 0.5)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completionHandler(resizedImage: newImage, data:imageData)
            })
        })
    }
}

class tweetVC: UIViewController, UITextViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var messageTxt: UITextView!
    @IBOutlet weak var charsLbl: UILabel!
    @IBOutlet weak var tweetBtn: UIButton!
    @IBOutlet weak var addPhotoBtn: UIButton!
    @IBOutlet weak var tweetImg: UIImageView!
    @IBOutlet weak var addimage: UIButton!
    var hasImage = false
    var newMedia: Bool?
    var cimage : UIImage?
    var comImage: CompressedImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height
        
        cancelBtn.center = CGPointMake(36, 50)
        messageTxt.frame = CGRectMake(5, 65, theWidth-10, 78)
        charsLbl.frame = CGRectMake(10, 150, 100, 30)
        tweetBtn.center = CGPointMake(theWidth-40, 170)
        addPhotoBtn.center = CGPointMake(46, 210)
        tweetImg.frame = CGRectMake(5, 226, theWidth-10, theWidth-10)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelBtn_click(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func textViewDidChange(textView: UITextView) {
        
        var len = messageTxt.text.utf16Count
        var diff = 90 - len
        
        if diff < 0 {
            
            charsLbl.textColor = UIColor.redColor()
        } else {
            
            charsLbl.textColor = UIColor.blackColor()
        }
        
        charsLbl.text = "\(diff) chars left"
        
    }
    
    
    @IBAction func tweetBtn_click(sender: AnyObject) {
        
        var theTweet = messageTxt.text
        var len = messageTxt.text.utf16Count
        
        if len > 90 {
            theTweet = theTweet.substringToIndex(advance(theTweet.startIndex, 90))
        }
        
        var tweetObj = PFObject(className: "tweets")
        tweetObj["userName"] = PFUser.currentUser().username
        tweetObj["profileName"] = PFUser.currentUser().valueForKey("profileName") as String
        tweetObj["photo"] = PFUser.currentUser().valueForKey("photo") as PFFile
        tweetObj["tweet"] = theTweet
        
        if hasImage == true {
            
            tweetObj["hasImage"] = "yes"
            
            let imageData = UIImagePNGRepresentation(self.tweetImg.image)
            let imageFile = PFFile(name: "tweetPhoto.png", data: imageData)
            tweetObj["tweetImage"] = imageFile
        } else {
            tweetObj["hasImage"] = "no"
        }
        tweetObj.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                println("add success")
            } else {
                // There was a problem, check error.description
                println("add failed")
            }
        }
        println("tweet!")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
//        
//        let theInfo:NSDictionary = info as NSDictionary
//        
//        let image:UIImage = theInfo.objectForKey(UIImagePickerControllerEditedImage) as UIImage
//        tweetImg.image = image
//        
//        hasImage = true
//        
//        self.dismissViewControllerAnimated(true, completion: nil)
//        
//        
//    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as NSString
        
        let theInfo:NSDictionary = info as NSDictionary
        

        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //if mediaType.isEqualToString(kUTTypeImage as NSString) {
            
            cimage = info[UIImagePickerControllerOriginalImage] as UIImage!
            //cimage = theInfo.objectForKey(UIImagePickerControllerEditedImage) as UIImage!
            hasImage = true
            //cimage = comImage?.CompressedJpeg(self.cimage, compressionTimes: 2)
            (cimage as UIImage!).resize(CGSizeMake(150, 150), completionHandler: { [weak self](resizedImage, data) -> () in
                
                var comimage = resizedImage as UIImage!
                var tvc: tweetVC
                tvc = self!
                tvc.tweetImg.image = comimage as UIImage!
                
                //self?.viewModel.imageData = data
                
            })
            tweetImg.image = self.cimage as UIImage!
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(cimage, self,
                    "image:didFinishSavingWithError:contextInfo:", nil)
            } else if mediaType.isEqualToString(kUTTypeMovie as NSString) {
                // Code to support video here
            }
            
        //}
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                message: "Failed to save image",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true,
                completion: nil)
        }
    }
    
    @IBAction func addPhotoBtn_click(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        
        self.presentViewController(image, animated: true, completion: nil)
        
    }
    @IBAction func takePhotoBtn_click(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.Camera
                imagePicker.mediaTypes = [kUTTypeImage as NSString]
                imagePicker.allowsEditing = false
                
                self.presentViewController(imagePicker, animated: true,
                    completion: nil)
                newMedia = true
        }
    }
    

}


