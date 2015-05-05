//
//  NewChatViewController.swift
//  testChat
//
//  Created by Rean on 5/3/15.
//  Copyright (c) 2015 Rean. All rights reserved.
//

import UIKit
import Parse
import AudioToolbox

let messageFontSize: CGFloat = 17
let toolBarMinHeight: CGFloat = 44
let textViewMaxHeight: (portrait: CGFloat, landscape: CGFloat) = (portrait: 272, landscape: 90)
let messageSoundOutgoing: SystemSoundID = createMessageSoundOutgoing()
var dateFormatter = NSDateFormatter()

class NewChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
//    let chat: Chat = Chat(user: User(ID: 2, username: "samihah", firstName: "Angel", lastName: "Rao"), lastMessageText: "6 sounds good :-)", lastMessageSentDate: NSDate())
    var tableView: UITableView!
    var toolBar: UIToolbar!
    var textView: UITextView!
    var sendButton: UIButton!
    var rotating = false
    
    var messages = [PFObject]()
    var loadedMessages = [[NewMessage]]()
    var group: [String] = []

    
    override var inputAccessoryView: UIView! {
        get {
            if toolBar == nil {
                toolBar = UIToolbar(frame: CGRectMake(0, 0, 0, toolBarMinHeight-0.5))
                
                textView = InputTextView(frame: CGRectZero)
                textView.backgroundColor = UIColor(white: 250/255, alpha: 1)
                textView.delegate = self
                textView.font = UIFont.systemFontOfSize(messageFontSize)
                textView.layer.borderColor = UIColor(red: 200/255, green: 200/255, blue: 205/255, alpha:1).CGColor
                textView.layer.borderWidth = 0.5
                textView.layer.cornerRadius = 5
                //        textView.placeholder = "Message"
                textView.scrollsToTop = false
                textView.textContainerInset = UIEdgeInsetsMake(4, 3, 3, 3)
                toolBar.addSubview(textView)
                
                sendButton = UIButton.buttonWithType(.System) as UIButton
                sendButton.enabled = false
                sendButton.titleLabel?.font = UIFont.boldSystemFontOfSize(17)
                sendButton.setTitle("Send", forState: .Normal)
                sendButton.setTitleColor(UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 1), forState: .Disabled)
                sendButton.setTitleColor(UIColor(red: 1/255, green: 122/255, blue: 255/255, alpha: 1), forState: .Normal)
                sendButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
                sendButton.addTarget(self, action: "sendAction", forControlEvents: UIControlEvents.TouchUpInside)
                toolBar.addSubview(sendButton)
                
                // Auto Layout allows `sendButton` to change width, e.g., for localization.
                textView.setTranslatesAutoresizingMaskIntoConstraints(false)
                sendButton.setTranslatesAutoresizingMaskIntoConstraints(false)
                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .Left, relatedBy: .Equal, toItem: toolBar, attribute: .Left, multiplier: 1, constant: 8))
                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .Top, relatedBy: .Equal, toItem: toolBar, attribute: .Top, multiplier: 1, constant: 7.5))
                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .Right, relatedBy: .Equal, toItem: sendButton, attribute: .Left, multiplier: 1, constant: -2))
                toolBar.addConstraint(NSLayoutConstraint(item: textView, attribute: .Bottom, relatedBy: .Equal, toItem: toolBar, attribute: .Bottom, multiplier: 1, constant: -8))
                toolBar.addConstraint(NSLayoutConstraint(item: sendButton, attribute: .Right, relatedBy: .Equal, toItem: toolBar, attribute: .Right, multiplier: 1, constant: 0))
                toolBar.addConstraint(NSLayoutConstraint(item: sendButton, attribute: .Bottom, relatedBy: .Equal, toItem: toolBar, attribute: .Bottom, multiplier: 1, constant: -4.5))
            }
            return toolBar
        }
    }
    
//    init(chat: Chat) {
//        self.chat = chat
//        super.init(nibName: nil, bundle: nil)
//        title = chat.user.name
//    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //        fatalError("init(coder:) has not been implemented")
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        confirmGroup()
        
        //retriveMessages for the firse time
        retrieveMessages()
        
        NSTimer.scheduledTimerWithTimeInterval(3, target: self, selector: "onTimer", userInfo: nil, repeats: true)
        //get message
//        chat.loadedMessages.append([Message(incoming: false, text: textView.text, sentDate: NSDate())])
        
