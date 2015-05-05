//
//  ViewController.swift
//  CoreImage
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
import CoreImage


class ViewController: UIViewController {
    
    
    //SLIDER TO FIRST AND SECOND FILTER
    //when you do slider value change
    //then push in filter button  "sepia" or "vignette" to apply it
    
    var sliderValue: Float = 0.0
    
    @IBOutlet weak var myImage: UIImageView!
    
    @IBAction func sepia(sender: UIButton) {
        applyfilter(1);
    }
    
    @IBAction func vignette(sender: UIButton) {
        applyfilter(2);
    }
    
    
    @IBAction func invert(sender: UIButton) {
        applyfilter(3);
    }
    
    @IBAction func photo(sender: UIButton) {
        applyfilter(4);
    }
    
    @IBAction func perspective(sender: UIButton) {
        applyfilter(5);
    }
    
    @IBAction func gaussian(sender: UIButton) {
        applyfilter(6);
    }
    
    @IBAction func slider(sender: UISlider) {
        
        sliderValue = sender.value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func applyfilter(numberFilter: Int) {
        
        let filePath : NSString = NSBundle.mainBundle().pathForResource("image", ofType: "jpg")!
        let fileUrl : NSURL = NSURL (fileURLWithPath: filePath)!
        let inputImage : CIImage = CIImage (contentsOfURL: fileUrl)
        
        switch numberFilter {
        case 1:
            var filter : CIFilter = CIFilter (name: "CISepiaTone")
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            filter.setValue(sliderValue, forKey: "InputIntensity")
            let outputImage : CIImage = filter.valueForKey(kCIOutputImageKey) as CIImage
            var img : UIImage = UIImage (CIImage: outputImage)!
            myImage.image = img
        case 2:
            var filter : CIFilter = CIFilter (name: "CIVignette")
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            filter.setValue(sliderValue, forKey: "InputRadius")
            filter.setValue(sliderValue, forKey: "InputIntensity")
            let outputImage : CIImage = filter.valueForKey(kCIOutputImageKey) as CIImage
            var img : UIImage = UIImage (CIImage: outputImage)!
            myImage.image = img
        case 3:
            var filter : CIFilter = CIFilter (name: "CIColorInvert")
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            let outputImage : CIImage = filter.valueForKey(kCIOutputImageKey) as CIImage
            var img : UIImage = UIImage (CIImage: outputImage)!
            myImage.image = img
        case 4:
            var filter : CIFilter = CIFilter (name: "CIPhotoEffectMono")
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            
            let outputImage : CIImage = filter.valueForKey(kCIOutputImageKey) as CIImage
            var img : UIImage = UIImage (CIImage: outputImage)!
            myImage.image = img
        case 5:
            var filter : CIFilter = CIFilter (name: "CIPerspectiveTransform")
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            
            let outputImage : CIImage = filter.valueForKey(kCIOutputImageKey) as CIImage
            var img : UIImage = UIImage (CIImage: outputImage)!
            myImage.image = img
        case 6:
            var filter : CIFilter = CIFilter (name: "CIGaussianBlur")
            filter.setValue(inputImage, forKey: kCIInputImageKey)
            
            let outputImage : CIImage = filter.valueForKey(kCIOutputImageKey) as CIImage
            var img : UIImage = UIImage (CIImage: outputImage)!
            myImage.image = img
        default:
            println("test")
            
        }
        
        
        
        
        
        
        
    }
    
    
    
    
}
