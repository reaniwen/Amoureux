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
    
    
    @IBAction func close(segue: UIStoryboardSegue) {
        println("closed!")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
        
        backButton.alpha = 0
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        backButton.alpha = 1
        springScaleFrom(backButton!, -100, 0, 0.5, 0.5)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
