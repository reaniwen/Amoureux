//
//  ViewController.swift
//  Amoureux
//
//  Created by Rean on 2/5/15.
//  Copyright (c) 2015 NYU. All rights reserved.
//

import Foundation

class ChatLoginViewController : UIViewController, UIActionSheetDelegate {
    
    @IBOutlet var btLogin: UIButton!
    
    var ref: Firebase!
    var authHelper: TwitterAuthHelper!
    var accounts: [ACAccount]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Firebase(url:"https://chatapp-hongye.firebaseio.com")
        authHelper = TwitterAuthHelper(firebaseRef: ref, twitterAppId: "bPRnzhcLJxr1gSgcpDWXeXSm3")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        title = "Fire Chat"
    }
    
    @IBAction func login(sender: UIButton) {
        self.authWithTwitter()
    }

    func authWithTwitter() {
        authHelper.selectTwitterAccountWithCallback { (error, accounts) -> Void in
            self.accounts = accounts as [ACAccount]
            self.handleMultipleTwitterAccounts(self.accounts)
        }
    }
    
    func authAccount(account: ACAccount) {
        authHelper.authenticateAccount(account, withCallback: { (error, authData) -> Void in
            if error != nil {
                // There was an error authenticating
            } else {
                // We have an authenticated Twitter user
                NSLog("%@", authData)
                // segue to chat
                self.performSegueWithIdentifier("TWITTER_LOGIN", sender: authData)
            }
        })
    }
    
    func selectTwitterAccount(accounts: [ACAccount]) {
        var selectUserActionSheet = UIActionSheet(title: "Select Twitter Account", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Destruct", otherButtonTitles: "Other")
        
        for account in accounts {
            selectUserActionSheet.addButtonWithTitle(account.username)
        }
        
        selectUserActionSheet.cancelButtonIndex = selectUserActionSheet.addButtonWithTitle("Cancel")
        selectUserActionSheet.showInView(self.view);
    }
    
    func handleMultipleTwitterAccounts(accounts: [ACAccount]) {
        switch accounts.count {
        case 0:
            UIApplication.sharedApplication().openURL(NSURL(string: "https://twitter.com/signup")!)
        case 1:
            self.authAccount(accounts[0])
        default:
            self.selectTwitterAccount(accounts)
        }
    }
    
    @IBAction func backBar(sender: UIBarButtonItem) {
        (tabBarController as TabBarController).sidebar.showInViewController(self, animated: true)
    }
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        let currentTwitterHandle = actionSheet.buttonTitleAtIndex(buttonIndex)
        for acc in accounts {
            if acc.username == currentTwitterHandle {
                self.authAccount(acc)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var messagesVc = segue.destinationViewController as MessagesViewController
        if let authData = sender as? FAuthData {
            messagesVc.user = authData
            messagesVc.ref = ref
            messagesVc.sender = authData.providerData["username"] as? NSString
        }
    }
}