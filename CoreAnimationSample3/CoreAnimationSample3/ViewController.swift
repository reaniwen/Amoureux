//
//  ViewController.swift
//  CoreAnimationSample3
//
//  Created by Carlos Butron on 02/12/14.
//  Copyright (c) 2015 Carlos Butron. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public
//  License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later
//  version.
//  This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied
//  warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
//  You should have received a copy of the GNU General Public License along with this program. If not, see
//  http:/www.gnu.org/licenses/.
//

import UIKit

class ViewController: UIViewController {
    
    var position = true
    
    @IBOutlet weak var image: UIImageView!
    @IBAction func animate(sender: UIButton) {
        
        
        
        if (position){  //SAMPLE2
            
            var animation:CABasicAnimation! = CABasicAnimation(keyPath:"position")
            
            
            animation.toValue = NSValue(CGPoint:CGPointMake(160, 200))
            
            //SAMPLE2
            animation.fillMode = kCAFillModeForwards
            animation.removedOnCompletion = false
            
            
            var resizeAnimation:CABasicAnimation = CABasicAnimation(keyPath:"bounds.size")
            resizeAnimation.toValue = NSValue(CGSize:CGSizeMake(240, 60))
            
            
            
            
            //SAMPLE2
            resizeAnimation.fillMode = kCAFillModeForwards
            resizeAnimation.removedOnCompletion = false
            
            
            //SAMPLE3
            
            UIView.animateWithDuration(5.0, animations:{
                //PROPERTIES CHANGES TO ANIMATE
                self.image.alpha = 0.0
                //alpha to zero in 5 seconds
                }, completion: {(value: Bool) in
                    //when finished animation do this..
                    self.image.alpha = 1.0
                    self.image.layer.addAnimation(animation, forKey: "position")
                    
                    self.image.layer.addAnimation(resizeAnimation, forKey: "bounds.size")
            })
            
            
            
            
            
            
            position = false
        }
        else{
            
            var animation:CABasicAnimation! = CABasicAnimation(keyPath:"position")
            
            animation.fromValue = NSValue(CGPoint:CGPointMake(160, 200))
            
            //SAMPLE2
            animation.fillMode = kCAFillModeForwards
            animation.removedOnCompletion = false
            
            var resizeAnimation:CABasicAnimation = CABasicAnimation(keyPath:"bounds.size")
            resizeAnimation.fromValue = NSValue(CGSize:CGSizeMake(240, 60))
            
            //SAMPLE2
            resizeAnimation.fillMode = kCAFillModeForwards
            resizeAnimation.removedOnCompletion = false
            
            image.layer.addAnimation(animation, forKey: "position")
            
            image.layer.addAnimation(resizeAnimation, forKey: "bounds.size")
            
            position = true
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