//        chat.loadedMessages = [
//            [
//                Message(incoming: true, text: "I really enjoyed programming with you! :-)", sentDate: NSDate(timeIntervalSinceNow: -60*60*24*2-60*60)),
//                Message(incoming: false, text: "Thanks! Me too! :-)", sentDate: NSDate(timeIntervalSinceNow: -60*60*24*2))
//            ],
//            [
//                Message(incoming: true, text: "Hey, would you like to spend some time together tonight and work on Acani?", sentDate: NSDate(timeIntervalSinceNow: -33)),
//                Message(incoming: false, text: "Sure, I'd love to. How's 6 PM?", sentDate: NSDate(timeIntervalSinceNow: -19)),
//                Message(incoming: true, text: "6 sounds good :-)", sentDate: NSDate())
//            ]
//        ]
        
        let whiteColor = UIColor.whiteColor()
        view.backgroundColor = whiteColor // smooths push animation
        
        tableView = UITableView(frame: view.bounds, style: .Plain)
        tableView.autoresizingMask = .FlexibleWidth | .FlexibleHeight
        tableView.backgroundColor = whiteColor
        let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: toolBarMinHeight, right: 0)
        tableView.contentInset = edgeInsets
        tableView.dataSource = self
        tableView.delegate = self
        tableView.keyboardDismissMode = .Interactive
        tableView.estimatedRowHeight = 44
        tableView.separatorStyle = .None
        tableView.registerClass(MessageSentDateCell.self, forCellReuseIdentifier: NSStringFromClass(MessageSentDateCell))
        view.addSubview(tableView)
        
        let notificationCenter = NSNotificationCenter.defaultCenter()
        notificationCenter.addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: "menuControllerWillHide:", name: UIMenuControllerWillHideMenuNotification, object: nil) // #CopyMessage
        
        // tableViewScrollToBottomAnimated(false) // doesn't work
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func onTimer() {
        retrieveMessages()
    }
    
    @IBAction func backBtn(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func confirmGroup(){
        var groupQuery = PFQuery(className: "follow")
        groupQuery.whereKey("user", equalTo: PFUser.currentUser().username)
        
        groupQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                var groups = objects as [PFObject]
                for p in groups{
                    self.group.append(p["userToFollow"]as NSString)
                }
            }else {
                println("Error: \(error) \(error.userInfo!)")
            }
        }
    }
    func retrieveMessages() {
//        var group:[String] = []
//        var groupQuery = PFQuery(className: "follow")
//        groupQuery.whereKey("user", equalTo: PFUser.currentUser().username)
//        
//        groupQuery.findObjectsInBackgroundWithBlock {
//            (objects: [AnyObject]!, error: NSError!) -> Void in
//            if error == nil {
//                var groups = objects as [PFObject]
//                for p in groups{
//                    group.append(p["userToFollow"]as NSString)
//                }
//            }else {
//                println("Error: \(error) \(error.userInfo!)")
//            }
//        }
//        
//        group = ["aaa@aa.com", "bbb@bb.com"]
        var query = PFQuery(className: "Message")
        
        //a temp solution to find if the sender is aaa or bbb
        query.whereKey("sender", containedIn: self.group)
        query.addAscendingOrder("time")
//        query.addDescendingOrder("time")
        
        //        query.whereKey("sender", equalTo: "aaa@aa.com")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                // The find Succeed/
                println("Successfully retrieved \(objects.count) messages.")
                
                //                for object in objects {
                //                    NSLog("%@", object.objectId)
                //                    println(object["text"] as? String)
                //                }
                
                var messages = objects as [PFObject]
                self.messages = messages
                for message in messages {
                    var incoming = true
                    if message["sender"] as NSString == PFUser.currentUser().username {
                        incoming = false
                    }
                    self.loadedMessages.append([NewMessage(incoming: incoming, text: message["text"] as NSString, sentDate: message["time"] as NSDate)])
                }
                self.tableView.reloadData()
//                self.messageTableView.reloadData()
                var lastIndex = NSIndexPath(forRow: self.messages.count - 1, inSection: 0)
//                self.messageTableView.scrollToRowAtIndexPath(lastIndex, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }else {
                println("Error: \(error) \(error.userInfo!)")
            }
        }
        
        loadedMessages = []
        
        
    }
    
    override func viewDidAppear(animated: Bool)  {
        super.viewDidAppear(animated)
        tableView.flashScrollIndicators()
    }
    
//    override func viewWillDisappear(animated: Bool)  {
//        super.viewWillDisappear(animated)
//        chat.draft = textView.text
//    }
    
    // This gets called a lot. Perhaps there's a better way to know when `view.window` has been set?
