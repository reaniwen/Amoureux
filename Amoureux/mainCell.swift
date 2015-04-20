//
//  mainCell.swift
//  twitterApp
//
//  Created by Valsamis Elmaliotis on 3/1/15.
//  Copyright (c) 2015 Valsamis Elmaliotis. All rights reserved.
//

import UIKit

class mainCell: UITableViewCell {
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var profileLbl: UILabel!
    @IBOutlet weak var messageTxt: UITextView!
    @IBOutlet weak var tweetImg: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let theWidth = UIScreen.mainScreen().bounds.width
        
        contentView.frame = CGRectMake(0, 0, theWidth, 90)
        
        imgView.center = CGPointMake(35, 35)
        imgView.layer.cornerRadius = imgView.frame.size.width / 2
        imgView.clipsToBounds = true
        profileLbl.frame = CGRectMake(70, 5, theWidth-75, 20)
        messageTxt.frame = CGRectMake(70, 22, theWidth-75, 60)
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
