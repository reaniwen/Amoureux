//
//  Phototest.swift
//  Amoureux
//
//  Created by Xiao Zhang on 4/18/15.
//  Copyright (c) 2015 Firebase. All rights reserved.
//

import Foundation

class Phototest: JSQMessagesViewController {
// *** STEP 1: STORE FIREBASE REFERENCES
    var messagesRef: Firebase!
    var senderImageUrl: String!
    var photos = [Photo]()
    
func setupFirebase() {
    // *** STEP 2: SETUP FIREBASE
    messagesRef = Firebase(url: "https://chatapp-hongye.firebaseio.com/photowall")
    
    // *** STEP 4: RECEIVE MESSAGES FROM FIREBASE (limited to latest 25 messages)
    messagesRef.queryLimitedToNumberOfChildren(25).observeEventType(FEventType.ChildAdded, withBlock: { (snapshot) in
        let title = snapshot.value["title"] as? String
        let text = snapshot.value["text"] as? String
        let sender = snapshot.value["sender"] as? String
        let imageUrl = snapshot.value["imageUrl"] as? String
        
        let photo = Photo(title: title, text: text, sender: sender, imageUrl: imageUrl)
        self.photos.append(photo)
        self.finishReceivingMessage()
    })
}

func sendMessage(title: String!, text: String!, sender: String!) {
    // *** STEP 3: ADD A MESSAGE TO FIREBASE
    messagesRef.childByAutoId().setValue([
        "title":title,
        "text":text,
        "sender":sender,
        "imageUrl":senderImageUrl
        ])
}

}