//    override func viewDidLayoutSubviews()  {
//        super.viewDidLayoutSubviews()
//        
//        if !chat.draft.isEmpty {
//            textView.text = chat.draft
//            chat.draft = ""
//            textViewDidChange(textView)
//            textView.becomeFirstResponder()
//        }
//    }
    
    //    // #iOS7.1
    override func willAnimateRotationToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        super.willAnimateRotationToInterfaceOrientation(toInterfaceOrientation, duration: duration)
        
        if UIInterfaceOrientationIsLandscape(toInterfaceOrientation) {
            if toolBar.frame.height > textViewMaxHeight.landscape {
                toolBar.frame.size.height = textViewMaxHeight.landscape+8*2-0.5
            }
        } else { // portrait
            updateTextViewHeight()
        }
    }
    //    // #iOS8
    //    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator!) {
    //        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
    //    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return loadedMessages.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return loadedMessages[section].count + 1 // for sent-date cell
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(MessageSentDateCell), forIndexPath: indexPath) as MessageSentDateCell
            if loadedMessages.count > 0 && loadedMessages[indexPath.section].count > 0 {
                let message = loadedMessages[indexPath.section][0]
                dateFormatter.dateStyle = .ShortStyle
                dateFormatter.timeStyle = .ShortStyle
                cell.sentDateLabel.text = dateFormatter.stringFromDate(message.sentDate)
            }
            //cell.sentDateLabel.text = dateFormatter.stringFromDate(message.sentDate)
            return cell
        } else {
            let cellIdentifier = NSStringFromClass(MessageBubbleCell)
            var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as MessageBubbleCell!
            if cell == nil {
                cell = MessageBubbleCell(style: .Default, reuseIdentifier: cellIdentifier)
                
                // Add gesture recognizers #CopyMessage
                let action: Selector = "messageShowMenuAction:"
                let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: action)
                doubleTapGestureRecognizer.numberOfTapsRequired = 2
                cell.bubbleImageView.addGestureRecognizer(doubleTapGestureRecognizer)
                cell.bubbleImageView.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: action))
            }
            if loadedMessages.count > 0 && loadedMessages[indexPath.section].count > 0 {
                let message = loadedMessages[indexPath.section][indexPath.row-1]
                cell.configureWithMessage(message)
            }
            return cell
        }
    }
    
    // Reserve row selection #CopyMessage
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil
    }
    
    func textViewDidChange(textView: UITextView) {
        updateTextViewHeight()
        sendButton.enabled = textView.hasText()
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let userInfo = notification.userInfo as NSDictionary!
        let frameNew = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        let insetNewBottom = tableView.convertRect(frameNew, fromView: nil).height
        let insetOld = tableView.contentInset
        let insetChange = insetNewBottom - insetOld.bottom
        let overflow = tableView.contentSize.height - (tableView.frame.height-insetOld.top-insetOld.bottom)
        
        let duration = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as NSNumber).doubleValue
        let animations: (() -> Void) = {
            if !(self.tableView.tracking || self.tableView.decelerating) {
                // Move content with keyboard
                if overflow > 0 {                   // scrollable before
                    self.tableView.contentOffset.y += insetChange
                    if self.tableView.contentOffset.y < -insetOld.top {
                        self.tableView.contentOffset.y = -insetOld.top
                    }
                } else if insetChange > -overflow { // scrollable after
                    self.tableView.contentOffset.y += insetChange + overflow
                }
            }
        }
        if duration > 0 {
            let options = UIViewAnimationOptions(UInt((userInfo[UIKeyboardAnimationCurveUserInfoKey] as NSNumber).integerValue << 16)) // http://stackoverflow.com/a/18873820/242933
            UIView.animateWithDuration(duration, delay: 0, options: options, animations: animations, completion: nil)
        } else {
            animations()
        }
    }
    
    func keyboardDidShow(notification: NSNotification) {
        let userInfo = notification.userInfo as NSDictionary!
        let frameNew = (userInfo[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        let insetNewBottom = tableView.convertRect(frameNew, fromView: nil).height
        
        // Inset `tableView` with keyboard
        let contentOffsetY = tableView.contentOffset.y
        tableView.contentInset.bottom = insetNewBottom
        tableView.scrollIndicatorInsets.bottom = insetNewBottom
        // Prevents jump after keyboard dismissal
        if self.tableView.tracking || self.tableView.decelerating {
            tableView.contentOffset.y = contentOffsetY
        }
    }
    
    func updateTextViewHeight() {
        let oldHeight = textView.frame.height
        let maxHeight = UIInterfaceOrientationIsPortrait(interfaceOrientation) ? textViewMaxHeight.portrait : textViewMaxHeight.landscape
        var newHeight = min(textView.sizeThatFits(CGSize(width: textView.frame.width, height: CGFloat.max)).height, maxHeight)
        #if arch(x86_64) || arch(arm64)
            newHeight = ceil(newHeight)
            #else
            newHeight = CGFloat(ceilf(newHeight.native))
        #endif
        if newHeight != oldHeight {
            toolBar.frame.size.height = newHeight+8*2-0.5
        }
    }
    
    func sendAction() {
        // Autocomplete text before sending #hack
        textView.resignFirstResponder()
        textView.becomeFirstResponder()
        
        var message = PFObject(className: "Message")
        
        message["text"] = textView.text
        message["time"] = NSDate()
        message["sender"] = PFUser.currentUser().username//talkGroup[0] //sender
        
        
        message.saveInBackgroundWithBlock {
            (success: Bool, error: NSError!) -> Void in
            if success {
                println("Message saved successfully")
            }
        }
        
//        chat.loadedMessages.append([Message(incoming: false, text: textView.text, sentDate: NSDate())])
        textView.text = nil
        updateTextViewHeight()
        sendButton.enabled = false
        
        retrieveMessages()
        
//        let lastSection = tableView.numberOfSections()
//        tableView.beginUpdates()
//        tableView.insertSections(NSIndexSet(index: lastSection), withRowAnimation: .Automatic)
//        tableView.insertRowsAtIndexPaths([
//            NSIndexPath(forRow: 0, inSection: lastSection),
//            NSIndexPath(forRow: 1, inSection: lastSection)
//            ], withRowAnimation: .Automatic)
//        tableView.endUpdates()
//        tableViewScrollToBottomAnimated(true)
//        AudioServicesPlaySystemSound(messageSoundOutgoing)
    }
    

    
    func tableViewScrollToBottomAnimated(animated: Bool) {
        let numberOfRows = tableView.numberOfRowsInSection(0)
        if numberOfRows > 0 {
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: numberOfRows-1, inSection: 0), atScrollPosition: .Bottom, animated: animated)
        }
    }
    
    // Handle actions #CopyMessage
    // 1. Select row and show "Copy" menu
    func messageShowMenuAction(gestureRecognizer: UITapGestureRecognizer) {
        let twoTaps = (gestureRecognizer.numberOfTapsRequired == 2)
        let doubleTap = (twoTaps && gestureRecognizer.state == .Ended)
        let longPress = (!twoTaps && gestureRecognizer.state == .Began)
        if doubleTap || longPress {
            let pressedIndexPath = tableView.indexPathForRowAtPoint(gestureRecognizer.locationInView(tableView))!
            tableView.selectRowAtIndexPath(pressedIndexPath, animated: false, scrollPosition: .None)
            
            let menuController = UIMenuController.sharedMenuController()
            let bubbleImageView = gestureRecognizer.view!
            menuController.setTargetRect(bubbleImageView.frame, inView: bubbleImageView.superview!)
            menuController.menuItems = [UIMenuItem(title: "Copy", action: "messageCopyTextAction:")]
            menuController.setMenuVisible(true, animated: true)
        }
    }
    // 2. Copy text to pasteboard
    func messageCopyTextAction(menuController: UIMenuController) {
        let selectedIndexPath = tableView.indexPathForSelectedRow()
        let selectedMessage = loadedMessages[selectedIndexPath!.section][selectedIndexPath!.row-1]
        UIPasteboard.generalPasteboard().string = selectedMessage.text
    }
    // 3. Deselect row
    func menuControllerWillHide(notification: NSNotification) {
        if let selectedIndexPath = tableView.indexPathForSelectedRow() {
            tableView.deselectRowAtIndexPath(selectedIndexPath, animated: false)
        }
        (notification.object as UIMenuController).menuItems = nil
    }
}

func createMessageSoundOutgoing() -> SystemSoundID {
    var soundID: SystemSoundID = 0
    let soundURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "MessageOutgoing", "aiff", nil)
    AudioServicesCreateSystemSoundID(soundURL, &soundID)
    return soundID
}

// Only show "Copy" when editing `textView` #CopyMessage
class InputTextView: UITextView {
    override func canPerformAction(action: Selector, withSender sender: AnyObject!) -> Bool {
        if (delegate as NewChatViewController).tableView.indexPathForSelectedRow() != nil {
            return action == "messageCopyTextAction:"
        } else {
            return super.canPerformAction(action, withSender: sender)
        }
    }
    
    // More specific than implementing `nextResponder` to return `delegate`, which might cause side effects?
    func messageCopyTextAction(menuController: UIMenuController) {
        (delegate as NewChatViewController).messageCopyTextAction(menuController)
    }
}
