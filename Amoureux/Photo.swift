//
//  Photo.swift
//  Amoureux
//
//  Created by Xiao Zhang on 4/18/15.
//  Copyright (c) 2015 Firebase. All rights reserved.
//

import Foundation

class Photo : NSObject, JSQMessageData {
    var title_: String
    var text_: String
    var sender_: String
    var date_: NSDate
    var imageUrl_: String?
    
    convenience init(title: String?, text: String?, sender: String?) {
        self.init(title: title, text: text, sender: sender, imageUrl: nil)
    }
    
    init(title: String?, text: String?, sender: String?, imageUrl: String?) {
        self.title_ = title!
        self.text_ = text!
        self.sender_ = sender!
        self.date_ = NSDate()
        self.imageUrl_ = imageUrl
    }
    
    func title() -> String! {
        return title_;
    }
    
    func text() -> String! {
        return text_;
    }
    
    func sender() -> String! {
        return sender_;
    }
    
    func date() -> NSDate! {
        return date_;
    }
    
    func imageUrl() -> String? {
        return imageUrl_;
    }
}