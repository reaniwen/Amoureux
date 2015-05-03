//
//  SettingViewController.swift
//  Amoureux
//
//  Created by 鸿烨 弓 on 15/4/28.
//  Copyright (c) 2015年 Firebase. All rights reserved.
//

import UIKit

class SettingViewController: FormViewController, FormViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var imgView: UIImage?
    
    struct Static {
        static let nameTag = "name"
        static let passwordTag = "password"
        static let lastNameTag = "lastName"
        static let emailTag = "email"
        static let URLTag = "url"
        static let phoneTag = "phone"
        static let enabled = "enabled"
        static let check = "check"
        static let segmented = "segmented"
        static let picker = "picker"
        static let birthday = "birthday"
        static let categories = "categories"
        
        static let button = "button"
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.loadForm()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .Bordered, target: self, action: "submit:")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Bordered, target: self, action: "back:")
    }
    
    /// MARK: Actions
    
    func submit(_: UIBarButtonItem!) {
        
        //let message = self.form.formValues().description
        
        let message = "Submit Succeed"
        let alert: UIAlertView = UIAlertView(title: "", message: message, delegate: nil, cancelButtonTitle: "OK")
        
        alert.show()
    }
    
    func back(_: UIBarButtonItem!){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    /// MARK: Private interface
    
    private func loadForm() {
        
        let form = FormDescriptor()
        
        form.title = "Settings"
        
        let section0 = FormSectionDescriptor()
        var row: FormRowDescriptor! = FormRowDescriptor(tag: Static.button, rowType: .Button, title: "Edit Profile")
        section0.addRow(row)
        row = FormRowDescriptor(tag: Static.button, rowType: .Button, title: "Upload")
        section0.addRow(row)
        
        let section1 = FormSectionDescriptor()
        
        row = FormRowDescriptor(tag: Static.nameTag, rowType: .Email, title: "Email")
        section1.addRow(row)
        
        row = FormRowDescriptor(tag: Static.passwordTag, rowType: .Password, title: "Password")
        section1.addRow(row)
        
        let section2 = FormSectionDescriptor()
        
        row = FormRowDescriptor(tag: Static.nameTag, rowType: .Text, title: "Name")
        section2.addRow(row)
        
        row = FormRowDescriptor(tag: Static.lastNameTag, rowType: .Text, title: "Last name")
        section2.addRow(row)
        
        let section3 = FormSectionDescriptor()
        
        row = FormRowDescriptor(tag: Static.URLTag, rowType: .URL, title: "URL")
        section3.addRow(row)
        
        row = FormRowDescriptor(tag: Static.phoneTag, rowType: .Phone, title: "Phone")
        section3.addRow(row)
        
        let section4 = FormSectionDescriptor()
        
        row = FormRowDescriptor(tag: Static.enabled, rowType: .BooleanSwitch, title: "Enable")
        section4.addRow(row)
        row = FormRowDescriptor(tag: Static.check, rowType: .BooleanCheck, title: "Doable")
        section4.addRow(row)
        row = FormRowDescriptor(tag: Static.segmented, rowType: .SegmentedControl, title: "Priority")
        row.options = [0, 1, 2, 3]
        row.titleFormatter = { value in
            switch( value ) {
            case 0:
                return "None"
            case 1:
                return "!"
            case 2:
                return "!!"
            case 3:
                return "!!!"
            default:
                return nil
            }
        }
        row.cellConfiguration = ["titleLabel.font" : UIFont.boldSystemFontOfSize(30.0), "segmentedControl.tintColor" : UIColor.redColor()]
        section4.addRow(row)
        
        section4.headerTitle = "An example header title"
        section4.footerTitle = "An example footer title"
        
        let section5 = FormSectionDescriptor()
        
        row = FormRowDescriptor(tag: Static.picker, rowType: .Picker, title: "Gender")
        row.options = ["F", "M", "U"]
        row.titleFormatter = { value in
            switch( value ) {
            case "F":
                return "Female"
            case "M":
                return "Male"
            case "U":
                return "I'd rather not to say"
            default:
                return nil
            }
        }
        section5.addRow(row)
        
        row = FormRowDescriptor(tag: Static.birthday, rowType: .Date, title: "Birthday")
        section5.addRow(row)
        row = FormRowDescriptor(tag: Static.categories, rowType: .MultipleSelector, title: "Categories")
        row.options = [0, 1, 2, 3, 4]
        row.titleFormatter = { value in
            switch( value ) {
            case 0:
                return "Restaurant"
            case 1:
                return "Pub"
            case 2:
                return "Shop"
            case 3:
                return "Hotel"
            case 4:
                return "Camping"
            default:
                return nil
            }
        }
        section5.addRow(row)
        
        let section6 = FormSectionDescriptor()
        
        row = FormRowDescriptor(tag: Static.button, rowType: .Button, title: "Log Out")
        section6.addRow(row)
        
        form.sections = [section0, section1, section2, section3, section4, section5, section6]
        
        self.form = form
    }
    
    /// MARK: FormViewControllerDelegate
    
    func formViewController(controller: FormViewController, didSelectRowDescriptor rowDescriptor: FormRowDescriptor) {
        if rowDescriptor.title == "Log Out" {
            self.view.endEditing(true)
            self.performSegueWithIdentifier("logout", sender: self)
        }else if rowDescriptor.title == "Edit Profile" {
            self.view.endEditing(true)
            editProfile()
        }else if rowDescriptor.title == "Upload" {
            self.view.endEditing(true)
            updateProfile()
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let theInfo:NSDictionary = info as NSDictionary
        
        let image = theInfo.objectForKey(UIImagePickerControllerEditedImage) as UIImage
        
        imgView = image
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func editProfile() {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = true
        
        self.presentViewController(image, animated: true, completion: nil)
    }
    
    func updateProfile() {
        
        let imageData = UIImagePNGRepresentation(self.imgView)
        let imageFile = PFFile(name: "profilePhoto.png", data: imageData)
        
        var query = PFQuery(className:"_User")
        query.getObjectInBackgroundWithId("\(PFUser.currentUser().objectId)") {
            (profile: PFObject?, error: NSError?) -> Void in
            if error != nil {
                println(error)
            } else if let profile = profile {
                profile["photo"] = imageFile
                profile.save()
            }
        }
    }
}

