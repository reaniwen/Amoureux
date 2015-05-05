//
//  Detail.swift
//  ShotsApp
//
//  Created by Meng To on 2014-07-29.
//  Copyright (c) 2014 Meng To. All rights reserved.
//

import UIKit

class Detail: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    
    var data = Array<Dictionary<String,String>>()
    var number = 0
    var image = UIImage()
    
    
    @IBAction func dismissNav(sender: AnyObject?){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
        
        backButton.alpha = 0
        
        let recognizer = DBPathRecognizer(sliceCount: 8, deltaMove: 16.0)
        
        let maxy3 = Detail.customFilter(self)(.Maximum, .LastPointY, 0.3)
        let miny3 = Detail.customFilter(self)(.Minimum, .LastPointY, 0.3)
        let maxy7 = Detail.customFilter(self)(.Maximum, .LastPointY, 0.7)
        let miny7 = Detail.customFilter(self)(.Minimum, .LastPointY, 0.7)
        
        
        recognizer.addModel(PathModel(directions: [7, 1], datas:"A"))
        recognizer.addModel(PathModel(directions: [2,6,0,1,2,3,4,0,1,2,3,4], datas:"B"))
        recognizer.addModel(PathModel(directions: [4,3,2,1,0], datas:"C"))
        recognizer.addModel(PathModel(directions: [2,6,7,0,1,2,3,4], datas:"D", filter:miny7))
        recognizer.addModel(PathModel(directions: [4,3,2,1,0,4,3,2,1,0], datas:"E"))
        recognizer.addModel(PathModel(directions: [4,2], datas:"F"))
        recognizer.addModel(PathModel(directions: [4,3,2,1,0,7,6,5,0], datas:"G", filter:miny3))
        recognizer.addModel(PathModel(directions: [2,6,7,0,1,2], datas:"H"))
        recognizer.addModel(PathModel(directions: [2], datas:"I"))
        recognizer.addModel(PathModel(directions: [2,3,4], datas:"J"))
        recognizer.addModel(PathModel(directions: [3,4,5,6,7,0,1], datas:"K"))
        recognizer.addModel(PathModel(directions: [2,0], datas:"L"))
        recognizer.addModel(PathModel(directions: [6,1,7,2], datas:"M"))
        recognizer.addModel(PathModel(directions: [6,1,6], datas:"N"))
        recognizer.addModel(PathModel(directions: [4,3,2,1,0,7,6,5,4], datas:"O", filter:maxy3))
        recognizer.addModel(PathModel(directions: [2,6,7,0,1,2,3,4], datas:"P", filter:maxy7))
        recognizer.addModel(PathModel(directions: [4,3,2,1,0,7,6,5,4,0], datas:"Q", filter: maxy3))
        recognizer.addModel(PathModel(directions: [2,6,7,0,1,2,3,4,1], datas:"R"))
        recognizer.addModel(PathModel(directions: [4,3,2,1,0,1,2,3,4], datas:"S"))
        recognizer.addModel(PathModel(directions: [0,2], datas:"T"))
        recognizer.addModel(PathModel(directions: [2,1,0,7,6], datas:"U"))
        recognizer.addModel(PathModel(directions: [1,7,0], datas:"V"))
        recognizer.addModel(PathModel(directions: [2,7,1,6], datas:"W"))
        recognizer.addModel(PathModel(directions: [1,0,7,6,5,4,3], datas:"X"))
        recognizer.addModel(PathModel(directions: [2,1,0,7,6,2,3,4,5,6,7], datas:"Y"))
        recognizer.addModel(PathModel(directions: [0,3,0], datas:"Z"))
        
        
        self.recognizer = recognizer
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        backButton.alpha = 1
        springScaleFrom(backButton!, -100, 0, 0.5, 0.5)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    var rawPoints:[Int] = []
    var recognizer:DBPathRecognizer?
    
    @IBOutlet weak var renderView: RenderView!
    
    enum FilterOperation {
        case Maximum
        case Minimum
    }
    
    enum FilterField {
        case LastPointX
        case LastPointY
    }
    
    
    
    
    func minLastY(cost:Int, infos:PathInfos, minValue:Double)->Int {
        var py:Double = (Double(infos.deltaPoints.last!.y) - Double(infos.boundingBox.top)) / Double(infos.height)
        return py < minValue ? Int.max : cost
    }
    
    func maxLastY(cost:Int, infos:PathInfos, maxValue:Double)->Int {
        var py:Double = (Double(infos.deltaPoints.last!.y) - Double(infos.boundingBox.top)) / Double(infos.height)
        return py > maxValue ? Int.max : cost
    }
    
    
    
    func customFilter(operation:FilterOperation,_ field:FilterField, _ value:Double)(cost:Int, infos:PathInfos)->Int {
        
        var pvalue:Double
        
        switch field {
        case .LastPointY:
            pvalue = (Double(infos.deltaPoints.last!.y) - Double(infos.boundingBox.top)) / Double(infos.height)
        case .LastPointX:
            pvalue = (Double(infos.deltaPoints.last!.x) - Double(infos.boundingBox.left)) / Double(infos.width)
        }
        
        switch operation {
        case .Maximum:
            return pvalue > value ? Int.max : cost
        case .Minimum:
            return pvalue < value ? Int.max : cost
        }
    }
    
    
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        rawPoints = []
        let touch = touches.allObjects[0] as? UITouch
        let location = touch!.locationInView(view)
        rawPoints.append(Int(location.x))
        rawPoints.append(Int(location.y))
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch = touches.allObjects[0] as? UITouch
        let location = touch!.locationInView(view)
        rawPoints.append(Int(location.x))
        rawPoints.append(Int(location.y))
        
        self.renderView.pointsToDraw = rawPoints
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        
        
        var path:Path = Path()
        path.addPointFromRaw(rawPoints)
        
        var gesture:PathModel? = self.recognizer!.recognizePath(path)
        

        if gesture != nil {
            var number = gesture!.datas as? String
            if (gesture!.datas as? String == "J"){
                dismissViewControllerAnimated(true, completion: nil)
            }
        }
        

    }
    
    
    
    
}


