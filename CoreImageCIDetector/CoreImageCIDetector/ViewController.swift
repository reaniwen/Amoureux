//
//  ViewController.swift
//  CoreImageCIDetector
//
//  Created by Carlos Butron on 07/12/14.
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
    
    var filePath: NSString = ""
    var fileNameAndPath = NSURL()
    var image = CIImage()
    
    override func viewDidLoad() {
        filePath = NSBundle.mainBundle().pathForResource("emotions", ofType: "jpg")!
        fileNameAndPath = NSURL.fileURLWithPath(filePath)!
        image = CIImage(contentsOfURL:fileNameAndPath)
        var context = CIContext(options: nil)
        var options = NSDictionary(object: CIDetectorAccuracyHigh, forKey: CIDetectorAccuracy)
        var detector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: options)
        var features: NSArray = detector.featuresInImage(image, options: [CIDetectorSmile:true,CIDetectorEyeBlink:true])
        var imageView = UIImageView(image: UIImage(named: "emotions.jpg"))
        self.view.addSubview(imageView)
        
        //auxiliar view to invert.
        var vistAux = UIView(frame: imageView.frame)
        for faceFeature in features {
            
            //Detection
            var smile = faceFeature.hasSmile
            var rightEyeBlinking = faceFeature.rightEyeClosed
            var leftEyeBlinking = faceFeature.leftEyeClosed
            
            //Location face
            let faceRect = faceFeature.bounds
            var faceView = UIView(frame: faceRect)
            faceView.layer.borderWidth = 2
            faceView.layer.borderColor = UIColor.redColor().CGColor
            var faceWidth:CGFloat = faceRect.size.width
            var faceHeight:CGFloat = faceRect.size.height
            vistAux.addSubview(faceView)
            
            //Location smile
            if (smile==true) {
                var smileView = UIView(frame: CGRectMake(faceFeature.mouthPosition.x-faceWidth*0.18, faceFeature.mouthPosition.y-faceHeight*0.1, faceWidth*0.4, faceHeight*0.2))
                smileView.layer.cornerRadius = faceWidth*0.1
                smileView.layer.borderWidth = 2
                smileView.layer.borderColor = UIColor.greenColor().CGColor
                smileView.layer.backgroundColor = UIColor.greenColor().CGColor
                smileView.layer.opacity = 0.5
                vistAux.addSubview(smileView)
            }
            
            //Location right eye
            
            var rightEyeView = UIView(frame: CGRectMake(faceFeature.rightEyePosition.x-faceWidth*0.2, faceFeature.rightEyePosition.y-faceWidth*0.2, faceWidth*0.4, faceWidth*0.4))
            rightEyeView.layer.cornerRadius = faceWidth*0.2
            rightEyeView.layer.borderWidth = 2
            rightEyeView.layer.borderColor = UIColor.redColor().CGColor
            if (rightEyeBlinking==true){
                rightEyeView.layer.backgroundColor = UIColor.yellowColor().CGColor
            }else{
                rightEyeView.layer.backgroundColor = UIColor.redColor().CGColor
            }
            rightEyeView.layer.opacity = 0.5
            vistAux.addSubview(rightEyeView)
            
            
            //Location left eye
            
            var leftEyeView = UIView(frame: CGRectMake(faceFeature.leftEyePosition.x-faceWidth*0.2, faceFeature.leftEyePosition.y-faceWidth*0.2, faceWidth*0.4, faceWidth*0.4))
            leftEyeView.layer.cornerRadius = faceWidth*0.2
            leftEyeView.layer.borderWidth = 2
            leftEyeView.layer.borderColor = UIColor.blueColor().CGColor
            if (leftEyeBlinking==true){
                leftEyeView.layer.backgroundColor = UIColor.yellowColor().CGColor
            }else{
                leftEyeView.layer.backgroundColor = UIColor.blueColor().CGColor
            }
            leftEyeView.layer.opacity = 0.5
            vistAux.addSubview(leftEyeView)
            
            
            
            
        }
        
        self.view.addSubview(vistAux)
        
        //Invert coords
        vistAux.transform = CGAffineTransformMakeScale(1, -1)
        
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

