//
//  ViewController.swift
//  DelegateWithNavigator
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

class ViewController: UIViewController, myDelegate {
    
    @IBOutlet weak var principalLabel: UILabel!
    
    @IBAction func mainButton(sender: UIButton) {
        
        //we got it the final instance in storyboard
        
        var secondController: SecondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SecondViewController") as SecondViewController
        secondController.data = "Text from superclass"
        //who is it delegate
        secondController.delegate = self
        //we do push to navigate
        self.navigationController?.pushViewController(secondController,
            animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func writeDateInLabel(data:NSString){
        self.principalLabel.text = data
    }
    
    
}

